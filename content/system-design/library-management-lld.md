---
author: "sagar ved"
title: "System Design: Library Management System (LLD)"
date: 2024-04-04
draft: false
weight: 6
---

# 🧩 Question: Design a Library Management System supporting book search, lending, returns, fines, and reservations.

## 🎯 What the interviewer is testing
- Class modeling and entity relationships
- SOLID principles: SRP, OCP, LSP
- State machine for book lifecycle
- Design patterns: Strategy (fine calculation), Repository, Observer

---

## 🧠 Deep Explanation

### 1. Core Entities

- **Book**: ISBN, title, author, genre, total copies, available copies
- **BookItem**: Individual physical copy of a book (barcode, rack location, condition)
- **Member**: Member ID, name, contact, active loans, fine balance
- **Loan**: Book item, member, issue date, due date, return date
- **Reservation**: Book, member, reservation date, status (pending/fulfilled/expired)
- **Librarian**: Admin who can add/remove books, create members, override fines

### 2. Book Lifecycle (State Machine)

```
AVAILABLE → LOANED (when checked out)
LOANED → AVAILABLE (when returned on time)
LOANED → OVERDUE (when due date passes)
OVERDUE → AVAILABLE (when returned with fine)
AVAILABLE → RESERVED (when reserved by member)
RESERVED → LOANED (when reserved member picks up)
```

### 3. Design Patterns Applied

- **Strategy Pattern**: `FineCalculationStrategy` — flat rate, per-day rate, premium member rate
- **Repository Pattern**: `BookRepository`, `LoanRepository` — decouple data access from business logic
- **Observer Pattern**: When a book is returned, notify waiting members with reservations
- **Facade Pattern**: `LibraryFacade` — single entry point for UI layer

---

## ✅ Ideal Answer

- Model `Book` (catalog entry) separately from `BookItem` (physical copy).
- Use a `State` pattern for BookItem status transitions.
- Use `Strategy` for fine calculation rules.
- Use `Observer` to notify reservation queue when a copy becomes available.
- All persistence via Repository interfaces — easily swappable to DB or in-memory.

---

## 💻 Java Code

```java
import java.time.*;
import java.util.*;

// ====== Enums ======
enum BookStatus { AVAILABLE, LOANED, OVERDUE, RESERVED, LOST }
enum MemberType { REGULAR, STUDENT, PREMIUM }

// ====== Book Catalog Entry ======
class Book {
    private final String isbn;
    private final String title;
    private final String author;
    private final List<BookItem> copies = new ArrayList<>();

    Book(String isbn, String title, String author) {
        this.isbn = isbn;
        this.title = title;
        this.author = author;
    }

    public void addCopy(BookItem item) { copies.add(item); }

    public Optional<BookItem> getAvailableCopy() {
        return copies.stream()
            .filter(item -> item.getStatus() == BookStatus.AVAILABLE)
            .findFirst();
    }

    public String getIsbn() { return isbn; }
    public String getTitle() { return title; }
}

// ====== Physical Book Copy ======
class BookItem {
    private final String barcode;
    private BookStatus status = BookStatus.AVAILABLE;

    BookItem(String barcode) { this.barcode = barcode; }

    public BookStatus getStatus() { return status; }
    public void setStatus(BookStatus s) { this.status = s; }
    public String getBarcode() { return barcode; }
}

// ====== Loan (Transaction Record) ======
class Loan {
    private final String loanId;
    private final Member member;
    private final BookItem bookItem;
    private final LocalDate issueDate;
    private final LocalDate dueDate;
    private LocalDate returnDate;

    Loan(Member member, BookItem item, int loanDurationDays) {
        this.loanId = UUID.randomUUID().toString();
        this.member = member;
        this.bookItem = item;
        this.issueDate = LocalDate.now();
        this.dueDate = issueDate.plusDays(loanDurationDays);
    }

    public boolean isOverdue() {
        return returnDate == null && LocalDate.now().isAfter(dueDate);
    }

    public long overdueDays() {
        return isOverdue() ? ChronoUnit.DAYS.between(dueDate, LocalDate.now()) : 0;
    }

    public void returnBook() { this.returnDate = LocalDate.now(); }
    public BookItem getBookItem() { return bookItem; }
}

// ====== Fine Strategy ======
interface FineCalculationStrategy {
    double calculate(Loan loan);
}

class DailyFineStrategy implements FineCalculationStrategy {
    private final double ratePerDay;
    DailyFineStrategy(double ratePerDay) { this.ratePerDay = ratePerDay; }

    @Override
    public double calculate(Loan loan) {
        return loan.overdueDays() * ratePerDay;
    }
}

// ====== Member ======
class Member {
    private final String memberId;
    private final String name;
    private final MemberType type;
    private final List<Loan> activeLoans = new ArrayList<>();
    private double fineBalance = 0;

    Member(String memberId, String name, MemberType type) {
        this.memberId = memberId;
        this.name = name;
        this.type = type;
    }

    public void addLoan(Loan loan) { activeLoans.add(loan); }
    public void addFine(double amount) { fineBalance += amount; }
    public double getFineBalance() { return fineBalance; }
    public int activeLoanCount() { return activeLoans.size(); }
    public MemberType getType() { return type; }
}

// ====== Library Service (Facade) ======
class LibraryService {
    private final Map<String, Book> catalog = new HashMap<>();
    private final Map<String, Member> members = new HashMap<>();
    private final FineCalculationStrategy fineStrategy;
    private final int maxLoansPerMember = 5;

    LibraryService(FineCalculationStrategy fineStrategy) {
        this.fineStrategy = fineStrategy;
    }

    public Loan checkOut(String memberId, String isbn) {
        Member member = members.get(memberId);
        Book book = catalog.get(isbn);

        if (member == null || book == null) throw new IllegalArgumentException("Invalid member or book");
        if (member.activeLoanCount() >= maxLoansPerMember) throw new IllegalStateException("Loan limit reached");
        if (member.getFineBalance() > 0) throw new IllegalStateException("Outstanding fines must be paid");

        BookItem item = book.getAvailableCopy()
            .orElseThrow(() -> new IllegalStateException("No copies available"));

        item.setStatus(BookStatus.LOANED);
        int days = member.getType() == MemberType.PREMIUM ? 21 : 14;
        Loan loan = new Loan(member, item, days);
        member.addLoan(loan);
        return loan;
    }

    public void returnBook(Loan loan) {
        loan.returnBook();
        loan.getBookItem().setStatus(BookStatus.AVAILABLE);
        double fine = fineStrategy.calculate(loan);
        if (fine > 0) loan.getBook(); // notify caller of fine
        // Notify reservation listeners here (Observer pattern)
    }

    public void addBook(Book book) { catalog.put(book.getIsbn(), book); }
    public void addMember(Member member) { members.put(member.memberId, member); }
}
```

---

## ⚠️ Common Mistakes
- Conflating `Book` (catalog entry) with `BookItem` (physical copy)
- Not using a Strategy for fine calculations — hardcoding rate makes it inflexible
- Missing the `Reservation` entity (what happens when all copies are checked out?)
- Not modeling the `Librarian` as a separate actor with different permissions

---

## 🔄 Follow-up Questions
1. **How would you add a digital e-book lending system?** (New `EBook` entity extending `Book`; `DigitalLoan` with concurrent user limits; NoCopyConstraint removed for digital.)
2. **How would you implement the reservation notification?** (Observer pattern: `Book.returnedObservers.notify()` → `ReservationService.onCopyAvailable()`.)
3. **How would you persist this to a relational DB?** (Tables: `books`, `book_items`, `members`, `loans`, `reservations`, `fines`. `loans` FK to `book_items` and `members`.)
