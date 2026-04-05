---
title: "DSA: Top K Frequent Elements"
date: 2024-04-04
draft: false
weight: 17
---

# 🧩 Question: Top K Frequent Elements (LeetCode 347)
Given an integer array `nums` and an integer `k`, return the `k` most frequent elements. You may return the answer in any order. Attempt to solve in better than $O(n \log n)$ time.

## 🎯 What the interviewer is testing
- Frequent element counting using HashMap.
- Efficient selection using Min-Heap or Bucket Sort.
- Understanding the trade-offs between $O(n \log k)$ and $O(n)$ space/time.

---

## 🧠 Deep Explanation

### 1. Min-Heap Approach ($O(n \log k)$):
- Use a `HashMap` to store frequency counts.
- Use a `Min-PriorityQueue` to store elements based on their frequencies.
- If the heap size exceeds `k`, pop the least frequent element.
- The remaining elements are the top `k`.

### 2. Bucket Sort Approach ($O(n)$):
- Store frequencies in a `HashMap`.
- Create a list of buckets where `buckets[i]` stores elements with frequency `i`.
- Iterate from the end (highest frequency) to collect `k` elements.

---

## ✅ Ideal Answer
For $O(n log k)$, we use a Heap. However, for a strictly $O(n)$ solution, Bucket Sort is the way to go. We map frequencies to buckets and iterate backwards. This avoids the logarithmic penalty of sorting or heap operations.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    // Bucket Sort Approach - O(n)
    public int[] topKFrequent(int[] nums, int k) {
        Map<Integer, Integer> countMap = new HashMap<>();
        for (int num : nums) {
            countMap.put(num, countMap.getOrDefault(num, 0) + 1);
        }

        List<Integer>[] buckets = new List[nums.length + 1];
        for (int key : countMap.keySet()) {
            int freq = countMap.get(key);
            if (buckets[freq] == null) {
                buckets[freq] = new ArrayList<>();
            }
            buckets[freq].add(key);
        }

        int[] result = new int[k];
        int index = 0;
        for (int i = buckets.length - 1; i >= 0 && index < k; i--) {
            if (buckets[i] != null) {
                for (int num : buckets[i]) {
                    result[index++] = num;
                    if (index == k) break;
                }
            }
        }
        return result;
    }
}
```

---

## ⚠️ Common Mistakes
- Sorting the entire frequency map ($O(n \log n)$).
- Not handling the case where multiple elements have the same frequency.
- Incorrect bucket sizing (should be `nums.length + 1`).

---

## 🔄 Follow-up Questions
1. **Can you solve this online style?** (Use a Min-Heap if data is streaming.)
2. **How to handle Top K frequent words?** (Use a Trie or Lexicographical comparison for ties.)
3. **What if the frequencies are too high?** (Use Count-Min Sketch for approximate counts in big data.)
