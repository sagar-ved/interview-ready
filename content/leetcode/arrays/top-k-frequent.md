---
author: "sagar ved"
title: "LeetCode 347: Top K Frequent Elements"
date: 2024-04-04
draft: false
weight: 9
---

# 🧩 Question: Top K Frequent Elements (LeetCode 347)
Given an integer array `nums` and an integer `k`, return the `k` most frequent elements in better than $O(n \log n)$ time.

## 🎯 What the interviewer is testing
- Frequent element counting using HashMap.
- Efficient selection using Min-Heap or Bucket Sort.
- Trade-offs between $O(n \log k)$ and $O(n)$ approaches.

---

## 🧠 Deep Explanation

### 1. Min-Heap Approach ($O(n \log k)$):
- Use a `HashMap` for frequency counts.
- Maintain a `Min-PriorityQueue` of size k.
- If heap size exceeds `k`, pop the least frequent element.

### 2. Bucket Sort Approach ($O(n)$):
- Create buckets where `buckets[i]` stores elements with frequency `i`.
- Iterate from highest frequency bucket downward to collect `k` elements.

---

## ✅ Ideal Answer
For a strictly $O(n)$ solution, Bucket Sort is the way to go. We map frequencies to buckets and iterate backwards. This avoids the logarithmic penalty of heap operations.

---

## 💻 Java Code
```java
public class Solution {
    public int[] topKFrequent(int[] nums, int k) {
        Map<Integer, Integer> countMap = new HashMap<>();
        for (int num : nums) countMap.put(num, countMap.getOrDefault(num, 0) + 1);

        List<Integer>[] buckets = new List[nums.length + 1];
        for (int key : countMap.keySet()) {
            int freq = countMap.get(key);
            if (buckets[freq] == null) buckets[freq] = new ArrayList<>();
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

## 🔄 Follow-up Questions
1. **Can you solve this online (streaming)?** (Use a Min-Heap of size k.)
2. **Top K frequent words?** (Use a Trie or lexicographical comparison for ties.)
3. **What if frequencies are huge?** (Use Count-Min Sketch for approximate counts in big data.)
