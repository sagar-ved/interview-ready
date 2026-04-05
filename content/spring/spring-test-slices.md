---
title: "Spring Boot: Testing Slices (@DataJpaTest)"
date: 2024-04-04
draft: false
weight: 18
---

# 🧩 Question: What are "Test Slices" in Spring Boot? Why use `@WebMvcTest` instead of `@SpringBootTest`?

## 🎯 What the interviewer is testing
- Testing efficiency (Unit vs Integration).
- Minimizing context load time.
- Mocking boundaries.

---

## 🧠 Deep Explanation

### 1. @SpringBootTest (The Heavyweight):
- Loads the **Full Application Context**. 
- **Cost**: Very slow (takes 10-20s start time). 
- **Use Case**: End-to-end integration tests.

### 2. Test Slices (The Lightweight):
Spring Boot lets you load ONLY the beans needed for a specific layer.
- **`@WebMvcTest`**: Only loads Controllers, JSON components, and Security. You must **`@MockBean`** your services. 
- **`@DataJpaTest`**: Only loads Repositories and sets up an in-memory database (H2).
- **`@JsonTest`**: Only for testing serialization logic.

---

## ✅ Ideal Answer
Test slices are the key to maintainable and fast test suites. By using specialized annotations like `@WebMvcTest`, we can isolate the web layer or the data layer in a fraction of the time it takes to boot the entire application. This "targeted" loading allows for rapid feedback cycles while ensuring that each component—from controller routing to database persistence—is rigorously validated within its natural Spring environment.

---

## 🏗️ Code Example:
```java
@WebMvcTest(UserController.class)
class MyTest {
    @Autowired MockMvc mvc;
    @MockBean UserService service; // Must mock dependencies!
    
    @Test void test() { mvc.perform(get("/")).andExpect(status().isOk()); }
}
```

---

## 🔄 Follow-up Questions
1. **What is `TestPropertySource`?** (Override specific properties just for one test class.)
2. **Difference between `@Mock` and `@MockBean`?** (`@Mock` is pure Mockito; `@MockBean` is Spring's wrapper that actually puts the mock into the ApplicationContext.)
3. **What is `TestEntityManager`?** (A specialized helper provided in `@DataJpaTest` for setting up test data without using the standard Repository methods.)
