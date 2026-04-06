---
author: "sagar ved"
title: "OS: Hard Links vs. Soft Links"
date: 2024-04-04
draft: false
weight: 18
---

# 🧩 Question: What is the difference between a Hard Link and a Soft Link (Symbolic Link)? Explain their internal representation in the Inode table.

## 🎯 What the interviewer is testing
- Internal file system organization.
- Relationship between filenames and Inodes.
- Handling of file deletion and cross-system linking.

---

## 🧠 Deep Explanation

### 1. Inodes Recap:
An Inode stores metadata and addresses of data blocks. It DOES NOT store the filename.

### 2. Hard Link:
- Multiple filenames pointing to the **SAME Inode**.
- Since they point to the same object, they share permissions, timestamps, and data.
- **Constraint**: Cannot link across different file systems. Cannot link directories.
- **Deletion**: Increment/decrement the "Link Count" in the inode. The file is only deleted when count reaches **0**.

### 3. Soft Link (Symlink):
- A special file that contains a **string** of another file's path.
- It has its own unique Inode.
- **Benefit**: Can link across file systems and can link directories.
- **Deletion**: If the original file is deleted, the symlink becomes "Dangling" (it points to a path that doesn't exist).

---

## ✅ Ideal Answer
A hard link is a second name for the same physical data (inode); deleting one doesn't affect the other until the last one is gone. A soft link is a shortcut containing a path; if the destination moves or is deleted, the link breaks. Hard links are more performant and robust for local files, while soft links are more flexible across the system.

---

## 💻 Manual Check (Shell)
```bash
# Create hard link
ln file.txt hard.txt
ls -i # See same inode number

# Create soft link
ln -s file.txt soft.txt
ls -i # See different inode number
```

---

## 🔄 Follow-up Questions
1. **Can you hard link a directory?** (Generally no, because it can create circular loops that break filesystem traversal tools.)
2. **What happens if you move the original file?** (Hard link still works; soft link breaks.)
3. **What is a "Dangling" pointer?** (In this context, a symlink whose target no longer exists.)
