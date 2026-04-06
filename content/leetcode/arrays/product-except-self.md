---
author: "sagar ved"
title: "LeetCode: Product of Array Except Self"
date: 2024-04-04
draft: false
weight: 3
---

# 🧩 LeetCode 238: Product of Array Except Self
Given an integer array `nums`, return an array `answer` such that `answer[i]` is the product of all elements of `nums` except `nums[i]`.

## 🎯 What the interviewer is testing
- Using Prefix and Suffix products.
- Solving without the **Division operator** ($O(1)$ space requirement).
- Array manipulation without extra memory buffers.

---

## 🧠 Deep Explanation

### The Trap:
If you used division, you'd just multiply all and divide by `nums[i]`. 
- **Problem I**: Division by zero.
- **Problem II**: The interview explicitly forbids division!

### The Optimal Logic (Scanning twice):
Instead of one big product, we think: `ProductExceptSelf(i) = PrefixProduct(i-1) * SuffixProduct(i+1)`.
1. **Forward Pass**: Build an array where each `res[i]` contains the product of all elements to the **LEFT** of `i`.
2. **Backward Pass**: Multiply each `res[i]` by the product of all elements to the **RIGHT** of `i` using a running variable.

---

## ✅ Ideal Answer
To handle "Product Except Self" without division, we decompose each result into its prefix and suffix components. By traversing the array twice—once to calculate trailing products and once to incorporate leading products—we build the final result in linear time. This $O(N)$ method ensures we handle zero values safely and maintain a constant space footprint (excluding the output array).

---

## 💻 Java Code
```java
class Solution {
    public int[] productExceptSelf(int[] nums) {
        int n = nums.length;
        int[] res = new int[n];
        res[0] = 1;
        
        // Prefix Pass
        for (int i = 1; i < n; i++) {
            res[i] = res[i-1] * nums[i-1];
        }
        
        // Suffix Pass (on the fly)
        int right = 1;
        for (int i = n - 1; i >= 0; i--) {
            res[i] = res[i] * right;
            right *= nums[i];
        }
        
        return res;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can you use $O(1)$ space?** (The code above uses $O(1)$ because the result array doesn't count toward auxiliary space in most interview definitions.)
2. **Handling multiple zeros?** (All results will be 0 except for the zero positions themselves, who get the product of non-zero elements.)
3. **Complexity?** ($O(N)$ time, $O(1)$ space.)
