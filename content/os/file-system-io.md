---
title: "OS: File System Internals and I/O Scheduling"
date: 2024-04-04
draft: false
weight: 6
---

# 🧩 Question: Explain how the Linux ext4 file system manages files. What happens at the OS level when Java writes to a file? When should you use `fsync()` and what is write-ahead logging?

## 🎯 What the interviewer is testing
- File system internals: inodes, directories, data blocks
- OS write path: page cache → disk
- Durability guarantees: fsync, O_SYNC, O_DIRECT
- How databases use WAL (Write-Ahead Logging)

---

## 🧠 Deep Explanation

### 1. ext4 File System Structure

- **Superblock**: Contains file system metadata (size, inode count, block size)
- **Block Group**: File system divided into groups; each has its own inode table and data blocks
- **Inode**: Data structure storing: file size, owner, permissions, timestamps, pointers to data blocks
  - An inode does NOT store the file name (files don't know their own name)
- **Directory Entry (dentry)**: Maps file name → inode number
- **Data Blocks**: 4KB chunks storing actual file content

**Finding a file**: Path(`/home/user/test.txt`) → dentry for `/` → dentry for `home` → ... → inode 12345 → data blocks.

### 2. OS Write Path (Durability Ladder)

```
Java FileOutputStream.write(bytes)
    ↓ (user space → kernel syscall)
write() syscall → Kernel Page Cache
    ↓ (async, background)
OS flushed by pdflush/kswapd or when dirty_ratio exceeded
    ↓
Disk write (disk cache)
    ↓ (if disk has battery-backed write cache, this is "durable")
Persistent storage
```

**Java `file.write()` → page cache ONLY** — NOT durable until `fsync()`.

### 3. fsync() and fdatasync()

- **`fsync(fd)`**: Forces all dirty pages (data + inode metadata) from page cache to disk.
- **`fdatasync(fd)`**: Forces only data pages (not metadata like mtime). Faster.
- **Postgres/MySQL use `fdatasync`** in the WAL write path for durability.

### 4. Write-Ahead Logging (WAL)

Before modifying data files, databases write all changes to a sequential WAL log file first.

**Why?**
- WAL writes are sequential (fast) vs data file random writes (slow)
- On crash: replay WAL to reconstruct committed but not-yet-written data
- Enables **ACID durability** without `fsync` on every data write

---

## ✅ Ideal Answer

- Java `write()` goes to kernel **page cache** — not durable until OS flushes or `fsync()`.
- Use `fsync()` for durability-critical data (transaction commit, checkpoint).
- `O_DIRECT` bypasses page cache entirely — used by databases to control buffering.
- WAL: log changes sequentially first → apply to data files async → crash recovery via WAL replay.

---

## 💻 Java Code

```java
import java.io.*;
import java.nio.*;
import java.nio.channels.*;
import java.nio.file.*;

public class FileSystemDemo {

    // ❌ NOT durable — write to page cache; lost if power failure
    public void writeUnsafe(String path, byte[] data) throws IOException {
        Files.write(Path.of(path), data); // Goes to kernel page cache
    }

    // ✅ DURABLE — force to disk (fsync equivalent)
    public void writeDurable(String path, byte[] data) throws IOException {
        try (FileChannel channel = FileChannel.open(
                Path.of(path),
                StandardOpenOption.WRITE,
                StandardOpenOption.CREATE,
                StandardOpenOption.SYNC // O_SYNC: every write = fsync (slow)
        )) {
            channel.write(ByteBuffer.wrap(data));
        }
    }

    // ✅ RECOMMENDED PATTERN: Batch writes, fsync at the end (e.g., transaction commit)
    public void writeBatchAndSync(String path, List<byte[]> records) throws IOException {
        try (FileChannel channel = FileChannel.open(Path.of(path),
                StandardOpenOption.WRITE, StandardOpenOption.CREATE)) {

            for (byte[] record : records) {
                channel.write(ByteBuffer.wrap(record)); // All to page cache
            }

            channel.force(true); // fsync(fd) — flush both data AND metadata
            // channel.force(false) = fdatasync(fd) — data only, faster
        }
    }

    // Memory-mapped files — efficient for large read-write workloads
    public void memoryMappedWrite(String path) throws IOException {
        try (RandomAccessFile raf = new RandomAccessFile(path, "rw");
             FileChannel channel = raf.getChannel()) {

            MappedByteBuffer buffer = channel.map(
                FileChannel.MapMode.READ_WRITE, 0, 1024 * 1024 // 1MB mapped
            );

            buffer.putInt(42);    // Direct write to mapped memory
            buffer.putDouble(3.14);
            buffer.force();       // Flush to disk (equivalent to msync)
        }
    }
}
```

---

## ⚠️ Common Mistakes
- Thinking Java `PrintWriter.flush()` is equivalent to `fsync()` — it only flushes Java buffers to the OS; OS still needs to flush to disk
- Using `O_SYNC` for every write in a WAL — extremely slow; batch writes + fsync at commit is the correct pattern
- Forgetting that hard link vs symlink difference involves inodes (hard link: points to same inode; symlink: points to file name)
- Assuming file rename is atomic (on same file system with rename(2) syscall — it is. Across filesystems — it's not)

---

## 🔄 Follow-up Questions
1. **What is a journal in ext4?** (Journals writes before applying to the file system. If crash mid-write, journal replay brings FS to consistent state. Types: writethrough, ordered, data journal.)
2. **What is `mmap()` and why do databases use it?** (Maps a file into process virtual address space; reads/writes directly to file via memory ops; OS handles paging. Used by RocksDB, SQLite, some Redis persistence.)
3. **What is direct I/O (O_DIRECT)?** (Bypasses page cache completely; reads/writes go directly to disk. Used by databases to control their own buffering and avoid double-buffering overhead.)
