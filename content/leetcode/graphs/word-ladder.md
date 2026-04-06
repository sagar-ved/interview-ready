---
author: "sagar ved"
title: "LeetCode 127: Word Ladder"
date: 2024-04-04
draft: false
weight: 3
---

# 🧩 Question: Word Ladder (LeetCode 127)
Given `beginWord`, `endWord`, and a `wordList`, find the length of the shortest transformation sequence where each step differs by exactly one letter and is in the dictionary.

## 🎯 What the interviewer is testing
- Shortest path in an unweighted graph → BFS.
- Efficient neighbor generation ($O(L \cdot 26)$ vs $O(N)$).
- Bidirectional BFS optimization.

---

## 🧠 Deep Explanation

### Why BFS?
All edges have weight 1 (differ by one letter), so BFS guarantees the shortest path.

### Generating Neighbors Efficiently:
For each position in the word, try all 26 letters. If the resulting word is in the dictionary → it's a neighbor. This is $O(L \cdot 26)$ per word vs $O(N \cdot L)$ for comparing every word in the list.

### Key: Remove visited words from the set immediately to prevent cycles.

---

## ✅ Ideal Answer
The problem maps to shortest path in an implicit word graph. BFS guarantees optimality. The key optimization is generating neighbors by mutation ($O(26L)$ per word) rather than scanning the whole dictionary.

---

## 💻 Java Code
```java
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
                    char orig = chars[j];
                    for (char c = 'a'; c <= 'z'; c++) {
                        if (c == orig) continue;
                        chars[j] = c;
                        String next = new String(chars);
                        if (dict.contains(next)) { queue.offer(next); dict.remove(next); }
                    }
                    chars[j] = orig;
                }
            }
            level++;
        }
        return 0;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Bidirectional BFS?** (Search from both ends simultaneously, expanding the smaller frontier — dramatically faster in practice.)
2. **All shortest paths?** (Word Ladder II: Store a parent map and backtrack with DFS.)
3. **Complexity?** ($O(N \cdot L^2)$ where N = dict size, L = word length.)
