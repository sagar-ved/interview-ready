---
title: "System Design: Hotel Booking System (LLD)"
date: 2024-04-04
draft: false
weight: 8
---

# 🧩 Question: Design a hotel booking system (like Booking.com) supporting room search, reservation, cancellation, and dynamic pricing. Handle concurrent bookings for the same room.

## 🎯 What the interviewer is testing
- Concurrency control for inventory management
- SOLID and OOP design for entity modeling
- Optimistic vs pessimistic locking for bookings
- State machine for booking lifecycle

---

## 🧠 Deep Explanation

### 1. Core Entities

- **Hotel**: Basic info, amenities, policies
- **Room**: Type, price, floor, capacity, availability status
- **RoomType**: Standard, Deluxe, Suite — defines base pricing
- **Booking**: Guest, room, check-in, check-out, status, total price
- **Guest**: Profile + booking history
- **Payment**: Amount, status, method

### 2. Booking Lifecycle (State Machine)

```
PENDING (created) → CONFIRMED (payment received) → CHECKED_IN → COMPLETED
                  → CANCELLED (guest cancels before check-in)
                  → FAILED (payment failed)
                  → NO_SHOW (didn't check in)
```

### 3. Concurrency — The Double Booking Problem

Two users booking the last room simultaneously → both succeed → overbooking.

**Solution: Pessimistic Locking (for high-contention rooms)**:
```sql
BEGIN;
SELECT * FROM rooms WHERE id = ? AND status = 'AVAILABLE' FOR UPDATE;
-- If exists: proceed with booking
UPDATE rooms SET status = 'RESERVED' WHERE id = ?;
INSERT INTO bookings ...;
COMMIT;
```

**Solution: Optimistic Locking (for low-contention)**:
```sql
UPDATE rooms SET status = 'RESERVED', version = version + 1
WHERE id = ? AND status = 'AVAILABLE' AND version = ?;
-- If 0 rows affected: retry with fresh read
```

### 4. Dynamic Pricing

- **Peak season**: +30% base rate
- **Last minute** (< 3 days): -20%
- **Occupancy-based**: > 80% occupancy → +15%
- Strategy Pattern: `PricingStrategy` interface with multiple implementations

---

## ✅ Ideal Answer

- Separate `Room` (inventory unit) from `RoomType` (type/pricing template).
- Use `SELECT FOR UPDATE` (pessimistic lock) for bookings — consistency > throughput here.
- Price computed by chain of `PricingStrategy` decorators.
- Async payment processing — booking goes to PENDING, payment service confirms → CONFIRMED.
- Idempotency key on booking creation to prevent double submission.

---

## 💻 Java Code

```java
import java.time.*;
import java.util.*;
import java.util.function.*;

// ====== Core Enums ======
enum RoomStatus { AVAILABLE, RESERVED, OCCUPIED, MAINTENANCE }
enum BookingStatus { PENDING, CONFIRMED, CHECKED_IN, COMPLETED, CANCELLED, FAILED, NO_SHOW }
enum RoomType { STANDARD, DELUXE, SUITE }

// ====== Entities ======
class Room {
    private final int roomId;
    private final RoomType type;
    private final int floor;
    private final double basePrice; // Per night
    private RoomStatus status;

    Room(int roomId, RoomType type, int floor, double basePrice) {
        this.roomId = roomId;
        this.type = type;
        this.floor = floor;
        this.basePrice = basePrice;
        this.status = RoomStatus.AVAILABLE;
    }

    public synchronized boolean reserve() {
        if (status != RoomStatus.AVAILABLE) return false;
        status = RoomStatus.RESERVED;
        return true;
    }

    public void release() { status = RoomStatus.AVAILABLE; }
    public RoomStatus getStatus() { return status; }
    public int getRoomId() { return roomId; }
    public double getBasePrice() { return basePrice; }
}

// ====== Strategy Pattern: Dynamic Pricing ======
@FunctionalInterface
interface PricingStrategy {
    double applyDiscount(double basePrice, LocalDate checkIn, LocalDate checkOut);
}

class PeakSeasonPricing implements PricingStrategy {
    @Override
    public double applyDiscount(double basePrice, LocalDate checkIn, LocalDate checkOut) {
        // Surcharge for Dec-Jan
        if (checkIn.getMonthValue() == 12 || checkIn.getMonthValue() == 1) {
            return basePrice * 1.30;
        }
        return basePrice;
    }
}

class LastMinutePricing implements PricingStrategy {
    @Override
    public double applyDiscount(double basePrice, LocalDate checkIn, LocalDate checkOut) {
        if (ChronoUnit.DAYS.between(LocalDate.now(), checkIn) < 3) {
            return basePrice * 0.80; // 20% discount
        }
        return basePrice;
    }
}

// ====== Booking Entity ======
class Booking {
    private final String bookingId;
    private final int guestId;
    private final Room room;
    private final LocalDate checkIn;
    private final LocalDate checkOut;
    private BookingStatus status;
    private double totalPrice;

    Booking(int guestId, Room room, LocalDate checkIn, LocalDate checkOut, double totalPrice) {
        this.bookingId = UUID.randomUUID().toString();
        this.guestId = guestId;
        this.room = room;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.status = BookingStatus.PENDING;
        this.totalPrice = totalPrice;
    }

    public void confirm() { this.status = BookingStatus.CONFIRMED; }
    public void cancel() {
        this.status = BookingStatus.CANCELLED;
        room.release(); // Make room available again
    }

    public String getBookingId() { return bookingId; }
    public BookingStatus getStatus() { return status; }
}

// ====== Booking Service ======
class BookingService {
    private final List<Room> rooms;
    private final List<PricingStrategy> pricingChain;
    private final Map<String, Booking> bookings = new HashMap<>();

    BookingService(List<Room> rooms, List<PricingStrategy> pricingChain) {
        this.rooms = rooms;
        this.pricingChain = pricingChain;
    }

    public Booking createBooking(int guestId, RoomType type, LocalDate checkIn, LocalDate checkOut) {
        // 1. Find available room of requested type
        Room room = findAvailableRoom(type)
            .orElseThrow(() -> new NoSuchElementException("No available " + type + " rooms"));

        // 2. Attempt to reserve (synchronized — thread safe)
        if (!room.reserve()) {
            throw new IllegalStateException("Room taken by concurrent booking");
        }

        // 3. Calculate price with all pricing strategies applied
        long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
        double pricePerNight = room.getBasePrice();
        for (PricingStrategy strategy : pricingChain) {
            pricePerNight = strategy.applyDiscount(pricePerNight, checkIn, checkOut);
        }
        double totalPrice = pricePerNight * nights;

        // 4. Create booking in PENDING state
        Booking booking = new Booking(guestId, room, checkIn, checkOut, totalPrice);
        bookings.put(booking.getBookingId(), booking);
        return booking;
    }

    public void confirmPayment(String bookingId) {
        Booking booking = bookings.get(bookingId);
        if (booking == null) throw new NoSuchElementException("Booking not found");
        booking.confirm();
    }

    private Optional<Room> findAvailableRoom(RoomType type) {
        return rooms.stream()
            .filter(r -> r.getStatus() == RoomStatus.AVAILABLE)
            .findFirst(); // In production: more sophisticated search (floor, view, price)
    }
}
```

---

## ⚠️ Common Mistakes
- Not separating search (read-heavy) from booking (write-heavy) — they need different data stores
- Synchronizing at room-level but not considering distributed lock (multiple servers)
- Not handling partial booking failure (room reserved but payment fails → room stuck in RESERVED)
- Missing cancellation policy logic (full refund vs partial vs no refund based on timing)

---

## 🔄 Follow-up Questions
1. **How do you handle distributed booking locks (multiple servers)?** (Redis-based distributed lock with `SETNX` on `room:{roomId}:lock`; TTL prevents permanent lock on crash.)
2. **How would you implement overbooking buffer (like airlines)?** (Allow slightly more bookings than rooms; if overbooked, offer upgrades or compensation. Track `confirmed_bookings` vs `physical_capacity`.)
3. **How would you scale room search to handle millions of queries?** (Elasticsearch for full-text + filtered search on hotel/room attributes; cache popular date-range availability in Redis.)
