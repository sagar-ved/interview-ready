---
author: "sagar ved"
title: "Spring: Global Exception Handling"
date: 2024-04-04
draft: false
weight: 10
---

# 🧩 Question: How do you implement global exception handling in a Spring Boot REST API? Explain `@ControllerAdvice`.

## 🎯 What the interviewer is testing
- Clean Code (DRY - Don't Repeat Yourself).
- Consistent API Error Responses.
- Handling different status codes (400, 404, 500) gracefully.

---

## 🧠 Deep Explanation

### 1. The Strategy:
Instead of `try-catch` in every controller method, we use a central interceptor.

### 2. @ControllerAdvice / @RestControllerAdvice:
A specialized `@Component` that acts as an "interceptor" for exceptions thrown by any Controller.
- **`@ExceptionHandler`**: A method inside the advice that handles a specific exception (e.g. `UserNotFoundException`).
- **Standard Format**: Returns a `ResponseEntity` with a consistent JSON body (ErrorCode, Message, Timestamp).

### 3. ResponseStatusException:
A simpler alternative where you throw a specific exception with a status code directly. 

---

## ✅ Ideal Answer
Global exception handling ensures that your API speaks a consistent language even when things go wrong. By centralizing our error logic in a `@RestControllerAdvice`, we decouple our business logic from the HTTP layer, preventing code duplication and providing a predictable contract for front-end developers. This approach allows us to map specific domain exceptions—like a missing record—to the appropriate HTTP status codes automatically and securely.

---

## 💻 Java Code
```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(UserNotFoundException ex) {
        ErrorResponse err = new ErrorResponse("ERR_001", ex.getMessage());
        return new ResponseEntity<>(err, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneral(Exception ex) {
        // Log the error stacktrace here
        ErrorResponse err = new ErrorResponse("ERR_999", "Internal Server Error");
        return new ResponseEntity<>(err, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can you have multiple Advice classes?** (Yes, use the `order` parameter to decide which one takes precedence.)
2. **Handle Validation Errors?** (Override `handleMethodArgumentNotValid` to return a list of field-specific errors [e.g. "email is required"].)
3. **Difference between `@ControllerAdvice` and `@RestControllerAdvice`?** (`@RestControllerAdvice` adds `@ResponseBody` to all methods automatically.)
