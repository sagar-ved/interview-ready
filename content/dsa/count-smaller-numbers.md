---
title: "DSA: Count of Smaller Numbers After Self"
date: 2024-04-04
draft: false
weight: 101
---

# 🧩 Question: Count of Smaller Numbers After Self (LeetCode 315 - Hard)
You are given an integer array `nums` and you have to return a new counts array. The counts array has the property where `counts[i]` is the number of smaller elements to the right of `nums[i]`.

## 🎯 What the interviewer is testing
- Advanced data structures (Binary Indexed Tree / Segment Tree).
- Merge Sort with index tracking.
- Solving "Inversion Count" variations.

---

## 🧠 Deep Explanation

### Why $O(N^2)$ is bad:
A simple nested loop to count right-side smaller values is too slow for 100k elements.

### Approach 1: Segment Tree / BIT
1. **Coordinate Compression**: Because numbers are large, map them to their sorted rank (1 to N).
2. **Scan from Right to Left**: 
   - For each number:
     - `count = query_prefix_sum(rank - 1)` (How many numbers smaller than me have I already seen?)
     - `update_count(rank, 1)` (Mark that I've been seen.)

### Approach 2: Modified Merge Sort
During the merge step, when an element from the **right** half is moved into the sorted array before an element from the **left** half, it means all remaining elements in the left half are "smaller" than it? No, wait... 
- If `Left[i] > Right[j]`: All elements from `Right[0...j]` are "smaller" than `Left[i]`.
- We track these jumps during merge sort to count inversions.

---

## ✅ Ideal Answer
To track smaller-element counts in $O(N \log N)$, we utilize a Fenwick Tree (Binary Indexed Tree) combined with coordinate compression. By processing the array from right to left, we can query how many elements we've already encountered that are smaller than the current value, effectively calculating the inversion count in logarithmic time per element. This provides a massive performance boost over the naive quadratic search.

---

## 💻 Java Code: BIT Logic
```java
public void update(int i, int val) {
    for (; i < bit.length; i += i & -i) bit[i] += val;
}
public int query(int i) {
    int sum = 0;
    for (; i > 0; i -= i & -i) sum += bit[i];
    return sum;
}
```

---

## 🔄 Follow-up Questions
1. **What is Coordinate Compression?** (Converting large values like `[100, 1000000, 5]` to ranks like `[2, 3, 1]` to fit in a small BIT array.)
2. **Complexity?** ($O(N \log N)$ time and $O(N)$ space.)
3. **Can you use a BST?** (Yes, a Binary Search Tree where each node tracks the `size` of its left subtree.)
