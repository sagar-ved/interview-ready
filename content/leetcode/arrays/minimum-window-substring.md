---
author: "sagar ved"
title: "LeetCode 76: Minimum Window Substring"
date: 2024-04-04
draft: false
weight: 10
---

# 🧩 Question: Minimum Window Substring (LeetCode 76 - Hard)
Return the minimum window in string `s` that contains every character in string `t`.

## 🎯 What the interviewer is testing
- Advanced Sliding Window with two frequency maps.
- Tracking when "all requirements are met" efficiently.
- Shrinking the window from the left while maintaining validity.

---

## 🧠 Deep Explanation

### The Strategy:
1. Build a frequency map for `t`.
2. Expand `right` pointer; update window frequency map.
3. When `formed == required` (all chars met at right frequencies), try to shrink from `left`.
4. Record minimum valid window. Move `left` forward.

### Key Insight:
Track `formed` separately — an integer counting how many unique characters in the window match their required frequency in `t`. This avoids re-iterating the entire map on each step.

---

## ✅ Ideal Answer
We maintain a sliding window with two pointers. Expand right to satisfy all requirements, then contract left to find the minimum valid window. This is $O(S + T)$.

---

## 💻 Java Code
```java
public class Solution {
    public String minWindow(String s, String t) {
        Map<Character, Integer> target = new HashMap<>();
        for (char c : t.toCharArray()) target.merge(c, 1, Integer::sum);
        int required = target.size(), formed = 0;
        Map<Character, Integer> window = new HashMap<>();
        int left = 0, minLen = Integer.MAX_VALUE, minL = 0;
        for (int right = 0; right < s.length(); right++) {
            char c = s.charAt(right);
            window.merge(c, 1, Integer::sum);
            if (target.containsKey(c) && window.get(c).equals(target.get(c))) formed++;
            while (formed == required) {
                if (right - left + 1 < minLen) { minLen = right - left + 1; minL = left; }
                char lc = s.charAt(left++);
                window.merge(lc, -1, Integer::sum);
                if (target.containsKey(lc) && window.get(lc) < target.get(lc)) formed--;
            }
        }
        return minLen == Integer.MAX_VALUE ? "" : s.substring(minL, minL + minLen);
    }
}
```

---

## ⚠️ Common Mistakes
- Using `.equals()` not `==` for `Integer` objects from the map.
- Not tracking `formed` separately (leads to $O(N \cdot 26)$ per step).

---

## 🔄 Follow-up Questions
1. **Optimize with array instead of map?** (`int[128]` for ASCII characters.)
2. **Complexity?** ($O(S + T)$ time, $O(S + T)$ space.)
