---
title: "Algorithm: Top K Elements in a Stream"
date: 2024-04-04
draft: false
---

# 🧩 Question: Design a system to find the Top K most frequent elements from a real-time data stream of millions of events.

## 🎯 What the interviewer is testing
*   **Data Structures**: HashMap for frequency counting, Min-Heap vs. Max-Heap for tracking "Top K".
*   **Streaming Logic**: Memory constraints in real-time processing.
*   **Performance Trade-offs**: $O(N \log K)$ vs $O(N + K \log N)$ approaches.
*   **Space Complexity**: Managing memory when total unique elements are unknown.

---

## 🧠 Deep Explanation

### 1. The Naive Approach
-   **Method**: Collect all elements in a List, sort by frequency, and pick the first K.
-   **Complexity**: $O(N \log N)$ for sorting.
-   **Cons**: Infeasible for streams. We don't have all data in advance, and memory will blow up if the stream is huge.

### 2. Optimized Approach (Heap + HashMap)
1.  **Phase 1 (Frequency Map)**: Use a `HashMap<Element, Frequency>` to count occurrences.
    -   Space: $O(\text{Unique Elements})$.
2.  **Phase 2 (Min-Heap of Size K)**:
    -   Iterate through the `HashMap`.
    -   Maintain a **Min-Heap** of size $K$ based on frequency.
    -   If the current element's frequency is greater than the heap's root (the minimum of the top K), replace the root and `heapify`.
-   **Time Complexity**: $O(N)$ for counting + $O(U \log K)$ for heap operations (where $U$ is unique elements). Since $K$ is typically small, this is highly efficient.

### 3. Scaling to Big Data (Distributing)
-   If $N$ is too large for one machine, use **MapReduce** or **Spark Streaming**.
-   **Map Phase**: Count local frequencies on multiple partitions.
-   **Reduce Phase**: Aggregate frequencies and find Top K globally.
-   **Probabilistic Approach**: For even larger streams (e.g., global trending topics), use **Count-Min Sketch** to estimate frequencies with $O(1)$ space.

---

## ✅ Ideal Answer (Structured)

*   **Frequency Tracking**: Use a HashMap for $O(1)$ updates and lookups.
*   **Heap Selection**: Explain why a **Min-Heap** is used instead of a Max-Heap (it allows us to discard the least frequent of the "top" candidates quickly).
*   **Streaming Context**: Mention that for a pure stream, we might need a sliding window (e.g., Top K in the last 1 hour).
*   **Edge Cases**: Handle ties in frequency (usually by lexicographical order) and empty streams.

---

## 💻 Java Code (Production Style)

```java
import java.util.*;

/**
 * Finding Top K elements in a stream of words.
 * Optimized for O(N log K).
 */
public class TopKStream {
    public List<String> topKFrequent(String[] words, int k) {
        // Step 1: Count Frequencies
        Map<String, Integer> count = new HashMap<>();
        for (String word : words) {
            count.put(word, count.getOrDefault(word, 0) + 1);
        }

        // Step 2: Maintain a Min-Heap of size K
        // PriorityQueue compares by frequency; if equal, uses reverse alphabetical order
        // (to keep lexicographical order in final result)
        PriorityQueue<String> heap = new PriorityQueue<>(
            (w1, w2) -> count.get(w1).equals(count.get(w2)) ? 
                        w2.compareTo(w1) : count.get(w1) - count.get(w2)
        );

        for (String word : count.keySet()) {
            heap.offer(word);
            if (heap.size() > k) {
                heap.poll(); // Keep only the Top K
            }
        }

        // Step 3: Build result list
        List<String> res = new ArrayList<>();
        while (!heap.isEmpty()) {
            res.add(heap.poll());
        }
        Collections.reverse(res); // Reverse to get descending frequency order
        return res;
    }
}
```

---

## ⚠️ Common Mistakes
*   **Using Max-Heap**: Candidates often think "Top" means "Max-Heap". However, a Max-Heap requires storing *all* elements and then polling $K$ times ($O(U \log U)$), whereas a Min-Heap stays at size $K$ ($O(U \log K)$).
*   **Resizing Issues**: In real-world streaming, the HashMap grows indefinitely. Interviewer expects mention of **LRU Cache** or **Sliding Windows** to limit size.

---

## 🔄 Follow-up Questions
1.  **How to handle a sliding window (Top K in last 5 mins)?** (Answer: Use a `TreeMap` or a doubly linked list with the HashMap to age out old entries).
2.  **How to handle extremely high write volume?** (Answer: Use a **Lock-free concurrent hashmap** for counting and a separate thread for heap selection).
3.  **What if unique elements don't fit in memory?** (Answer: Use a probabilistic data structure like **Count-Min Sketch**).
