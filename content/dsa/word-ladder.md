---
title: "DSA: Word Ladder"
date: 2024-04-04
draft: false
weight: 32
---

# 🧩 Question: Word Ladder (LeetCode 127)
A transformation sequence from word `beginWord` to word `endWord` using a dictionary `wordList` is a sequence of words `beginWord -> s1 -> s2 -> ... -> sk` such that:
1. Every adjacent pair of words differs by exactly one letter.
2. Every `si` is in `wordList`.
Given `beginWord`, `endWord`, and `wordList`, return the number of words in the **shortest transformation sequence**.

## 🎯 What the interviewer is testing
- Shortest path in an unweighted graph (BFS).
- Transforming problem to a graph search.
- Efficiently finding neighbors (word mutations).

---

## 🧠 Deep Explanation

### Why BFS?
Since all "edges" (word differences) have a weight of 1, BFS is guaranteed to find the shortest path first.

### Finding Neighbors:
1. **Inefficient**: Loop through the whole `wordList` for every word ($O(N)$). Total: $O(N^2 \cdot L)$.
2. **Efficient**: Change each character of the current word from 'a' to 'z' ($O(L \cdot 26)$) and check if the result is in `wordList`. Total: $O(N \cdot L^2)$.

### Bidirectional BFS (Optimization):
Instead of searching from `beginWord` to `endWord`, search from **both ends** simultaneously. In each step, pick the smaller set of candidates to expand. This significantly reduces the search space (the "fan-out").

---

## ✅ Ideal Answer
To find the shortest transformation, we model the problem as a graph where each word is a node and an edge exists if two words differ by one letter. We use BFS to find the shortest path. To optimize, we can use Bidirectional BFS, which is particularly effective here as the search tree's diameter can be large.

---

## 💻 Java Code: Standard BFS
```java
import java.util.*;

public class Solution {
    public int ladderLength(String beginWord, String endWord, List<String> wordList) {
        Set<String> dict = new HashSet<>(wordList);
        if (!dict.contains(endWord)) return 0;
        
        Queue<String> queue = new LinkedList<>();
        queue.offer(beginWord);
        int level = 1;

        while (!queue.isEmpty()) {
            int size = queue.size();
            for (int i = 0; i < size; i++) {
                String curr = queue.poll();
                if (curr.equals(endWord)) return level;

                char[] chars = curr.toCharArray();
                for (int j = 0; j < chars.length; j++) {
                    char original = chars[j];
                    for (char c = 'a'; c <= 'z'; c++) {
                        if (c == original) continue;
                        chars[j] = c;
                        String next = new String(chars);
                        if (dict.contains(next)) {
                            queue.offer(next);
                            dict.remove(next); // Mark as visited
                        }
                    }
                    chars[j] = original;
                }
            }
            level++;
        }
        return 0;
    }
}
```

---

## ⚠️ Common Mistakes
- Using DFS (finding *any* path, not the shortest, and likely hitting a StackOverflow).
- Not marking words as "visited" or removing from the dictionary (leads to infinite cycles).
- Re-creating the frequency map/neighbors list repeatedly instead of doing bit-level changes.

---

## 🔄 Follow-up Questions
1. **What is the complexity of Bidirectional BFS?** ($O(N \cdot L^2)$, but with a smaller constant in practice.)
2. **How to return all shortest paths?** (Word Ladder II: Need to store the graph hierarchy and use DFS to backtrack from the end to the start.)
3. **What if the alphabet is huge?** (Revisiting the $O(N)$ neighbor check instead.)
