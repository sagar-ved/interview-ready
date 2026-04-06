---
author: "sagar ved"
title: "Tries: Prefix Trees"
date: 2024-04-04
draft: false
weight: 8
---

# 🧩 Question: Implement a Trie for a word suggestion engine. Support insert, search, startsWith, and then extend it to support wildcard matching (`.` matches any character).

## 🎯 What the interviewer is testing
- Trie construction and traversal
- Space vs time trade-off vs HashMap alternatives
- Wildcard/backtracking extension
- Real-world use: autocomplete, spell check, IP routing

---

## 🧠 Deep Explanation

### 1. Trie Structure

Each node represents a character and contains:
- `children`: `Map<Character, TrieNode>` or `TrieNode[26]` for lowercase letters
- `isEnd`: boolean flag marking word completion

**Time complexity**: O(L) per operation where L = word length.
**Space**: O(total characters across all words) — shared prefixes use the same nodes.

### 2. Trie vs HashMap

| Feature | Trie | HashMap |
|---|---|---|
| Prefix queries | O(L) | O(n*L) — must check all keys |
| Memory | Efficient for shared prefixes | Each key stored independently |
| Sorted iteration | Easy (DFS in lexicographic order) | No natural order |
| Wildcard support | Natural (backtrack DFS) | Very hard |

### 3. Use Cases

- **Autocomplete**: Prefix search in O(L)
- **Spell checker**: Find words within edit distance 1
- **IP routing**: Longest prefix match (ternary trie)
- **Genome sequencing**: Suffix trie/tree

---

## 💻 Java Code

```java
import java.util.*;

public class Trie {

    private static class TrieNode {
        TrieNode[] children = new TrieNode[26]; // Only lowercase letters
        boolean isEnd = false;

        boolean hasChild(char c) { return children[c - 'a'] != null; }
        TrieNode getChild(char c) { return children[c - 'a']; }
        TrieNode createChild(char c) {
            children[c - 'a'] = new TrieNode();
            return children[c - 'a'];
        }
    }

    private final TrieNode root = new TrieNode();

    // Insert — O(L)
    public void insert(String word) {
        TrieNode node = root;
        for (char c : word.toCharArray()) {
            if (!node.hasChild(c)) node.createChild(c);
            node = node.getChild(c);
        }
        node.isEnd = true;
    }

    // Exact search — O(L)
    public boolean search(String word) {
        TrieNode node = find(word);
        return node != null && node.isEnd;
    }

    // Prefix search — O(L)
    public boolean startsWith(String prefix) {
        return find(prefix) != null;
    }

    private TrieNode find(String prefix) {
        TrieNode node = root;
        for (char c : prefix.toCharArray()) {
            if (!node.hasChild(c)) return null;
            node = node.getChild(c);
        }
        return node;
    }

    // Get all words with given prefix — for autocomplete
    public List<String> autocomplete(String prefix) {
        TrieNode node = find(prefix);
        List<String> results = new ArrayList<>();
        if (node != null) dfsCollect(node, new StringBuilder(prefix), results);
        return results;
    }

    private void dfsCollect(TrieNode node, StringBuilder current, List<String> results) {
        if (node.isEnd) results.add(current.toString());
        for (int i = 0; i < 26; i++) {
            if (node.children[i] != null) {
                current.append((char) ('a' + i));
                dfsCollect(node.children[i], current, results);
                current.deleteCharAt(current.length() - 1); // Backtrack
            }
        }
    }

    // ==== EXTENSION: WordDictionary with wildcard '.' ====
    static class WordDictionary {
        private final TrieNode root = new TrieNode();

        public void addWord(String word) {
            TrieNode node = root;
            for (char c : word.toCharArray()) {
                if (!node.hasChild(c)) node.createChild(c);
                node = node.getChild(c);
            }
            node.isEnd = true;
        }

        public boolean search(String word) {
            return searchHelper(root, word, 0);
        }

        private boolean searchHelper(TrieNode node, String word, int idx) {
            if (idx == word.length()) return node.isEnd;
            char c = word.charAt(idx);
            if (c == '.') {
                // Wildcard: try all children
                for (TrieNode child : node.children) {
                    if (child != null && searchHelper(child, word, idx + 1)) return true;
                }
                return false;
            } else {
                if (!node.hasChild(c)) return false;
                return searchHelper(node.getChild(c), word, idx + 1);
            }
        }
    }
}
```

---

## ⚠️ Common Mistakes
- Forgetting to mark `isEnd = true` after insert → `search("apple")` returns false even after inserting "apple"
- Not backtracking `StringBuilder` in DFS collect → incorrect prefix
- Using `String` concatenation in DFS (O(L²) GC pressure) instead of `StringBuilder`
- Not handling empty string input

---

## 🔄 Follow-up Questions
1. **How would you delete a word from a Trie?** (Mark `isEnd = false`; then backtrack and delete nodes that have no children and are not end of another word.)
2. **What is a Compressed Trie (Patricia Tree) and why use it?** (Merges single-child nodes into one edge with a substring label — reduces space at cost of more complex logic; used in IP routing tables.)
3. **How do you count total words in a Trie?** (DFS counting `isEnd == true` nodes — O(total nodes).)
