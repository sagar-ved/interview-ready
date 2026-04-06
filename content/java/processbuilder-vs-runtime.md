---
author: "sagar ved"
title: "Java: ProcessBuilder vs. Runtime.exec"
date: 2024-04-04
draft: false
weight: 42
---

# 🧩 Question: Why should you prefer `ProcessBuilder` over `Runtime.getRuntime().exec()`?

## 🎯 What the interviewer is testing
- Modern API awareness.
- Handling shell arguments and environment variables.
- Controlling stream redirection.

---

## 🧠 Deep Explanation

### 1. The old way (`Runtime.exec`):
- **Problem**: It accepts a single string and tries to tokenise it. This often breaks if your file path has **spaces** or special characters.
- **Problem**: Managing environment variables and working directories is clunky.

### 2. The new way (`ProcessBuilder` - Java 5+):
- **Command**: Accepts a `List<String>`, which is much safer for arguments.
- **Redirection**: Easily pipe `stdout` or `stderr` to files or the parent process with one line: `pb.inheritIO()`.
- **Environment**: Provides a clean `Map<String, String>` to modify variables before starting.

### 3. Java 9 Improvements:
`ProcessHandle` was added to kill processes, check their PID, and observe their total CPU usage without native code.

---

## ✅ Ideal Answer
`ProcessBuilder` is the modern standard for interacting with external operating system commands. Unlike the older `Runtime.exec` API, which struggles with complex command strings and redirects, `ProcessBuilder` provides a structured, fluent interface for managing environment variables and input/output streams. It is essentially a safer and more maintainable abstraction for shell integration in Java.

---

## 💻 Java Code
```java
ProcessBuilder pb = new ProcessBuilder("ls", "-al", "/tmp/my folder");
pb.directory(new File("/tmp")); // Set Working Directory
pb.redirectErrorStream(true); // Merge stderr into stdout
Process p = pb.start();
```

---

## 🔄 Follow-up Questions
1. **What is a "Pipeline"?** (Java 9 introduced `ProcessBuilder.startPipeline(List<ProcessBuilder>)` to chain processes like `cat file | grep text`.)
2. **Zombie Processes?** (If you don't wait for the process or read its output stream, it might stay "zombie," occupying a slot in the OS process table. Use `p.waitFor()`.)
3. **Can you set a Timeout?** (Yes, `p.waitFor(10, TimeUnit.SECONDS)`.)
