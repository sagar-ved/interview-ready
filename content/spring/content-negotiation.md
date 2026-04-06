---
author: "sagar ved"
title: "Spring: Content Negotiation"
date: 2024-04-04
draft: false
weight: 26
---

# 🧩 Question: What is Content Negotiation in Spring? How does it decide between JSON and XML?

## 🎯 What the interviewer is testing
- Understanding of the HTTP `Accept` header.
- Message Converter logic.
- Supporting multiple formats in a single API.

---

## 🧠 Deep Explanation

### 1. The Request:
The client sends an `Accept` header:
- `Accept: application/json`
- `Accept: application/xml`

### 2. The Negotiation:
Spring looks at this header and tries to find a **HttpMessageConverter** that can handle it.
- **Jackson** handles JSON.
- **JAXB** handles XML.

### 3. Strategy:
Spring checks:
1. **Header**: `Accept` (Preferred).
2. **Path Extension**: `.../user.json` (Legacy/Optional).
3. **Parameter**: `.../user?format=json` (Optional).

---

## ✅ Ideal Answer
Content negotiation allows a single controller method to serve diverse client needs without changing the business logic. By interpreting the `Accept` header, Spring automatically selects the appropriate message converter to transform our domain objects into the requested format—be it JSON, XML, or even Protobuf. This flexibility is fundamental to building interoperable APIs that gracefully support a wide range of consuming platforms and legacy systems.

---

## 🔄 Follow-up Questions
1. **How to make JSON default?** (Configure the order of converters in `WebMvcConfigurer`.)
2. **What occurs if no match?** (Spring returns HTTP 406 "Not Acceptable".)
3. **Adding a custom converter?** (For example, to return CSV. Implement `AbstractHttpMessageConverter<T>` and add it to the list.)
