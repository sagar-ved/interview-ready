---
author: "sagar ved"
title: "OS: Inter-Process Communication (IPC)"
date: 2024-04-04
draft: false
weight: 8
---

# 🧩 Question: How do processes communicate in Linux? Compare Pipes, Message Queues, Shared Memory, and Sockets.

## 🎯 What the interviewer is testing
- Fundamental OS concepts.
- Performance implications of different IPC mechanisms.
- Synchronization requirements (Mutex/Semaphores).

---

## 🧠 Deep Explanation

### 1. Pipes & FIFOs:
- Unidirectional.
- Efficient for small, sequential data.
- **Anonymous Pipes**: Parent/child only.
- **Named Pipes (FIFOs)**: Visible in file system, any processes can use.

### 2. Message Queues:
- Asynchronous.
- Discrete messages rather than a stream of bytes.
- OS managed; survives process exit until explicitly deleted.

### 3. Shared Memory:
- **Fastest IPC**.
- Two or more processes map the same physical memory segment into their virtual address spaces.
- **Caveat**: No built-in synchronization. You MUST use semaphores or mutexes to prevent race conditions.

### 4. Sockets:
- Bi-directional.
- Works across different machines (Network sockets) or locally (Unix Domain Sockets).
- Highest overhead due to network stack, but most flexible.

---

## ✅ Ideal Answer
Shared memory is the fastest because it avoids copying data between user and kernel space. However, it requires careful synchronization. Sockets are the most versatile as they support communication between different systems. For simple producers-consumers on the same machine, Pipes are the most common choice.

---

## 💻 Java Integration
In Java, we typically use Sockets for IPC, but for high performance on the same machine, we can use **MappedByteBuffer** (Memory Mapped Files) which acts as shared memory.

```java
import java.io.RandomAccessFile;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;

public class SharedMemoryProcessA {
    public static void main(String[] args) throws Exception {
        RandomAccessFile file = new RandomAccessFile("shared.dat", "rw");
        MappedByteBuffer buffer = file.getChannel().map(FileChannel.MapMode.READ_WRITE, 0, 1024);

        buffer.putInt(0, 42); // Write 42 at index 0
        System.out.println("Process A wrote 42 to shared memory.");
    }
}
```

---

## ⚠️ Common Mistakes
- Forgetting that Shared Memory requires a synchronization mechanism.
- Confusing Pipes with Sockets.
- Thinking IPC only happens on a single machine.

---

## 🔄 Follow-up Questions
1. **What is a Semaphore?** (A signaling mechanism used to control access to shared resources.)
2. **Unix Domain Sockets vs TCP Sockets?** (Unix domain sockets are faster for local communication as they bypass the full TCP/IP overhead.)
3. **What is D-Bus?** (A high-level IPC used in Linux desktops/services for message passing.)
