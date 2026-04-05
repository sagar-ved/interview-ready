---
title: "DSA: Word Search I & II"
date: 2024-04-04
draft: false
weight: 78
---

# 🧩 Question: Word Search (LeetCode 79, 212)
Given a 2D board of characters and a word (or list of words), return all matched strings in the grid.

## 🎯 What the interviewer is testing
- DFS with Backtracking.
- Performance optimization using **Trie** (for multiple words).
- Efficient coordinate traversal and pruning.

---

## 🧠 Deep Explanation

### Word Search I (One Word):
- **Algorithm**: Standard Backtracking.
- For each cell, if it matches `word[0]`, start a DFS.
- **Optimization**: Mark visited cells by overwriting them with a temporary character (e.g., `#`), then restore them after recursion.

### Word Search II (Multiple Words):
- **Problem**: Running DFS for EVERY word in the dictionary is $O(W \cdot M \cdot N)$.
- **Solution**: Build a **Trie** of all words. Perform DFS on the board once. As you move to a neighbor, move down the corresponding branch of the Trie. If you hit a "Leaf" in the Trie, you've found a word!
- **Pruning**: Delete words from the Trie after finding them to avoid duplicate results.

---

## ✅ Ideal Answer
For a single word, simple backtracking with state management efficiently finds matches. When searching for thousands of words simultaneously, a Trie-based approach is superior because it allows us to discard invalid branches early. By evaluating the grid and the dictionary hierarchy in parallel, we reduce redundant searches and achieve massive performance gains in large datasets.

---

## 💻 Java Code: Word Search II (Pre-loop)
```java
class TrieNode {
    Map<Character, TrieNode> children = new HashMap<>();
    String word = null;
}

public class Solution {
    public List<String> findWords(char[][] board, String[] words) {
        TrieNode root = buildTrie(words);
        List<String> result = new ArrayList<>();
        for (int r = 0; r < board.length; r++) {
            for (int c = 0; c < board[0].length; c++) {
                dfs(board, r, c, root, result);
            }
        }
        return result;
    }
}
```

---

## 🔄 Follow-up Questions
1. **How to handle large dictionaries?** (Trie is mandatory.)
2. **What is the complexity of Word Search I?** ($O(N \cdot M \cdot 3^L)$ where $L$ is word length; 3 neighbors each step.)
3. **Difference between Trie and HashSet for this?** (HashSet only works for full matches; Trie helps with prefix matches as you build the word.)
