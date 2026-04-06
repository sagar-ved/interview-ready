---
author: "sagar ved"
title: "OS: System Calls and User Space vs Kernel Space"
date: 2024-04-04
draft: false
weight: 7
---

# 🧩 Question: Explain the difference between user space and kernel space. What happens when Java makes a `socket.read()` call? Walk through the complete path from Java code to hardware.

## 🎯 What the interviewer is testing
- User space vs kernel space boundary
- System call overhead and its implications
- Context switching between user and kernel mode
- Why system calls are expensive and how to minimize them

---

## 🧠 Deep Explanation

### 1. User Space vs Kernel Space

Modern operating systems split memory into two protection domains:

**Kernel Space (Ring 0)**:
- OS kernel runs here: drivers, scheduler, memory management
- Unrestricted access to hardware
- Faults here = kernel panic (system crash)

**User Space (Ring 3)**:
- User programs (Java, Python, etc.) run here
- Restricted hardware access — must ask kernel via system calls
- Faults here = segfault (process killed, not OS crash)

### 2. System Call Mechanism

1. User program calls a library function (e.g., `read()` in glibc)
2. Library sets up syscall number and arguments in registers
3. Execute `syscall` instruction (x86-64) or `SWI` (ARM)
4. CPU switches to Ring 0 (kernel mode)
5. Kernel validates arguments and carries out the operation
6. Result placed in registers; CPU returns to Ring 3 (user mode)
7. Library unpacks result and returns to caller

**Cost**: A system call takes ~100-1000 CPU cycles (vs normal function call: ~5 cycles). This is why **batching I/O** matters.

### 3. Java Socket Read Full Path

```
Java: socket.read(buffer)
    ↓ Java NIO → native method call
C JNI: recv(fd, buf, len, flags)
    ↓ glibc wrapper
syscall: SYS_RECVFROM
    ↓ CPU mode switch to Ring 0
Kernel: sock_recvmsg() → TCP stack → wait if no data available
    ↓ DMA: data from NIC → kernel buffer (sk_buff)
Kernel: copy from sk_buff → user space buffer (copy_to_user)
    ↓ CPU returns to Ring 3
Java: bytes received in ByteBuffer
```

### 4. Minimizing Syscall Overhead

- **Batching**: Write many records in one `write()` instead of one per record
- **Buffering**: `BufferedInputStream` reduces `read()` syscall frequency
- **Memory-mapped files**: Avoid `read()`/`write()` syscalls — access file like memory
- **io_uring (Linux 5.1+)**: Ring buffer between user/kernel — submit batch of I/O requests, collect results, WITHOUT a syscall per operation

---

## 💻 Java Code

```java
import java.io.*;
import java.nio.*;
import java.nio.channels.*;
import java.net.*;

public class SystemCallDemo {

    // ❌ High syscall frequency: one write per line
    public void writeSlowly(String path, List<String> lines) throws IOException {
        try (FileWriter fw = new FileWriter(path)) {
            for (String line : lines) {
                fw.write(line + "\n"); // Potentially one syscall per write
            }
        }
    }

    // ✅ Buffered: kernel buffer absorbs small writes, fewer syscalls
    public void writeBuffered(String path, List<String> lines) throws IOException {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(path), 64 * 1024)) {
            for (String line : lines) {
                bw.write(line);
                bw.newLine();
            }
            bw.flush(); // One large write syscall at flush
        }
    }

    // ✅ Direct ByteBuffer for minimal copies (zero-copy NIO)
    public void writeDirectBuffer(String path, byte[] data) throws IOException {
        try (FileChannel channel = FileChannel.open(Path.of(path),
                StandardOpenOption.WRITE, StandardOpenOption.CREATE)) {
            ByteBuffer buffer = ByteBuffer.wrap(data);
            channel.write(buffer); // Single write syscall
        }
    }

    // Demonstrate strace-equivalent: count reads per operation pattern
    public void compareReadPatterns() throws Exception {
        Socket socket = new Socket("example.com", 80);

        // Unbuffered: many small reads — many syscalls
        InputStream raw = socket.getInputStream();
        // Each raw.read(1) = one SYS_RECV syscall!

        // Buffered: one large read, many logical reads from buffer
        BufferedInputStream buffered = new BufferedInputStream(raw, 8192);
        // buffered.read(1) reads 8192 bytes from socket in ONE syscall,
        // then serves subsequent reads from the Java buffer
    }
}
```

---

## ⚠️ Common Mistakes
- Calling `read()` byte-by-byte on an unbuffered stream (one syscall per byte — huge overhead)
- Thinking Java's `flush()` guarantees disk durability (it doesn't — it only sends data to OS; use `fsync()` for durability)
- Confusing JVM bytecode interpretation with native code execution — JVM itself is a user-space process

---

## 🔄 Follow-up Questions
1. **What is VDSO (Virtual Dynamic Shared Object)?** (Kernel maps read-only data into user space — some frequent syscalls like `gettimeofday()` are handled entirely in user space via VDSO, avoiding the mode switch.)
2. **What is seccomp and how does it affect system calls?** (Secure Computing: restricts which syscalls a process can make — used in containers/Docker to limit attack surface.)
3. **How does `sendfile()` different from `read()+write()`?** (sendfile: kernel copies directly from file descriptor to socket — avoids user-space intermediate buffer. Zero-copy for file serving — used by Nginx, Kafka.)
