---
author: "sagar ved"
title: "System Design: Recommendation Systems"
date: 2024-04-04
draft: false
weight: 27
---

# 🧩 Question: Design a Video Recommendation System (Netflix). Compare Content-Based Filtering and Collaborative Filtering.

## 🎯 What the interviewer is testing
- Machine Learning system architecture.
- Processing "Signals" (click, watch-time, like).
- Overcoming the "Cold Start" problem.

---

## 🧠 Deep Explanation

### 1. Content-Based Filtering:
- **Logic**: "User watched 'Marvel', so they will like 'DC'."
- **Data**: Metadata about the items (Genre, Actors).
- **Pros**: Works immediately for new items (if we know the metadata).
- **Cons**: Becomes predictable; doesn't "discover" new tastes.

### 2. Collaborative Filtering (User-User or Item-Item):
- **Logic**: "User A and B have similar history. A liked 'Inception', so let's show it to B."
- **Data**: User interaction matrix (the "wisdom of the crowd").
- **Pros**: Can discover surprising new genres for a user based on similar people.
- **Cons**: **Cold Start Problem** (We have no idea what to show a brand new user).

### 3. Hybrid Model (The Real World):
Use content-based for new users/items, then switch to collaborative as more data arrives. Use **Embeddings** (vectors) to perform "Nearest Neighbor" searches in multi-dimensional flavor space.

---

## ✅ Ideal Answer
Modern systems use a multi-stage funnel: Candidate Generation (filtering millions down to hundreds) followed by Ranking (using a heavy neural network to guess the score). By combining content metadata with collaborative behavioral patterns, we ensure recommendations are both personally relevant and serendipitous, maximizing long-term user engagement.

---

## 🏗️ The Pipeline:
`Ingestion (Kafka) -> Feature Store (Redis) -> Scoring (ML Model) -> Filtering (Serving API)`

---

## 🔄 Follow-up Questions
1. **What is "Matrix Factorization"?** (The mathematical core of Collaborative filtering; breaking a giant User-Item matrix into two smaller, feature-rich matrices.)
2. **How to handle "Explicit" vs "Implicit" feedback?** (Explicit = Star rating; Implicit = Watch time. Implicit is much more plentiful and often more honest.)
3. **Exploration vs Exploitation?** (Showing what you know they like vs taking a risk on something new to keep the user curious.)
