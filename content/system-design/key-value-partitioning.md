---
title: "System Design: Design a Key-Value Store (Partitioning)"
date: 2024-04-04
draft: false
weight: 24
---

# 🧩 Question: How do you partition a massive Key-Value store? Focus on Hot-spot mitigation and Rebalancing.

## 🎯 What the interviewer is testing
- Consistent Hashing revisit.
- Multi-dimensional partitioning.
- Scaling out a storage cluster.

---

## 🧠 Deep Explanation

### 1. The Partition Key:
How do we decide which row goes to which server?
- **Hash-based**: `hash(key) % N`. Good distribution, but hard to rebalance.
- **Range-based**: `A-M` on Server 1, `N-Z` on Server 2. Great for range scans, but can lead to "Hot-spots" (e.g., if everyone's name starts with 'S').

### 2. Solving Hotspots:
- **Consistent Hashing**: Use virtual nodes. This ensures that even if one server is bigger, we can assign it more "slots" on the ring.
- **Pre-splitting**: Split your range into many small "Logical Partitions" (e.g. 1024) and move these logical blocks between physical servers.

### 3. Rebalancing:
When adding a node, you shouldn't MOVE all data. 
- **The Ideal**: Only $1/N$ of data should move.
- **Live Migration**: The source server continues taking reads while data is streaming to the new destination.

---

## ✅ Ideal Answer
Scaling a key-value store is a balancing act between data locality and cluster load. We use consistent hashing to map data to a virtual coordinate space, allowing for seamless expansion without massive data reshuffling. To prevent localized bottlenecks, we decouple logical data partitions from physical hardware, moving granular blocks to maintain equilibrium as the cluster grows.

---

## 🔄 Follow-up Questions
1. **What is a "Logical Partition"?** (A small unit of data [e.g. 100MB] that is the smallest thing the balancer can move.)
2. **How to find which server has my key?** (The client often has the 'Partition Map' cached and talks DIRECTLY to the correct IP. This is called "Client-side load balancing".)
3. **What is Gossip Protocol?** (How servers in a cluster tell each other "Hey, Node X is down" or "I am now responsible for Partition 5.")
