---
title: "DSA: Find All Anagrams in a String"
date: 2024-04-04
draft: false
weight: 46
---

# 🧩 Question: Find All Anagrams in a String (LeetCode 438)
Given two strings `s` and `p`, return an array of all the start indices of `p`'s anagrams in `s`. You may return the answer in any order.

## 🎯 What the interviewer is testing
- Sliding Window with fixed length.
- Frequency comparison.
- Optimizing for constant time window updates and comparison.

---

## 🧠 Deep Explanation

### Why not re-sorting for each window?
Sorting `p` ($O(P \log P)$) and every window of `s` of length $P$ results in $O(S \cdot P \log P)$, which is too slow.

### Sliding Window with Frequency Logic:
1. Since we're dealing with lowercase English letters, use a `int[26]` frequency array.
2. Initialize the frequency of `p` and the first window of `s` (length $P$).
3. Compare the two arrays. If they match, `0` is an answer.
4. **Sliding**:
   - Slide to the right. 
   - **Remove** the leftmost character from the window frequency.
   - **Add** the new character on the right to the window frequency.
   - Compare again.

### Optimization:
Instead of comparing arrays every time ($O(26)$), you can track how many unique characters match in terms of frequency.

---

## ✅ Ideal Answer
To find anagrams efficiently, we maintain a frequency count for the target string. We use a sliding window of the same length on the source string. As the window moves, we update the frequency map in constant time by adding the incoming character and subtracting the outgoing one, comparing it with our target map after each slide.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public List<Integer> findAnagrams(String s, String p) {
        List<Integer> result = new ArrayList<>();
        if (s.length() < p.length()) return result;

        int[] pCount = new int[26];
        int[] sCount = new int[26];

        for (int i = 0; i < p.length(); i++) {
            pCount[p.charAt(i) - 'a']++;
            sCount[s.charAt(i) - 'a']++;
        }

        if (Arrays.equals(pCount, sCount)) result.add(0);

        for (int i = p.length(); i < s.length(); i++) {
            // Add new character on right
            sCount[s.charAt(i) - 'a']++;
            // Remove leftmost character
            sCount[s.charAt(i - p.length()) - 'a']--;

            if (Arrays.equals(pCount, sCount)) {
                result.add(i - p.length() + 1);
            }
        }
        return result;
    }
}
```

---

## ⚠️ Common Mistakes
- Not handling the case where `s` is shorter than `p`.
- Re-creating or re-comparing the whole frequency map from scratch in each step ($O(S \cdot P)$).
- Off-by-one errors in starting indices.

---

## 🔄 Follow-up Questions
1. **How to handle Unicode characters?** (Use a `HashMap<Character, Integer>` instead of a fixed-size `int[26]`.)
2. **What is the complexity?** ($O(S + P)$ time, $O(26)$ space.)
3. **Difference from Permutation in String (LeetCode 567)?** (Practically the same problem; 567 only needs true/false.)
