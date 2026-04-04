---
title: "System Design: Design a Search Autocomplete System"
date: 2024-04-04
draft: false
weight: 4
---

# 🧩 Question: Design a search autocomplete system like Google Search that suggests the top 5 completions as user types, handling 10 billion queries per day.

## 🎯 What the interviewer is testing
- Trie data structure for prefix matching
- Ranking (frequency-based + personalization)
- Caching of prefix results
- Scale: distributed Trie, real-time vs batch updates

---

## 🧠 Deep Explanation

### 1. Core Data Structure: Trie

A Trie (Prefix Tree) allows O(L) prefix lookups where L = prefix length.

Each node stores:
- Character map to children
- Top-K suggestions precomputed at this node (avoids full subtree traversal)
- Frequency count (updated as queries come in)

### 2. Scale Estimation

- 10B queries/day ≈ 115K queries/sec
- Average query length: 5 chars → 15 autocomplete calls per query (user types 5 chars × 3 updates mid-word)
- 15 × 115K = 1.7M autocomplete requests/sec

This means **every keystroke** triggers a backend call. Caching is existential.

### 3. Real-Time vs Batch Updates

- **Real-time**: Update Trie frequencies on every query. Problem: 1.7M writes/sec to an in-memory Trie is destructive to read performance.
- **Batch (preferred)**: Use Kafka to buffer query events; batch aggregate every hour; rebuild or update the Trie with new frequencies.
- **Hybrid**: Real-time for personalized suggestions (user's own history), batch for global suggestions.

### 4. System Components

```
User Keystroke
    ↓
CDN Cache (prefix → top5) [TTL: 5 min]
    ↓ cache miss
Load Balancer
    ↓
Autocomplete Service (in-memory Trie or Redis)
    ↓
Query Logger → Kafka → Aggregator → Trie Update Worker
```

---

## ✅ Ideal Answer

1. **Data structure**: Trie with top-K cached at each node to avoid full DFS on every keystroke.
2. **Storage**: Redis for small tries; distributed Trie sharded by first character for horizontal scaling.
3. **Ranking**: Frequency × recency × personalization (user's history) combined into a score.
4. **Updates**: Batch updates via Kafka aggregation. Refresh Trie every hour.
5. **CDN Caching**: Cache common prefixes at CDN edge — "th" → "the", "that", "then" is the same for 99% of users.

---

## 💻 Trie Implementation (Java)

```java
import java.util.*;

public class AutoCompleteSystem {

    static class TrieNode {
        Map<Character, TrieNode> children = new HashMap<>();
        // Precomputed top-5 for this prefix — avoids full subtree DFS per keystroke
        List<String> topSuggestions = new ArrayList<>();
        int frequency = 0; // For leaf nodes: query frequency
    }

    private final TrieNode root = new TrieNode();
    private final int TOP_K = 5;

    public void insert(String query, int frequency) {
        TrieNode node = root;
        for (char c : query.toCharArray()) {
            node.children.putIfAbsent(c, new TrieNode());
            node = node.children.get(c);
            updateTopSuggestions(node, query, frequency);
        }
        node.frequency = frequency; // Mark as complete query at end
    }

    private void updateTopSuggestions(TrieNode node, String query, int freq) {
        // Keep a sorted list of top-K completions at each node
        node.topSuggestions.removeIf(s -> s.equals(query));
        node.topSuggestions.add(query);
        // Sort by frequency (in real system, store freq alongside string)
        node.topSuggestions.sort((a, b) -> Integer.compare(
            getFreq(b), getFreq(a)
        ));
        if (node.topSuggestions.size() > TOP_K) {
            node.topSuggestions.remove(TOP_K);
        }
    }

    // Stub: in real system, frequency is stored in a HashMap<String, Integer>
    private int getFreq(String query) { return 0; }

    public List<String> search(String prefix) {
        TrieNode node = root;
        for (char c : prefix.toCharArray()) {
            if (!node.children.containsKey(c)) return Collections.emptyList();
            node = node.children.get(c);
        }
        return node.topSuggestions; // O(1) after traversal — precomputed!
    }
}
```

---

## ⚠️ Common Mistakes
- Doing DFS on every autocomplete request (too slow at scale — precompute top-K)
- Not caching prefix results (calling backend on every keystroke)
- Ignoring personalization — Google's suggestions are NOT purely global frequency
- Storing the full Trie in a single Redis key (memory/performance issue)

---

## 🔄 Follow-up Questions
1. **How do you handle multilingual autocomplete?** (Separate Trie per language; detect user locale; CDN routing by locale.)
2. **How do you prevent offensive/harmful suggestions?** (Blacklist filter applied before returning results; ML-based content classifier.)
3. **How does this differ from full-text search (Elasticsearch)?** (Trie is optimized for prefix matching; Elasticsearch uses inverted index for full-text, fuzzy, and relevance ranking.)
