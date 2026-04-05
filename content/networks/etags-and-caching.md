---
title: "Networks: HTTP Headers (ETag and Caching)"
date: 2024-04-04
draft: false
weight: 19
---

# 🧩 Question: How do the `ETag` and `If-None-Match` headers work together? Explain "Conditional Requests."

## 🎯 What the interviewer is testing
- Efficient bandwidth utilization.
- Cache validation logic.
- Awareness of stale data handling.

---

## 🧠 Deep Explanation

1. **The Request**: Browser asks for `image.png`.
2. **The Response**: Server sends the image along with an `ETag` (a hash of the file content, e.g., `W/6789`).
3. **Caching**: Browser stores the image AND the ETag.
4. **Conditional Request**: Next time the browser needs the image:
   - It sends a request with `If-None-Match: W/6789`.
5. **The Server Logic**:
   - If the file hasn't changed, its hash is still `W/6789`.
   - The server replies with **304 Not Modified** (no body!).
   - If it HAS changed, the server sends the new file and a new ETag.

### Impact:
Saves massive bandwidth by not sending the same file twice if the client already has a valid copy.

---

## ✅ Ideal Answer
ETags provide a unique fingerprint for a resource's content. By using conditional requests, a client can ask the server to only send the resource if the fingerprint has changed. This "304 Not Modified" mechanism is fundamental to modern web performance, shifting the burden from downloading large assets to merely validating their existing state.

---

## 🏗️ Other Cache Headers:
- **Last-Modified / If-Modified-Since**: Time-based validation.
- **Cache-Control: max-age=60**: Don't even ask the server for 60 seconds (Client-side cache).
- **Vary**: Tells the CDN that the cache depends on a header (e.g. `Vary: Accept-Encoding` means cache separate versions for Gzip vs Brotli).

---

## 🔄 Follow-up Questions
1. **What is a "Weak ETag"?** (Starts with `W/`; indicates the content is semantically the same even if its exact bytes changed in a minor way.)
2. **Difference between ETag and Last-Modified?** (ETag is content-based; Last-Modified is time-based. ETag is more accurate for files updated frequently.)
3. **What is "Fingerprinting" in asset filenames?** (Putting hashes in URLs like `app.v3.js` to bypass cache headers entirely.)
