---
title: "DSA: Word Search II (Trie + Backtracking)"
date: 2024-04-04
draft: false
weight: 18
---

# 🧩 Question: Word Search II (LeetCode 212)
Given an `m x n` board of characters and a list of strings `words`, return all words on the board. Each word must be constructed from letters of sequentially adjacent cells, where "adjacent" cells are horizontally or vertically neighboring. The same letter cell may not be used more than once in a word.

## 🎯 What the interviewer is testing
- Combining multiple advanced techniques (Trie + Backtracking).
- Optimizing search by pruning branches that cannot lead to a word.
- Efficient memory management (modifying Trie in place).

---

## 🧠 Deep Explanation
A standard DFS for each word would be $O(\text{words} \times m \times n \times 4^L)$. This is too slow.
Instead, we store all target words in a **Trie**.

### Optimized DFS:
1. Build a Trie from the `words` list.
2. For each cell `(i, j)` on the board, start a DFS.
3. If the current character is in the Trie, explore neighbors.
4. **Pruning**: If we find a word, remove it from the Trie (to avoid duplicates) or set `isWord = false`. If a Trie node has no more children, remove the node itself (optional but efficient).

---

## ✅ Ideal Answer
For a grid search with a dictionary, the most efficient approach is to traverse the board once and move down the Trie branches simultaneously. This allows us to search for all words at once. Marking visited cells on the board (by temporarily replacing characters) avoids using extra space for a `visited` matrix.

---

## 💻 Java Code
```java
import java.util.*;

class TrieNode {
    Map<Character, TrieNode> children = new HashMap<>();
    String word = null;
}

public class Solution {
    public List<String> findWords(char[][] board, String[] words) {
        TrieNode root = new TrieNode();
        for (String w : words) {
            TrieNode node = root;
            for (char c : w.toCharArray()) {
                node.children.putIfAbsent(c, new TrieNode());
                node = node.children.get(c);
            }
            node.word = w;
        }

        List<String> result = new ArrayList<>();
        for (int i = 0; i < board.length; i++) {
            for (int j = 0; j < board[0].length; j++) {
                dfs(board, i, j, root, result);
            }
        }
        return result;
    }

    private void dfs(char[][] board, int i, int j, TrieNode node, List<String> result) {
        char c = board[i][j];
        if (!node.children.containsKey(c)) return;

        TrieNode nextNode = node.children.get(c);
        if (nextNode.word != null) {
            result.add(nextNode.word);
            nextNode.word = null; // Mark as found to avoid duplicates
        }

        board[i][j] = '#'; // Mark visited
        int[] dx = {-1, 1, 0, 0};
        int[] dy = {0, 0, -1, 1};

        for (int k = 0; k < 4; k++) {
            int ni = i + dx[k];
            int nj = j + dy[k];
            if (ni >= 0 && ni < board.length && nj >= 0 && nj < board[0].length 
                && board[ni][nj] != '#') {
                dfs(board, ni, nj, nextNode, result);
            }
        }
        board[i][j] = c; // Backtrack
    }
}
```

---

## ⚠️ Common Mistakes
- Not pruning the search (searching for each word individually).
- Infinite loops due to not marking visited cells.
- Adding the same word multiple times (forgetting to null out `word` in Trie after finding).

---

## 🔄 Follow-up Questions
1. **How to optimize memory in the Trie?** (Use an array `TrieNode[26]` instead of HashMap if only 'a'-'z' are used.)
2. **What is the time complexity?** (Building Trie: $O(L_{total})$, DFS: $O(M \times N \times 4^L)$ but significantly pruned.)
3. **How would you parallelize this?** (Dispatch DFS for different starting points `(i, j)` to different threads.)
