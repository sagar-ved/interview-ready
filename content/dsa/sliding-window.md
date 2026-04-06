---
author: "sagar ved"
title: "Sliding Window and Two Pointer Patterns"
date: 2024-04-04
draft: false
weight: 4
---

# 🧩 Question: Given a string, find the length of the longest substring without repeating characters. Then extend: find the minimum window substring containing all characters of pattern T.

## 🎯 What the interviewer is testing
- Sliding window technique (variable and fixed window)
- Two-pointer optimization over nested loops
- HashSet/HashMap usage for O(1) lookup
- Extension to harder variants (Minimum Window Substring)

---

## 🧠 Deep Explanation

### 1. Why Sliding Window?

Brute force for substring problems: O(n²) or O(n³). Sliding window maintains a **valid window** by moving two pointers, reducing inner loop iterations.

Key insight: instead of rechecking from scratch, **slide** the left pointer to maintain validity.

### 2. Fixed Window vs Variable Window

- **Fixed Window**: Window size is constant (k). Slide by one at each step.
- **Variable Window**: Expand right pointer; shrink left pointer to maintain validity.

### 3. Template for Variable Window

```
left = 0
for right in range(n):
    # Extend window to include s[right]
    add s[right] to window

    while window is invalid:
        remove s[left] from window
        left++

    # Window is valid: update answer
    ans = max(ans, right - left + 1)
```

---

## ✅ Ideal Answer

- **Longest substring without repeats**: Sliding window with `HashMap<char, index>`. When a repeating char is found, move `left` to `max(left, lastIndex + 1)` — this correctly skips past the duplicate.
- **Minimum Window Substring**: Track character requirements with a frequency map. Use a "have" counter. When all required chars are satisfied, shrink from left.

---

## 💻 Java Code

```java
import java.util.*;

public class SlidingWindowPatterns {

    // 1. Longest substring without repeating characters — O(n)
    public int lengthOfLongestSubstring(String s) {
        Map<Character, Integer> lastSeen = new HashMap<>();
        int left = 0, ans = 0;

        for (int right = 0; right < s.length(); right++) {
            char c = s.charAt(right);
            if (lastSeen.containsKey(c)) {
                // Move left past the previous occurrence
                left = Math.max(left, lastSeen.get(c) + 1);
            }
            lastSeen.put(c, right);
            ans = Math.max(ans, right - left + 1);
        }
        return ans;
    }

    // 2. Minimum Window Substring — O(n + m)
    public String minWindow(String s, String t) {
        Map<Character, Integer> need = new HashMap<>();
        for (char c : t.toCharArray()) need.merge(c, 1, Integer::sum);

        int left = 0, have = 0, required = need.size();
        int[] best = {0, Integer.MAX_VALUE}; // [start, length]
        Map<Character, Integer> window = new HashMap<>();

        for (int right = 0; right < s.length(); right++) {
            char c = s.charAt(right);
            window.merge(c, 1, Integer::sum);

            // Check if this char now satisfies a requirement
            if (need.containsKey(c) && window.get(c).equals(need.get(c))) {
                have++;
            }

            // Shrink window from left while all requirements are met
            while (have == required) {
                if (right - left + 1 < best[1]) {
                    best[0] = left;
                    best[1] = right - left + 1;
                }
                char leftChar = s.charAt(left++);
                window.merge(leftChar, -1, Integer::sum);
                if (need.containsKey(leftChar) && window.get(leftChar) < need.get(leftChar)) {
                    have--;
                }
            }
        }
        return best[1] == Integer.MAX_VALUE ? "" : s.substring(best[0], best[0] + best[1]);
    }

    // 3. Fixed window: Maximum sum subarray of size k — O(n)
    public int maxSumSubarray(int[] nums, int k) {
        int windowSum = 0;
        for (int i = 0; i < k; i++) windowSum += nums[i]; // Build first window

        int maxSum = windowSum;
        for (int i = k; i < nums.length; i++) {
            windowSum += nums[i] - nums[i - k]; // Slide: add new, remove old
            maxSum = Math.max(maxSum, windowSum);
        }
        return maxSum;
    }

    // 4. Longest Ones with at most K flips (variable window) — O(n)
    public int longestOnes(int[] nums, int k) {
        int left = 0, zeros = 0, ans = 0;
        for (int right = 0; right < nums.length; right++) {
            if (nums[right] == 0) zeros++;
            while (zeros > k) {
                if (nums[left++] == 0) zeros--;
            }
            ans = Math.max(ans, right - left + 1);
        }
        return ans;
    }
}
```

---

## ⚠️ Common Mistakes
- Moving `left` incorrectly when a repeat is found (not using `max(left, ...)` which handles cases where duplicate is outside the current window)
- Not shrinking the window correctly in variable-window problems
- Using `O(n)` inner loop logic inadvertently (defeats the purpose)
- Integer comparison with `==` for `Integer` wrapper type (use `.equals()`)

---

## 🔄 Follow-up Questions
1. **Find all anagrams of P in S?** (Fixed window of size `p.len`; compare frequency maps at each step.)
2. **Subarrays with sum equal to K?** (Prefix sums + HashMap: `prefixCount.getOrDefault(sum - k, 0)` — O(n).)
3. **Two pointers for sorted array pair sum?** (Left and right pointers converge — O(n); works only on sorted data.)
