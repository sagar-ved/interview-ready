---
author: "sagar ved"
title: "LeetCode 39: Combination Sum"
date: 2024-04-04
draft: false
weight: 2
---

# 🧩 LeetCode 39: Combination Sum (Medium)
Given candidates array and target, return all unique combinations where numbers sum to target. Numbers can be reused.

## 🎯 What the interviewer is testing
- Backtracking with repetition allowed.
- Pruning when running sum exceeds target.
- Difference between combinations vs permutations.

---

## 🧠 Deep Explanation

### The Decision Tree:
At each step, we can pick the **same element again** (no `i+1`, stay at `i`) or move to the next (`i+1`).

Pruning: If `remaining < 0`, stop (overshot). If `remaining == 0`, found a valid combination.

**Key**: Sorting helps us prune early. If `candidates[i] > remaining`, all further elements are also too large.

---

## ✅ Ideal Answer
By starting every recursive call at the same index `i` (not `i+1`), we allow each element to be reused. Sorting the candidates enables early pruning of branches where even the smallest remaining element exceeds the target.

---

## 💻 Java Code
```java
public class Solution {
    public List<List<Integer>> combinationSum(int[] candidates, int target) {
        List<List<Integer>> result = new ArrayList<>();
        Arrays.sort(candidates);
        backtrack(result, new ArrayList<>(), candidates, target, 0);
        return result;
    }

    private void backtrack(List<List<Integer>> res, List<Integer> curr,
                           int[] candidates, int remaining, int start) {
        if (remaining == 0) { res.add(new ArrayList<>(curr)); return; }
        for (int i = start; i < candidates.length && candidates[i] <= remaining; i++) {
            curr.add(candidates[i]);
            backtrack(res, curr, candidates, remaining - candidates[i], i); // i, not i+1
            curr.remove(curr.size() - 1);
        }
    }
}
```

---

## 🔄 Follow-up Questions
1. **Combination Sum II (no reuse)?** (Use `i+1` instead of `i`. Also skip `nums[i] == nums[i-1]` to avoid duplicate combinations.)
2. **Combination Sum III?** (LeetCode 216: Only `k` numbers from 1–9 that sum to `n`.)
3. **Permutations vs Combinations?** (Permutations: `[1,2]` and `[2,1]` are different. Combinations: they're the same.)
