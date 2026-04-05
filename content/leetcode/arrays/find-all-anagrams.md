---
title: "LeetCode 438: Find All Anagrams in a String"
date: 2024-04-04
draft: false
weight: 17
---

# 🧩 LeetCode 438: Find All Anagrams in a String (Medium)
Given strings `s` and `p`, return all start indices of `p`'s anagrams in `s`.

## 🎯 What the interviewer is testing
- Fixed-length Sliding Window.
- Frequency array comparison in $O(26) = O(1)$.
- Efficient window update (add right char, remove left char).

---

## 🧠 Deep Explanation

### Why not sort each window?
Sorting every window is $O(S \cdot P \log P)$ — too slow.

### Sliding Window with `int[26]`:
1. Build frequency of `p` and first window of `s` (length `P`).
2. If counts match → index `0` is an answer.
3. Slide right: add `s[right]`, remove `s[right - P]`, compare.

Comparing two `int[26]` arrays is $O(26) = O(1)$ constant.

---

## ✅ Ideal Answer
We compare fixed-size frequency arrays as we slide a window of length `p.length()` across `s`. Adding/removing characters from the window is $O(1)$; the whole scan is $O(S)$.

---

## 💻 Java Code
```java
public class Solution {
    public List<Integer> findAnagrams(String s, String p) {
        List<Integer> result = new ArrayList<>();
        if (s.length() < p.length()) return result;
        int[] pCount = new int[26], sCount = new int[26];
        for (int i = 0; i < p.length(); i++) {
            pCount[p.charAt(i) - 'a']++;
            sCount[s.charAt(i) - 'a']++;
        }
        if (Arrays.equals(pCount, sCount)) result.add(0);
        for (int i = p.length(); i < s.length(); i++) {
            sCount[s.charAt(i) - 'a']++;
            sCount[s.charAt(i - p.length()) - 'a']--;
            if (Arrays.equals(pCount, sCount)) result.add(i - p.length() + 1);
        }
        return result;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Permutation in String (LC 567)?** (Identical pattern — just return `true/false`.)
2. **Unicode chars?** (Use `HashMap<Character, Integer>` instead of `int[26]`.)
3. **Complexity?** ($O(S + P)$ time, $O(26)$ space.)
