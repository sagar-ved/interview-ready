---
title: "Hibernate: Soft Deletes (@SQLDelete)"
date: 2024-04-04
draft: false
weight: 25
---

# 🧩 Question: How do you implement Soft Deletes in Spring Data JPA? What is the challenge with standard `Repository.delete()`?

## 🎯 What the interviewer is testing
- Data retention policies.
- Modifying standard Hibernate behavior.
- Use of `@SQLDelete` and `@Where`.

---

## 🧠 Deep Explanation

### 1. The Strategy:
We don't actually delete the row. We set a column `deleted = true`.

### 2. The Hibernate Hooks:
- **`@SQLDelete`**: Overrides the default `DELETE` SQL used by Hibernate. 
  - `UPDATE my_table SET deleted = true WHERE id = ?`
- **`@Where`**: Automatically appends a filter to EVERY find query.
  - `clause = "deleted = false"`
  - This ensures `findAll()` doesn't show "deleted" items.

### 3. The Issue with `@Where`:
It is Global. If you actually NEED to find a deleted item for an admin view, standard repository methods won't work because Hibernate is hard-coded to ignore them. You must use native queries or specific `Filter` logic.

---

## ✅ Ideal Answer
Soft deletes provide a vital safety net for user data, allowing for accidental recovery and audit history. While implementing them in Spring Data JPA is straightforward using `@SQLDelete` and `@Where`, a senior engineer must be mindful that standard filters can complicate administrative queries or unique constraints. By choosing between global `@Where` filters and more granular criteria-based visibility, we can strike a balance between background transparency and selective data access.

---

## 🏗️ Code Example:
```java
@Entity
@SQLDelete(sql = "UPDATE user SET deleted = true WHERE id = ?")
@Where(clause = "deleted = false")
public class User {
    private boolean deleted = false;
}
```

---

## 🔄 Follow-up Questions
1. **Unique Constraints & Soft Deletes?** (Problem: You can't create a new user with the same email if the old "deleted" user still has it. Fix: Include `deleted` in the unique index [email, deleted].)
2. **What about child entities?** (You must ensure that deleting a parent also triggers the `@SQLDelete` logic of the children [Cascade].)
3. **Is `@Where` deprecated?** (In Hibernate 6.4+, it was replaced by `@FilterDef` / `@Filter` or `@SoftDelete` in recent versions, which is even cleaner.)
