---
author: "sagar ved"
title: "Java ClassLoader and Reflection"
date: 2024-04-04
draft: false
weight: 10
---

# 🧩 Question: How does Java's ClassLoader work? How does it enable frameworks like Spring to load beans dynamically? Explain the delegation model.

## 🎯 What the interviewer is testing
- ClassLoader hierarchy and parent delegation model
- Reflection API and dynamic class loading
- How frameworks (Spring, Hibernate) use ClassLoaders
- ClassLoader memory leaks (common in web containers)

---

## 🧠 Deep Explanation

### 1. ClassLoader Hierarchy

Java has a built-in hierarchy of ClassLoaders:

```
Bootstrap ClassLoader (C++ code, loads java.*)
    ↓ (parent-first delegation)
Platform/Extension ClassLoader (javax.*, ext libs)
    ↓
Application/System ClassLoader (classpath classes)
    ↓
Custom ClassLoaders (Spring, Tomcat, plugin systems)
```

### 2. Parent Delegation Model

When a ClassLoader is asked to load a class:
1. It delegates to the **parent** first.
2. If the parent cannot find the class, the child loads it.
3. This ensures `java.lang.String` is always loaded by Bootstrap, never overridden.

### 3. Breaking Delegation: Thread Context ClassLoader

Java EE / Spring Boot applications often break the delegation model deliberately. `Thread.currentThread().getContextClassLoader()` is set to the application's ClassLoader, allowing child loaders to override parent loaders for plugin systems.

### 4. Reflection API

Reflection allows:
- Inspecting class structure at runtime: `getDeclaredMethods()`, `getDeclaredFields()`
- Instantiating objects without knowing the type: `clazz.getDeclaredConstructor().newInstance()`
- Accessing private fields: `field.setAccessible(true)`

Spring uses this extensively for `@Autowired` injection and `@Transactional` proxying.

---

## ✅ Ideal Answer

- **Parent Delegation**: Class lookup bubbles up to Bootstrap; child loads only if parent cannot. Prevents rogue code from replacing core classes.
- **Custom Loaders**: Frameworks like Spring/Tomcat create custom ClassLoaders per web application for isolation.
- **ClassLoader Leaks**: A common memory leak in servlet containers — if the ClassLoader holds a reference that prevents GC (e.g., a static ThreadLocal).

---

## 💻 Java Code

```java
import java.lang.reflect.*;
import java.net.*;

/**
 * Dynamic class loading and reflection examples
 */
public class ClassLoaderDemo {

    // Custom ClassLoader to load from a specific URL (e.g., plugin jar)
    public static Class<?> loadPlugin(String jarPath, String className) throws Exception {
        URL[] urls = { new URL("file://" + jarPath) };
        try (URLClassLoader loader = new URLClassLoader(urls, 
                Thread.currentThread().getContextClassLoader())) {
            return loader.loadClass(className);
        }
    }

    // Reflection: invoke a private method (used by test frameworks, Spring AOP)
    public static Object invokePrivate(Object target, String methodName, Object... args) 
            throws Exception {
        Class<?> clazz = target.getClass();
        Method method = clazz.getDeclaredMethod(methodName);
        method.setAccessible(true); // Break access control for testing/framework use
        return method.invoke(target, args);
    }

    // Spring-like injection: set a field by name
    public static void inject(Object target, String fieldName, Object value) throws Exception {
        Field field = target.getClass().getDeclaredField(fieldName);
        field.setAccessible(true);
        field.set(target, value);
    }

    public static void main(String[] args) throws Exception {
        // Print ClassLoader hierarchy
        ClassLoader cl = ClassLoaderDemo.class.getClassLoader();
        while (cl != null) {
            System.out.println(cl.getClass().getName());
            cl = cl.getParent();
        }
        System.out.println("Bootstrap ClassLoader (null)");
    }
}
```

---

## ⚠️ Common Mistakes
- Forgetting to close `URLClassLoader` — causes class/resource leaks in Tomcat hot-reload scenarios
- Using `setAccessible(true)` without a security context — blocked by the Java module system in Java 9+ without `--add-opens`
- Confusing `Class.forName()` (uses Thread Context ClassLoader) with `ClassLoader.loadClass()` (does NOT run static initializers)

---

## 🔄 Follow-up Questions
1. **What is a "ClassLoader leak" in Tomcat?** (Application class loader keeps references after undeploy, preventing GC of old classes — often caused by static ThreadLocals or JDBC drivers.)
2. **How does Spring Boot's embedded server avoid ClassLoader conflicts?** (Uses a single, flat ClassLoader with BOOT-INF/classes isolation.)
3. **What is OSGi and how does it use ClassLoaders?** (A module system where each bundle has its own ClassLoader and explicit package-level imports/exports.)
