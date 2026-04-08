---
author: "sagar ved"
title: "System Design"
date: 2024-04-04
draft: false
---

# System Design Interview Prep

Deep dives into High-Level Design (HLD) and Low-Level Design (LLD) for SDE-2 interviews.

### 📚 Topic Visualization

```mermaid
mindmap
  root((System Design))
    High-Level Design
      Data & Storage
        Distributed Cache
        Message Queues
      Scalability
        Rate Limiters
        Load Balancing
      Real-World
        URL Shortener
        Search Autocomplete
        Newsfeed
    Low-Level Design
      Management Systems
        Library Management
        Hotel Booking
        Parking Lot
      Games & Services
        Chess Game
        Vending Machine
        Elevator System
```

### 📚 Topic Master Index

| Topic / Question | Read Document | Difficulty Level |
| :--- | :--- | :--- |
| Cache Penetration, Breakdown, and Avalanche | [Open ↗](/interview-ready/system-design/cache-failure-scenarios/) | ⭐⭐⭐ Hard |
| Consistency Levels (Strong vs. Eventual) | [Open ↗](/interview-ready/system-design/consistency-levels-detailed/) | ⭐⭐ Medium |
| Design Reverse Proxy (Nginx Internals) | [Open ↗](/interview-ready/system-design/reverse-proxy-nginx/) | ⭐⭐ Medium |
| Design TinyURL (Distributed) | [Open ↗](/interview-ready/system-design/tinyurl-detailed/) | ⭐⭐ Medium |
| Design Twitter (The Feed) | [Open ↗](/interview-ready/system-design/twitter-feed-architectures/) | ⭐ Easy |
| Design Twitter/News Feed (HLD) | [Open ↗](/interview-ready/system-design/news-feed-twitter/) | ⭐⭐⭐ Hard |
| Design Vector Clocks (Conflict Resolution) | [Open ↗](/interview-ready/system-design/vector-clocks-conflict/) | ⭐⭐ Medium |
| Design a CDN (Content Delivery Network) | [Open ↗](/interview-ready/system-design/cdn-detailed-routing/) | ⭐ Easy |
| Design a Distributed Chat App (WhatsApp) | [Open ↗](/interview-ready/system-design/chat-app-whatsapp/) | ⭐ Easy |
| Design a Distributed Lock | [Open ↗](/interview-ready/system-design/distributed-lock-detailed/) | ⭐ Easy |
| Design a Distributed Lock | [Open ↗](/interview-ready/system-design/distributed-lock/) | ⭐ Easy |
| Design a Distributed Metrics System | [Open ↗](/interview-ready/system-design/metrics-system/) | ⭐⭐ Medium |
| Design a Global Rate Limiter | [Open ↗](/interview-ready/system-design/rate-limiter/) | ⭐ Easy |
| Design a Key-Value Store (Consistent Hashing) | [Open ↗](/interview-ready/system-design/key-value-store/) | ⭐⭐ Medium |
| Design a Key-Value Store (LSM Trees) | [Open ↗](/interview-ready/system-design/lsm-key-value-store/) | ⭐⭐⭐ Hard |
| Design a Key-Value Store (Partitioning) | [Open ↗](/interview-ready/system-design/key-value-partitioning/) | ⭐ Easy |
| Design a Notification System | [Open ↗](/interview-ready/system-design/notification-system-detailed/) | ⭐⭐⭐ Hard |
| Design a Rate Limiter | [Open ↗](/interview-ready/system-design/rate-limiter-algorithms/) | ⭐⭐⭐ Hard |
| Design a Ride-Sharing System (Uber/Ola) | [Open ↗](/interview-ready/system-design/ride-sharing/) | ⭐⭐⭐ Hard |
| Design a Search Autocomplete System | [Open ↗](/interview-ready/system-design/search-autocomplete/) | ⭐ Easy |
| Design a Search Typeahead (Autocomplete) | [Open ↗](/interview-ready/system-design/search-autocomplete-detailed/) | ⭐⭐⭐ Hard |
| Design a Web Crawler | [Open ↗](/interview-ready/system-design/web-crawler/) | ⭐⭐ Medium |
| Design a Web Crawler | [Open ↗](/interview-ready/system-design/web-crawler-logic/) | ⭐⭐ Medium |
| Design an API Gateway | [Open ↗](/interview-ready/system-design/api-gateway-responsibilities/) | ⭐⭐ Medium |
| Design an Ad Click Counter | [Open ↗](/interview-ready/system-design/ad-click-counter/) | ⭐⭐⭐ Hard |
| Design an Image Hosting Backend (S3 + CDN) | [Open ↗](/interview-ready/system-design/image-hosting-detailed/) | ⭐ Easy |
| Distributed Cache (Redis Deep Dive) | [Open ↗](/interview-ready/system-design/distributed-cache/) | ⭐ Easy |
| Distributed ID Generator (Snowflake) | [Open ↗](/interview-ready/system-design/distributed-id-snowflake/) | ⭐⭐⭐ Hard |
| Distributed Message Queue (Kafka vs SQS) | [Open ↗](/interview-ready/system-design/message-queue-detailed/) | ⭐ Easy |
| Distributed Rate Limiter | [Open ↗](/interview-ready/system-design/distributed-rate-limiter/) | ⭐ Easy |
| Distributed Scheduler (Cron) | [Open ↗](/interview-ready/system-design/distributed-scheduler/) | ⭐⭐ Medium |
| Distributed Wallet (2PC vs. Saga) | [Open ↗](/interview-ready/system-design/distributed-wallet-saga/) | ⭐ Easy |
| Hotel Booking System (LLD) | [Open ↗](/interview-ready/system-design/hotel-booking-lld/) | ⭐⭐ Medium |
| Library Management System (LLD) | [Open ↗](/interview-ready/system-design/library-management-lld/) | ⭐⭐⭐ Hard |
| Message Queue and Event-Driven Architecture | [Open ↗](/interview-ready/system-design/message-queue-kafka/) | ⭐⭐ Medium |
| Metrics & Monitoring (Prometheus) | [Open ↗](/interview-ready/system-design/metrics-monitoring-prometheus/) | ⭐ Easy |
| Notification System | [Open ↗](/interview-ready/system-design/notification-system-design/) | ⭐⭐ Medium |
| Parking Lot LLD | [Open ↗](/interview-ready/system-design/parking-lot-lld/) | ⭐⭐ Medium |
| Recommendation Systems | [Open ↗](/interview-ready/system-design/recommendation-system-basics/) | ⭐⭐ Medium |
| Scalable Notification System (HLD) | [Open ↗](/interview-ready/system-design/notification-system-hld/) | ⭐ Easy |
| URL Shortener (HLD) | [Open ↗](/interview-ready/system-design/url-shortener/) | ⭐⭐⭐ Hard |
