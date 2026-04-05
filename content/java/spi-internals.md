---
title: "Java: Service Provider Interface (SPI)"
date: 2024-04-04
draft: false
weight: 27
---

# 🧩 Question: What is the Service Provider Interface (SPI)? How is it used in JDBC and what are its advantages?

## 🎯 What the interviewer is testing
- Java's mechanism for extensible applications.
- How libraries are discovered at runtime without hard-coding dependencies.
- Understanding decoupled architectures.

---

## 🧠 Deep Explanation

### 1. What is SPI?
SPI allows a library to define an interface, and for external providers to supply implementations that is automatically discovered by the library at runtime.
- **API**: You call it.
- **SPI**: It calls you.

### 2. The Mechanism:
1. Define an interface: `com.example.Codec`.
2. Provider implements it: `com.provider.Mp3Codec`.
3. Create a config file in the provider JAR: `META-INF/services/com.example.Codec` containing the string `com.provider.Mp3Codec`.
4. Library loads it via `ServiceLoader.load(Codec.class)`.

### 3. Real-world Example: JDBC
In the old days, you'd do: `Class.forName("com.mysql.jdbc.Driver")`.
In modern JDBC (4.0+), the driver is automatically loaded. Why? Because MySQL JAR contains a file in `META-INF/services/java.sql.Driver` pointing to its implementation.

---

## ✅ Ideal Answer
SPI is an extensibility mechanism in Java. Instead of a project hard-coding its dependencies, it defines interfaces, and the JVM dynamically discovers and loads implementations from the classpath using the ServiceLoader API. This is the cornerstone of many Java standards like JDBC, SLF4J, and JAX-RS.

---

## 💻 Java Code: Minimal SPI
```java
// 1. Interface
public interface SearchPlugin {
    void search(String query);
}

// 2. Implementation in a separate JAR
public class GoogleSearchPlugin implements SearchPlugin {
    public void search(String q) { /* ... */ }
}

// 3. Consumer
ServiceLoader<SearchPlugin> loader = ServiceLoader.load(SearchPlugin.class);
for (SearchPlugin plugin : loader) {
    plugin.search("Java SPI");
}
```

---

## ⚠️ Common Mistakes
- Forgetting the `META-INF/services/` config file.
- Thinking SPI is the same as Dependency Injection (it's related but simpler and part of the core language).
- Not realizing that `ServiceLoader` is lazy.

---

## 🔄 Follow-up Questions
1. **Can SPI handle multiple implementations?** (Yes, `ServiceLoader` returns an Iterable.)
2. **How does SPI interact with ClassLoaders?** (You can pass a specific ClassLoader to `ServiceLoader.load()`.)
3. **What replaced the `META-INF` file in Java 9 Modules?** (The `provides ... with ...` directive in `module-info.java`.)
