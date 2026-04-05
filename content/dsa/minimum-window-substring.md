---
title: "DSA: Minimum Window Substring"
date: 2024-04-04
draft: false
weight: 30
---

# 🧩 Question: Minimum Window Substring (LeetCode 76)
Given two strings `s` and `t` of lengths `m` and `n` respectively, return the minimum window substring of `s` such that every character in `t` (including duplicates) is included in the window. If there is no such substring, return the empty string "".

## 🎯 What the interviewer is testing
- Advanced Sliding Window / Two Pointers.
- Frequency map tracking.
- Optimizing for large alphabet sizes.

---

## 🧠 Deep Explanation

### The Logic:
1. Build a target frequency map for `t`.
2. Expand the `right` pointer to include characters in the window.
3. Keep track of how many "required" characters/frequencies were satisfied (`formed == required`).
4. Once satisfied, contract the `left` pointer to find the smallest valid window.
5. Record the minimum length found.

---

## ✅ Ideal Answer
We use a sliding window approach with two pointers. We maintain a count of required characters from `t` and expand our window until all are included. Then, we shrink from the left as much as possible while maintaining the "valid" condition. This ensures an $O(N)$ time complexity.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public String minWindow(String s, String t) {
        if (s.length() == 0 || t.length() == 0) return "";

        Map<Character, Integer> target = new HashMap<>();
        for (char c : t.toCharArray()) target.put(c, target.getOrDefault(c, 0) + 1);

        int required = target.size();
        int left = 0, right = 0;
        int formed = 0;
        Map<Character, Integer> window = new HashMap<>();

        int[] ans = {-1, 0, 0}; // {length, left, right}

        while (right < s.length()) {
            char c = s.charAt(right);
            window.put(c, window.getOrDefault(c, 0) + 1);

            if (target.containsKey(c) && window.get(c).equals(target.get(c))) {
                formed++;
            }

            while (left <= right && formed == required) {
                c = s.charAt(left);
                if (ans[0] == -1 || right - left + 1 < ans[0]) {
                    ans[0] = right - left + 1;
                    ans[1] = left;
                    ans[2] = right;
                }

                window.put(c, window.get(c) - 1);
                if (target.containsKey(c) && window.get(c) < target.get(c)) {
                    formed--;
                }
                left++;
            }
            right++;
        }

        return ans[0] == -1 ? "" : s.substring(ans[1], ans[2] + 1);
    }
}
```

---

## ⚠️ Common Mistakes
- Not correctly handling duplicate characters in `t`.
- Not contracting the window from the left properly.
- Forgetting to compare character counts using `.equals()` if using `Integer` objects from HashMap.

---

## 🔄 Follow-up Questions
1. **Can you optimize with a fixed-size array?** (Yes, `int[128]` for ASCII.)
2. **What if the target `t` is huge?** (The HashMap approach is still $O(S + T)$.)
3. **Substring vs Subsequence?** (Substring is contiguous.)
