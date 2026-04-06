---
author: "sagar ved"
title: "Networks: TCP 3-Way Handshake vs. 4-Way Teardown"
date: 2024-04-04
draft: false
weight: 19
---

# 🧩 Question: Explain the TCP 3-Way Handshake and the 4-Way Teardown. Why do we need 4 steps to close but only 3 to open?

## 🎯 What the interviewer is testing
- Connection lifecycle states (`SYN`, `ACK`, `FIN`, `TIME_WAIT`).
- Reliability and state synchronization.
- Half-close state understanding.

---

## 🧠 Deep Explanation

### 1. The Handshake (3 steps):
1. **SYN**: Client sends "Let's connect, my Sequence ID is X".
2. **SYN-ACK**: Server says "Agreed. Your X is received. My ID is Y."
3. **ACK**: Client says "Your Y is received. Let's go."

### 2. The Teardown (4 steps):
1. **FIN**: Side A says "I'm done sending data."
2. **ACK**: Side B says "Acknowledged. I might still have data to send you." (**Half-closed state**)
3. **FIN**: Side B says "I'm done too."
4. **ACK**: Side A says "Got it. Goodbye."

### 3. Why the difference?
Connections are **Full-Duplex**. Just because one side is done sending doesn't mean the other is. Thus, both sides must independently negotiate their closure, leading to the extra step.

---

## ✅ Ideal Answer
TCP requires a 3-way handshake to synchronize sequence numbers and establish initial state. The teardown requires 4 steps because TCP is bi-directional; each side must independently signal its completion. This "graceful close" ensures that all in-flight data is reliably received before the connection is completely severed.

---

## 🏗️ State Spotlight: TIME_WAIT
After the last `ACK`, the client waits for ~2 minutes (2MSL).
- **Reason**: To handle the case where the last `ACK` is lost and the server re-sends its `FIN`. Also to prevent old packets from a "dead" connection from interfering with a "new" connection on the same port.

---

## 🔄 Follow-up Questions
1. **What is a "SYN Flood" attack?** (Attacker sends thousands of SYNs but never sends the final ACKs, exhausting server resources.)
2. **Can data be sent in the 3rd step of the handshake?** (Yes, the ACK can carry some payload.)
3. **What is the "Half-open" state?** (One side crashed or closed without the other knowing; the link is dead but one side thinks it's alive.)
