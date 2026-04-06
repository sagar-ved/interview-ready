---
author: "sagar ved"
title: "LeetCode 340: Longest Substring with At Most K Distinct Characters"
date: 2024-04-04
draft: false
weight: 18
---

# 🧩 LeetCode 340: Longest Substring with At Most K Distinct Characters (Hard)
Return the length of the longest substring of `s` that contains at most `k` distinct characters.

## 🎯 What the interviewer is testing
- Dynamic (variable-length) Sliding Window.
- HashMap-based character budget tracking.
- Shrinking from the left when budget exceeded.

---

## 🧠 Deep Explanation

### The Pattern:
1. Use a HashMap to count chars in current window.
2. Expand `right` pointer, add char.
3. While `map.size() > k`: shrink `left`, decrement count, remove if zero.
4. Track max `right - left + 1`.

---

## ✅ Ideal Answer
We greedily expand the window and only contract it from the left when we exceed `k` unique characters. The map tracks exact counts so we can properly remove characters when they leave the window completely.

---

## 💻 Java Code
```java
public class Solution {
    public int lengthOfLongestSubstringKDistinct(String s, int k) {
        if (k == 0) return 0;
        Map<Character, Integer> counts = new HashMap<>();
        int left = 0, maxLen = 0;
        for (int right = 0; right < s.length(); right++) {
            char c = s.charAt(right);
            counts.merge(c, 1, Integer::sum);
            while (counts.size() > k) {
                char d = s.charAt(left++);
                counts.merge(d, -1, Integer::sum);
                if (counts.get(d) == 0) counts.remove(d);
            }
            maxLen = Math.max(maxLen, right - left + 1);
        }
        return maxLen;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Exactly K distinct?** (`atMostK(s, k) - atMostK(s, k-1)` — a clever trick.)
2. **Without repeating chars?** (k=1 variant — `Longest Substring Without Repeating Characters`.)
3. **Complexity?** ($O(N)$ time, $O(K)$ space.)
