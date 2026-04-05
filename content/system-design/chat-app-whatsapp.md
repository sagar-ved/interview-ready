---
title: "System Design: Design a Distributed Chat App (WhatsApp)"
date: 2024-04-04
draft: false
weight: 21
---

# 🧩 Question: Design a chat app like WhatsApp. Handle one-on-one and group chats, status (online/offline), and message persistence.

## 🎯 What the interviewer is testing
- Persistent connection management (WebSockets).
- Presence service sharding.
- Message storage schema (SQL vs NoSQL).

---

## 🧠 Deep Explanation

### 1. Connection:
Uses **WebSockets** (or XMPP) for bi-directional, persistent connection.
- **Challenge**: Tracking which user is on which "Chat Server" (Machine ID).
- **Presence Service**: Uses **Redis** (as a KV store) to map `UserID -> ServerID`.

### 2. Message Flow (1-on-1):
1. User A sends message to Server 1.
2. Server 1 checks Presence Service: User B is on Server 5.
3. Server 1 forwards message to Server 5 (via a Message Queue like Kafka).
4. Server 5 pushes to User B.
5. If User B is offline, store in DB for later.

### 3. Database:
- **Messages**: billions of tiny messages. Use **NoSQL** (Cassandra or HBase) for high write-throughput and easy partitioning by `Chat_ID`.
- **Media**: S3 with CDN.

---

## ✅ Ideal Answer
A chat application scales by maintaining thousands of persistent WebSocket connections. We track user availability via a presence service in Redis. For message delivery, we use a message queue to route communications between different servers, ensuring that messages are either delivered instantly to online users or persisted in a distributed NoSQL database for later delivery to offline users.

---

## 🏗️ Schema Example:
```
Table: messages
  id: UUID
  chat_id: String (Partition Key)
  sender_id: String
  content: Text
  timestamp: Long (Clustering Key)
```

---

## 🔄 Follow-up Questions
1. **How to handle "Read Receipts"?** (Another message sent back: `ACK -> DELIVERED -> READ` updates.)
2. **How to handle Group Chats?** (Instead of direct routing, messages go to a "Group Topic" in Kafka; all active members consume from that topic.)
3. **End-to-End Encryption (E2EE)?** (Server never sees the message content; it only handles routing of ciphertext.)
