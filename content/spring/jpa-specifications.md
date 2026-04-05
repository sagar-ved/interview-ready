---
title: "Spring Data: Specification API"
date: 2024-04-04
draft: false
weight: 28
---

# 🧩 Question: When should you use the JPA Specification API instead of `@Query`?

## 🎯 What the interviewer is testing
- Dynamic query building.
- Reusable search logic.
- Type-safety in complex filters.

---

## 🧠 Deep Explanation

### 1. @Query (Static):
Great for a few fixed queries. 
- **Problem**: If you have a search screen with 10 optional filters (Name, MinAge, MaxAge, City...), you would need $2^{10}$ different repository methods or one giant ugly method with 10 `IF` statements in JPQL.

### 2. Specification (Dynamic):
Based on the **Criteria API**. 
- It treats each filter as a separate "Predicate" object.
- You can combine them: `specName.and(specAge).or(specCity)`.
- **Pro**: Totally dynamic. Totally type-safe.

---

## ✅ Ideal Answer
The Specification API is the solution for "Complex Search" scenarios where user input dictates the query structure at runtime. While standard JPQL is easier for one-off operations, Specifications allow us to build a library of reusable, atomic filter units that can be combined on-the-fly to satisfy unpredictable search criteria. This approach not only keeps our repositories clean but also provides the type-safety needed to avoid runtime SQL errors during heavy refactoring.

---

## 🏗️ Code Example:
```java
public static Specification<User> hasName(String name) {
    return (root, query, cb) -> cb.equal(root.get("name"), name);
}
// Usage
repo.findAll(hasName("Bob").and(hasAgeAbove(18)));
```

---

## 🔄 Follow-up Questions
1. **Specification vs QueryDSL?** (QueryDSL is often preferred for superior syntax, but it requires an extra code-generation step. Specifications are native to Spring Data.)
2. **Any performance risk?** (Complex Criteria queries can be hard for the DB optimizer to parse if not structured carefully, but they are generally as efficient as JPQL.)
3. **What is "Query by Example"?** (A simpler alternative where you provide a User object with some fields filled, and Spring searches for matches. Good for simple cases, bad for ranges or OR logic.)
