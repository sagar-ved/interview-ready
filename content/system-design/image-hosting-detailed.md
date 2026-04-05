---
title: "System Design: Design an Image Hosting Backend (S3 + CDN)"
date: 2024-04-04
draft: false
weight: 22
---

# 🧩 Question: Design a system to handle high-resolution image uploads and serving (like Flickr/Instagram). Focus on thumbnail generation and serving at scale.

## 🎯 What the interviewer is testing
- Handling large binary objects (BLOBs).
- Decoupling processing from ingestion.
- Multi-region CDN serving.

---

## 🧠 Deep Explanation

### 1. Upload Path:
Client → **API Gateway** → **Image Service** → **Object Store (S3)**.
- **Direct Upload (Optimization)**: Instead of piping bytes through your app, have your app generate a **Signed URL** (temporary permission) and give it to the client. The client uploads directly to S3. This saves your server bandwidth and CPU.

### 2. Processing (Thumbnail generation):
When image lands in S3, it triggers an **S3 Event** → **Lambda function** (or Message Queue → Workers).
- The worker generates different sizes (small, med, large) and saves them back to S3.

### 3. Serving:
User → **CDN (Cloudfront/Cloudflare)** → **Object Store**.
- CDN caches the images globally.
- **URL naming**: `/image_id/size.webp`.

---

## ✅ Ideal Answer
To scale image hosting, we move the heavy lifting away from our application servers. We use pre-signed URLs for direct client-to-store uploads and a serverless pipeline for asynchronous image resizing. Serving is handled exclusively via a CDN to minimize latency and offload the traffic from our primary storage.

---

## 🏗️ Architecture
```
[User App] -> [Auth API] -> [Generate Signed URL] 
                               ↓
[User App] -> (Direct Upload) -> [S3] -> [Lambda (Resize)] -> [S3 (Processed)]
                                                                    ↓
[User] <--------------------- [CDN] <-------------------------------|
```

---

## 🔄 Follow-up Questions
1. **How to handle "Deleted" images in CDN?** (Caches can be purged via API, or use a versioned URL like `img_v2.png`.)
2. **Formats?** (Convert everything to **WebP** for better compression/quality ratio.)
3. **What is a "Signed URL"?** (A short-lived URL containing an HMAC signature that grants temporary access to a resource.)
