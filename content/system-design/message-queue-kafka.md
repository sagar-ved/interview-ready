---
title: "System Design: Message Queue and Event-Driven Architecture"
date: 2024-04-04
draft: false
weight: 6
---

# 🧩 Question: Design a reliable, scalable message queue system between microservices. When would you use Kafka vs RabbitMQ? Handle at-least-once delivery and idempotency.

## 🎯 What the interviewer is testing
- Message queue semantics (at-most-once, at-least-once, exactly-once)
- Kafka internals: partitions, offsets, consumer groups
- RabbitMQ: exchanges, queues, bindings
- Idempotent consumers — practical design for reliability

---

## 🧠 Deep Explanation

### 1. Message Delivery Semantics

| Semantic | Meaning | Achieved via |
|---|---|---|
| **At-most-once** | Message may be lost; never duplicated | Fire and forget; no ACK |
| **At-least-once** | No message lost; may be duplicated | Retry on failure (most common) |
| **Exactly-once** | No loss; no duplicates | Idempotent consumer + transactions |

True exactly-once is extremely hard in distributed systems. Production systems at Amazon, Uber, and Google build **idempotent consumers** to handle at-least-once delivery.

### 2. Kafka Internals

- **Topic**: Category for messages
- **Partition**: Unit of parallelism. Each partition is an ordered, immutable log.
- **Offset**: Position of a message within a partition. Consumers track their own offset.
- **Consumer Group**: Multiple consumers share the partitions; each partition assigned to exactly one consumer in the group.
- **Retention**: Messages are retained for a configurable period (7 days default) even after consumption.
- **Performance**: Sequential disk writes + `sendfile()` zero-copy = millions of msg/sec

### 3. Kafka vs RabbitMQ

| Dimension | Kafka | RabbitMQ |
|---|---|---|
| Model | Log (pull) | Queue (push) |
| Retention | Days/weeks | Until consumed |
| Replay | Yes (offset rewind) | No (once consumed, gone) |
| Throughput | Very high (millions/sec) | Moderate (thousands/sec) |
| Ordering | Per-partition | Per-queue |
| Routing | Topic + partition key | Exchange types (fanout, topic, direct) |
| Use Case | Event streaming, analytics | Task queues, RPC, workflows |

**Rule of thumb**: Use **Kafka** for high-throughput event streams and event sourcing. Use **RabbitMQ** for task queues and complex routing requirements.

### 4. Exactly-Once via Idempotency

```
Producer assigns unique messageId
Consumer checks: processed_ids SET in Redis
    IF messageId in processed_ids → skip
    ELSE → process, add to processed_ids, set TTL
```

---

## ✅ Ideal Answer

- **Kafka** for the high-throughput event bus; **RabbitMQ** for low-latency task queues with complex routing.
- **Reliability**: Producer `acks=all` + `min.insync.replicas=2` for durability.
- **Consumer**: At-least-once delivery; idempotent processing via unique `messageId` + Redis deduplication.
- **Partition Key**: Choose wisely — `userId` for ordered per-user events; random for maximum parallelism.

---

## 💻 Java Code

```java
import org.apache.kafka.clients.producer.*;
import org.apache.kafka.clients.consumer.*;
import java.time.Duration;
import java.util.*;

/**
 * Kafka producer with durability settings
 */
public class ReliableKafkaProducer {

    private final KafkaProducer<String, String> producer;

    public ReliableKafkaProducer(String bootstrapServers) {
        Properties props = new Properties();
        props.put("bootstrap.servers", bootstrapServers);
        props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
        props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

        // Durability settings
        props.put("acks", "all");          // Wait for all in-sync replicas
        props.put("retries", 3);           // Retry on transient failure
        props.put("enable.idempotence", "true"); // Exactly-once producer semantics
        props.put("max.in.flight.requests.per.connection", "1"); // Maintain ordering with retries

        this.producer = new KafkaProducer<>(props);
    }

    public void sendOrderEvent(String orderId, String eventJson) {
        ProducerRecord<String, String> record = new ProducerRecord<>(
            "orders",       // topic
            orderId,        // partition key — same orderId → same partition (ordered)
            eventJson       // message value (JSON)
        );

        producer.send(record, (metadata, ex) -> {
            if (ex != null) {
                System.err.println("Failed to send: " + ex.getMessage());
            } else {
                System.out.printf("Sent to partition %d, offset %d%n",
                    metadata.partition(), metadata.offset());
            }
        });
    }
}

/**
 * Idempotent Kafka consumer
 */
class IdempotentOrderConsumer {

    private final KafkaConsumer<String, String> consumer;
    private final Set<String> processedIds = new HashSet<>(); // In production: Redis with TTL

    public IdempotentOrderConsumer(String bootstrapServers, String groupId) {
        Properties props = new Properties();
        props.put("bootstrap.servers", bootstrapServers);
        props.put("group.id", groupId);
        props.put("auto.offset.reset", "earliest");
        props.put("enable.auto.commit", "false"); // Manual commit for at-least-once control

        this.consumer = new KafkaConsumer<>(props);
        consumer.subscribe(List.of("orders"));
    }

    public void consume() {
        while (true) {
            ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100));

            for (ConsumerRecord<String, String> record : records) {
                String messageId = record.key() + "-" + record.offset(); // Unique per message

                if (processedIds.contains(messageId)) {
                    System.out.println("Duplicate detected, skipping: " + messageId);
                    continue; // Idempotency check — skip duplicates
                }

                try {
                    processOrder(record.value());
                    processedIds.add(messageId); // Mark as processed
                    consumer.commitSync(); // Commit offset only after successful processing
                } catch (Exception e) {
                    System.err.println("Processing failed: " + e.getMessage());
                    // Do NOT commit offset → message will be redelivered
                }
            }
        }
    }

    private void processOrder(String orderJson) {
        // Business logic: validate, persist, trigger downstream events
    }
}
```

---

## ⚠️ Common Mistakes
- Committing offset BEFORE processing (auto.commit default = true) → lost messages if consumer crashes
- Using the same partition key for all messages (single hot partition = zero parallelism)
- Not implementing idempotent consumers and assuming Kafka provides exactly-once by default
- Not setting `min.insync.replicas >= 2` — data loss on broker crash with `acks=all` but single ISR

---

## 🔄 Follow-up Questions
1. **How does Kafka consumer group rebalancing work?** (When a consumer joins/leaves, the group coordinator triggers rebalancing — partitions are redistributed. Incremental cooperative rebalancing (Kafka 2.4+) minimizes disruption.)
2. **What is log compaction in Kafka?** (Retains the last value for each unique key — useful for event sourcing where you only need the latest state.)
3. **How do you implement request-response over Kafka?** (Reply topic per producer + correlation ID header; consumer sends response to reply topic; producer awaits on reply topic with timeout.)
