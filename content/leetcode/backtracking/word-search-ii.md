---
title: "LeetCode 212: Word Search II (Trie + Backtracking)"
date: 2024-04-04
draft: false
weight: 5
---

# 🧩 LeetCode 212: Word Search II ⭐ (Hard)
Find all words from the dictionary that exist on the board. Letters are connected horizontally or vertically; each cell used at most once per word.

## 🎯 What the interviewer is testing
- Trie for multi-word prefix pruning.
- Backtracking with board mutation for visited tracking.
- Removing found words from Trie to avoid duplicates.

---

## 🧠 Deep Explanation

### Naive: DFS per word — $O(Words \times M \times N \times 4^L)$ — Too slow.

### Trie + Single DFS:
1. Insert all words into a Trie.
2. From every cell `(i, j)`, DFS along Trie branches simultaneously.
3. If `trie.word != null` → found a word. Set to null to prevent re-adding.
4. Mark board cell `'#'` during DFS, restore on backtrack.
5. **Prune**: If `trie.children` is empty, remove node (optimization).

One DFS traversal searches for **all** words simultaneously.

---

## ✅ Ideal Answer
The Trie acts as a compact guide for DFS: we only explore paths that are prefixes of target words. By marking cells visited via board mutation (no extra matrix needed) and nullifying found words in the Trie, we ensure each word appears at most once in the result.

---

## 💻 Java Code
```java
class TrieNode { Map<Character, TrieNode> ch = new HashMap<>(); String word; }

public class Solution {
    public List<String> findWords(char[][] board, String[] words) {
        TrieNode root = new TrieNode();
        for (String w : words) {
            TrieNode n = root;
            for (char c : w.toCharArray()) { n.ch.putIfAbsent(c, new TrieNode()); n = n.ch.get(c); }
            n.word = w;
        }
        List<String> res = new ArrayList<>();
        for (int i = 0; i < board.length; i++)
            for (int j = 0; j < board[0].length; j++)
                dfs(board, i, j, root, res);
        return res;
    }
    void dfs(char[][] board, int i, int j, TrieNode node, List<String> res) {
        char c = board[i][j];
        if (c == '#' || !node.ch.containsKey(c)) return;
        TrieNode next = node.ch.get(c);
        if (next.word != null) { res.add(next.word); next.word = null; }
        board[i][j] = '#';
        int[][] dirs = {{-1,0},{1,0},{0,-1},{0,1}};
        for (int[] d : dirs) {
            int r = i+d[0], col = j+d[1];
            if (r>=0&&r<board.length&&col>=0&&col<board[0].length) dfs(board,r,col,next,res);
        }
        board[i][j] = c;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Trie node cleanup?** (Remove empty Trie nodes as you backtrack — reduces memory and future DFS branches.)
2. **Array vs HashMap for Trie?** (`TrieNode[26]` is faster for lowercase-only inputs.)
3. **Complexity?** (Build Trie $O(\sum L_i)$; DFS $O(M \cdot N \cdot 4^{L_{max}})$ with pruning in practice much better.)
