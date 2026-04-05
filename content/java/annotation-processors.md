---
title: "Java: Annotation Processors Internals"
date: 2024-04-04
draft: false
weight: 29
---

# 🧩 Question: How do annotation processors work in Java? Explain how libraries like Lombok and MapStruct generate code at compile-time.

## 🎯 What the interviewer is testing
- Understanding the Java Compiler (javac) toolchain.
- Code generation at compile-time vs Reflection at runtime.
- Awareness of "Pluggable Annotation Processing" (JSR 269).

---

## 🧠 Deep Explanation

### 1. Compile-time vs Runtime:
- **Reflection**: Inspecting code while it is running (slow, runtime overhead).
- **Annotation Processors**: Inspecting code **while it is being compiled** and generating new Java files or modifying existing ones.

### 2. How it works:
1. `javac` starts the compilation.
2. If it finds annotations, it looks for registered **AbstractProcessor** implementations (via SPI in `META-INF/services`).
3. The processor analyzes the "Round Environment" (the elements being compiled).
4. The processor can generate new source files (e.g., `MapperImpl.java`) using **Filer** API.
5. `javac` continues rounds until no more files are generated.

### 3. Lombok Hacker-y:
Standard annotation processors *cannot* modify existing files; they can only create new ones. Lombok uses internal compiler APIs (`private` to `javac`) to modify the Abstract Syntax Tree (AST) of the current file. This is why Lombok requires special IDE plugins.

---

## ✅ Ideal Answer
Annotation processing occurs during the compilation phase. Processers act on source code elements to generate additional classes or perform validation. This keeps runtime performance high by doing the heavy lifting (like mapping objects or generating boilerplates) before the application even starts.

---

## 💻 Java Code: Simple Processor Structure
```java
@SupportedAnnotationTypes("com.example.MyAnnotation")
@SupportedSourceVersion(SourceVersion.RELEASE_17)
public class MyProcessor extends AbstractProcessor {
    @Override
    public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {
        for (Element element : roundEnv.getElementsAnnotatedWith(MyAnnotation.class)) {
            // Logic to generate source code or throw compile-time error
            processingEnv.getMessager().printMessage(Diagnostic.Kind.NOTE, "Found: " + element);
        }
        return true; 
    }
}
```

---

## ⚠️ Common Mistakes
- Confusing Annotation Processors with Runtime Reflection.
- Forgetting that processors need to be registered in `META-INF/services`.
- Thinking processors can modify existing source code (official API doesn't allow it).

---

## 🔄 Follow-up Questions
1. **What is an "Element"?** (A representing part of the source code: package, class, method, field.)
2. **What is AutoService?** (A library that helps generate the `META-INF` files automatically.)
3. **Why use MapStruct?** (It generates type-safe, fast mapping code with no runtime reflection.)
