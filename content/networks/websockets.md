---
title: "WebSockets and Real-Time Communication"
date: 2024-04-04
draft: false
weight: 6
---

# 🧩 Question: How does WebSocket differ from HTTP long-polling and SSE? Build the network layer of a real-time collaborative document (like Google Docs).

## 🎯 What the interviewer is testing
- WebSocket handshake and upgrade mechanism
- Comparison of real-time techniques
- Broadcast architectures using message queues
- Horizontal scaling of WebSocket servers

---

## 🧠 Deep Explanation

### 1. Long-Polling vs SSE vs WebSocket

| Technique | Protocol | Direction | Use Case |
|---|---|---|---|
| **Long-Polling** | HTTP | Server → Client (simulated) | Simple notifications |
| **Server-Sent Events (SSE)** | HTTP/2 | Server → Client only | Stock tickers, notifications |
| **WebSocket** | WS (over TCP) | Full-duplex (both ways) | Chat, collaboration, gaming |

**Long-Polling**: Client sends HTTP request; server holds it open until there's data. Then client immediately sends a new request. High overhead (new HTTP connection each time).

**SSE**: HTTP connection kept open; server pushes events as `data: ...\n\n` frames. Built-in reconnection. HTTP/2 efficient. Client can't send to server (use separate HTTP requests).

**WebSocket**: Starts as HTTP, upgrades to WS protocol. Full-duplex binary or text frames. No HTTP overhead per message. Must handle reconnection manually.

### 2. WebSocket Handshake

```
Client → Server: HTTP GET /chat
  Headers: Upgrade: websocket
           Connection: Upgrade
           Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
           Sec-WebSocket-Version: 13

Server → Client: HTTP 101 Switching Protocols
  Headers: Upgrade: websocket
           Connection: Upgrade
           Sec-WebSocket-Accept: (SHA1 of key + GUID, base64)
[WS frames flow now]
```

### 3. Scaling WebSockets

HTTP is stateless; any server handles any request. WebSocket connections are **stateful** — the client is connected to ONE specific server.

**Challenge**: If user A is on Server 1 and user B is on Server 2, how does A's message reach B?

**Solution**: Pub/Sub via Redis or Kafka:
- Server 1 receives message from A → publishes to Redis channel `doc:123`
- Server 2 (where B is connected) subscribes to `doc:123` → receives and forwards to B

---

## ✅ Ideal Answer

- Use WebSocket for Google Docs — full-duplex: user sends keystrokes, server sends merged document state.
- For horizontal scaling: each server publishes incoming changes to Kafka/Redis pub-sub; all servers subscribe to relevant doc channels and broadcast to their connected users.
- Handle reconnection client-side with exponential backoff.
- Use Operational Transformation (OT) or CRDT for conflict resolution.

---

## 💻 Java Code (Spring WebSocket)

```java
import org.springframework.web.socket.*;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import java.util.*;
import java.util.concurrent.*;

/**
 * Real-time document collaboration WebSocket handler
 */
@org.springframework.stereotype.Component
public class DocCollaborationHandler extends TextWebSocketHandler {

    // Map: docId → Set of WebSocketSessions (users viewing this doc)
    private final Map<String, Set<WebSocketSession>> docSessions =
        new ConcurrentHashMap<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        String docId = extractDocId(session);
        docSessions.computeIfAbsent(docId, k -> ConcurrentHashMap.newKeySet())
                   .add(session);
        System.out.println("User connected to doc: " + docId + " | Session: " + session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String docId = extractDocId(session);
        // In production: apply Operational Transformation / CRDT here
        // Broadcast change to ALL sessions for this doc (including sender for confirmation)
        String payload = message.getPayload();

        Set<WebSocketSession> sessions = docSessions.getOrDefault(docId, Set.of());
        for (WebSocketSession s : sessions) {
            if (s.isOpen()) {
                s.sendMessage(new TextMessage(payload));
                // For horizontal scaling: also publish to Redis pub-sub:
                // redisPublisher.publish("doc:" + docId, payload);
            }
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        String docId = extractDocId(session);
        Set<WebSocketSession> sessions = docSessions.get(docId);
        if (sessions != null) sessions.remove(session);
        System.out.println("Session disconnected: " + session.getId());
    }

    private String extractDocId(WebSocketSession session) {
        // Extract from URL: /ws/docs/{docId}
        String path = Objects.requireNonNull(session.getUri()).getPath();
        return path.substring(path.lastIndexOf('/') + 1);
    }
}

// WebSocket Configuration (Spring)
// @Configuration
// @EnableWebSocket
// class WebSocketConfig implements WebSocketConfigurer {
//     @Override
//     public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
//         registry.addHandler(new DocCollaborationHandler(), "/ws/docs/**")
//                 .setAllowedOrigins("*");  // Production: restrict to known origins
//     }
// }
```

---

## ⚠️ Common Mistakes
- Using WebSocket for simple notification scenarios (SSE is simpler, HTTP/2 native)
- Not closing dead WebSocket sessions (memory leak — sessions accumulate)
- Not handling `WebSocket 1001 Going Away` (server restart) gracefully client-side
- Storing WebSocket sessions in a thread-local (sessions are used across event threads)

---

## 🔄 Follow-up Questions
1. **How does Operational Transformation (OT) solve concurrent edits?** (Transform pending operations based on already-applied ops; Google Docs used this. CRDTs are the modern alternative — automatic conflict-free merging.)
2. **How does Nginx handle WebSocket proxying?** (Nginx passes `Upgrade` headers forward to the backend; keeps the connection open; does not terminate the WS handshake itself in pass-through mode.)
3. **What is WebRTC and how does it differ from WebSocket?** (WebRTC: peer-to-peer, browser-to-browser media streaming; uses STUN/TURN for NAT traversal; no server relay needed for media. WebSocket is server-mediated.)
