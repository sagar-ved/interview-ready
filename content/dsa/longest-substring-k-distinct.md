---
title: "DSA: Longest Substring with At Most K Distinct Characters"
date: 2024-04-04
draft: false
weight: 66
---

# 🧩 Question: Longest Substring with At Most K Distinct Characters (LeetCode 340)
Given a string `s` and an integer `k`, return the length of the longest substring of `s` that contains at most `k` distinct characters.

## 🎯 What the interviewer is testing
- Dynamic Sliding Window.
- Map-based character tracking.
- Optimizing window contraction.

---

## 🧠 Deep Explanation

### The Logic:
1. Use a **HashMap** to store the character counts in the current window.
2. Expand the `right` pointer.
3. If the number of unique characters in the map exceeds `k`:
   - Shrink the `left` pointer. 
   - Decrease count of `s[left]` in map.
   - If count reach 0, remove the entry from map.
4. Keep track of the maximum `right - left + 1`.

---

## ✅ Ideal Answer
By using a sliding window combined with a frequency map, we can track the exact contents of our substring in linear time. We expand the window greedily and only contract from the left when our "distinct character budget" is exceeded. This ensures we evaluate every valid window in a single pass.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public int lengthOfLongestSubstringKDistinct(String s, int k) {
        if (k == 0) return 0;
        Map<Character, Integer> counts = new HashMap<>();
        int left = 0, right = 0, maxLen = 0;
        
        while (right < s.length()) {
            char c = s.charAt(right);
            counts.put(c, counts.getOrDefault(c, 0) + 1);
            
            while (counts.size() > k) {
                char d = s.charAt(left);
                counts.put(d, counts.get(d) - 1);
                if (counts.get(d) == 0) counts.remove(d);
                left++;
            }
            
            maxLen = Math.max(maxLen, right - left + 1);
            right++;
        }
        return maxLen;
    }
}
```

---

## 🔄 Follow-up Questions
1. **What if the alphabet is limited (e.g. only 26 letters)?** (Use an index array `int[128]` for performance.)
2. **Difference from Longest Substring Without Repeating Characters?** (That is just $K = 1$ logic, but slightly different constraints.)
3. **What is the complexity?** ($O(N)$ time, $O(K)$ space for the map.)
