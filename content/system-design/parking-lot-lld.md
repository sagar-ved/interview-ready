---
title: "System Design: Parking Lot LLD"
date: 2024-04-04
draft: false
---

# 🧩 Question: Design a Parking Lot System with multiple levels, vehicle types, and a dynamic pricing model.

## 🎯 What the interviewer is testing
*   **OOPS Principles**: Encapsulation, Polymorphism, Inheritance.
*   **SOLID Principles**: Specifically Single Responsibility and Liskov Substitution.
*   **Design Patterns**: Factory (Vehicle creation), Strategy (Pricing), Singleton (Parking Lot management).
*   **Core Logic**: Handling slot allocation and concurrency in multi-entry points.

---

## 🧠 Deep Explanation

### 1. Requirements Clarity
-   **Vehicle Types**: Motorcycle, Car, Bus.
-   **Slot Types**: Small, Medium, Large.
-   **Parking Lot Structure**: Multiple floors, multiple entry/exit points.
-   **Pricing**: Per-hour rates based on vehicle type and duration.

### 2. Class Relationships (LLD)
-   **`Vehicle` (Abstract)**: Subclasses: `Car`, `Bus`, `Motorcycle`.
-   **`ParkingSlot`**: Holds `Vehicle`, `SlotType`, and `Availability`.
-   **`Level` (Floor)**: Contains a list of `ParkingSlot` objects.
-   **`ParkingLot` (Singleton)**: Manages levels, entry/exit gates, and global state.
-   **`EntranceGate`**: Issues `Ticket`.
-   **`ExitGate`**: Scans `Ticket`, calculates `Payment`.

### 3. Design Patterns Applied
-   **Strategy Pattern (Pricing)**: `PricingStrategy` interface with `HourlyPricingStrategy`, `WeekendPricingStrategy` etc. This allows swapping logic without changing the `ExitGate` class.
-   **Factory Pattern (Vehicle)**: To hide the creation of different vehicle objects from the UI / Entry logic.
-   **Observer Pattern (Display Board)**: To update all entry point displays whenever a slot becomes free or occupied.

### 4. Concurrency Handling
In a real-world system with multiple entry gates, two threads might try to book the same slot simultaneously.
-   **Solution**: Use thread-safe collections (`ConcurrentHashMap`) or `synchronized` blocks inside the `Level.parkVehicle()` method.

---

## ✅ Ideal Answer (Structured)

*   **Entity Mapping**: List the core entities (`Vehicle`, `Slot`, `Level`, `Ticket`).
*   **Interface Over Implementation**: Explain why `Vehicle` is an abstract class or interface.
*   **Design Choice (Slot Suitability)**: A `Small` vehicle can fit in a `Large` slot, but it's inefficient. Explain how the allocation logic prioritizes the smallest possible fit.
*   **Pricing Flexibility**: Show how to decouple pricing from the parking logic using the **Strategy Pattern**.

---

## 💻 Java Code (LLD Structure)

```java
import java.util.*;

// Enums for type safety
enum VehicleType { MOTORCYCLE, CAR, BUS }
enum SlotType { SMALL, MEDIUM, LARGE }

/** 
 * Vehicle Hierarchy 
 */
abstract class Vehicle {
    String licenseNumber;
    VehicleType type;
    public Vehicle(String licenseNumber, VehicleType type) {
        this.licenseNumber = licenseNumber;
        this.type = type;
    }
}

class Car extends Vehicle {
    public Car(String licenseNumber) { super(licenseNumber, VehicleType.CAR); }
}

/** 
 * Parking Slot Logic 
 */
class ParkingSlot {
    private final String id;
    private final SlotType size;
    private boolean isFree = true;
    private Vehicle parkedVehicle;

    public ParkingSlot(String id, SlotType size) { this.id = id; this.size = size; }
    
    public synchronized boolean park(Vehicle v) {
        if (!isFree) return false;
        this.parkedVehicle = v;
        this.isFree = false;
        return true;
    }
}

/** 
 * Strategy Pattern for Pricing 
 */
interface PricingStrategy {
    double calculate(long durationInMinutes);
}

class HourlyPricingStrategy implements PricingStrategy {
    public double calculate(long duration) { return Math.ceil(duration / 60.0) * 20.0; }
}
```

---

## ⚠️ Common Mistakes
*   **Overly Complex Inheritance**: Creating `CarSlot`, `BusSlot` as separate classes. It's better to have a `Slot` class with a `SlotType` attribute.
*   **Single Exit Entry**: Assuming only one gate. Real systems have multiple gates, requiring thread-safe slot allocation.
*   **Violating SRP**: Putting pricing logic, ticket generation, and slot searching all in the `ParkingLot` class.

---

## 🔄 Follow-up Questions
1.  **How would you handle a "Full" parking lot?** (Answer: Observer pattern to update external display boards and reject tickets at the entrance).
2.  **How to handle "Small" vehicles in "Large" slots?** (Answer: An allocation strategy that finds the most suitable slot first, falling back to larger ones if allowed).
3.  **How would you persist this in a Database?** (Answer: Map objects to relational tables: `Levels`, `Slots`, `ActiveTickets`).
