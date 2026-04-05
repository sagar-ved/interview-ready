---
title: "Java: Checked vs. Unchecked Exceptions"
date: 2024-04-04
draft: false
weight: 39
---

# 🧩 Question: What is the difference between Checked and Unchecked Exceptions? When would you prefer one over the other?

## 🎯 What the interviewer is testing
- Java Exception Hierarchy (`Throwable -> Exception -> RuntimeException`).
- Understanding of compile-time vs run-time errors.
- Clean code and API design principles.

---

## 🧠 Deep Explanation

### 1. Checked Exceptions (Extend `Exception`):
- **Forced**: You MUST catch them or declare them in the method signature (`throws`).
- **Logic**: Used for **Recoverable Conditions** or external errors (e.g., `IOException`, `SQLException`). You can't control if a file exists, so Java forces you to handle the possibility that it doesn't.

### 2. Unchecked Exceptions (Extend `RuntimeException`):
- **Optional**: No compiler requirement to catch.
- **Logic**: Used for **Programming Errors** (e.g., `NullPointerException`, `IndexOutOfBoundsException`). These represent bugs that the programmer SHOULD have prevented through logic, not try-catch blocks.

---

## ✅ Ideal Answer
Checked exceptions are for cases where failure is an expected part of interacting with the outside world, requiring the caller to decide on a recovery path. Unchecked exceptions signify logical failures that should ideally be fixed at the code level rather than caught at runtime. In modern frameworks like Spring, unchecked exceptions are often preferred to keep APIs clean and minimize boilerplate code.

---

## 🏗️ Hierarchy Visual:
- **Throwable**
  - **Error** (JVM crash, OutOfMemory - Unrecoverable)
  - **Exception**
    - **RuntimeException** (Unchecked)
    - (Everything else) (Checked)

---

## 🔄 Follow-up Questions
1. **Can you catch an `Error`?** (Technically yes, but it's generally useless as the system is already unstable.)
2. **What is "Exception Tunneling"?** (Wrapping a checked exception inside a RuntimeException to pass it through an interface that doesn't declare it.)
3. **What is the "Try-with-Resources" benefit?** (Ensures `close()` is called on AutoCloseable resources automatically, preventing leaks.)
