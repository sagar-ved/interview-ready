---
title: "Spring: RestTemplate Error Handling"
date: 2024-04-04
draft: false
weight: 20
---

# 🧩 Question: How do you handle non-2xx status codes in `RestTemplate`? Explain the `ResponseErrorHandler`.

## 🎯 What the interviewer is testing
- Handling external API failures.
- Decoding error bodies (JSON) into Java objects.
- Custom logic for specific codes (401, 403, 404).

---

## 🧠 Deep Explanation

### 1. Default Behavior:
By default, `RestTemplate` throws a `HttpClientErrorException` (for 4xx) or `HttpServerErrorException` (for 5xx). The body of the error is buried in the exception.

### 2. Custom Handler:
You can implement `ResponseErrorHandler`:
- **`hasError(response)`**: Decide which codes are considered "Errors."
- **`handleError(response)`**: Define the logic (e.g. log the body, map it to a custom exception).

---

## ✅ Ideal Answer
Effective communication with external services requires robust error decoding. Instead of relying on generic Spring exceptions, we can implement a custom `ResponseErrorHandler` to translate specific HTTP failure codes into meaningful domain-level exceptions. This allows our services to react intelligently—such as triggering retries for 5xx errors or refreshing tokens for 401s—ensuring that our application remains resilient even when external dependencies are unstable.

---

## 💻 Java Code:
```java
public class MyErrorHandler implements ResponseErrorHandler {
    @Override
    public void handleError(ClientHttpResponse response) throws IOException {
        if (response.getStatusCode() == HttpStatus.NOT_FOUND) {
            throw new ExternalResourceNotFoundException();
        }
    }
    // ...
}
```

---

## 🔄 Follow-up Questions
1. **How is this different in WebClient?** (WebClient uses `.onStatus(code -> ..., response -> ...)` or `.onErrorResume()` to handle errors reactively.)
2. **What is "RetryTemplate"?** (A legacy Spring Batch feature [now Spring Retry] that wraps RestTemplate calls to provide automated retries with backoff.)
3. **Logging the raw body?** (Be careful! You can only read the `ClientHttpResponse` stream ONCE. To log and then process, you must use a wrapper or a specific logging interceptor.)
