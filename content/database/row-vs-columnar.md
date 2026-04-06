---
author: "sagar ved"
title: "Databases: Columnar vs. Row Storage"
date: 2024-04-04
draft: false
weight: 8
---

# 🧩 Question: Explain the difference between Row-based (OLTP) and Column-based (OLAP) storage. When should you use each?

## 🎯 What the interviewer is testing
- Transactional vs Analytical workload understanding.
- Physical storage layout and I/O efficiency.
- Data compression techniques.

---

## 🧠 Deep Explanation

### 1. Row Storage (e.g., MySQL, Postgres):
- Data is stored on disk row-by-row: `R1(id, name, age), R2(id, name, age)`.
- **Strength**: High-frequency **Writes/Updates**. One disk seek to read a whole record.
- **Weakness**: Aggregations (`SELECT AVG(age)`) require reading the whole row even if only one column is needed.

### 2. Columnar Storage (e.g., ClickHouse, Redshift, Parquet):
- Data is stored column-by-column: `(id1, id2), (name1, name2), (age1, age2)`.
- **Strength**: **Analytical Queries**. To calculate `AVG(age)`, we only read the `age` column data.
- **Compression**: Since a column has the same data type, we can use efficient compression (Run-length encoding, Delta encoding).
- **Weakness**: Writing a single row requires multiple disk seeks (one for each column).

---

## ✅ Ideal Answer
Row-based storage is optimized for OLTP (Online Transactional Processing), where operations involve small, frequent writes of full records. Columnar storage is optimized for OLAP (Online Analytical Processing), where we often aggregate specific columns across millions of rows and need high compression.

---

## 🏗️ Use Case Table:
| Feature | Row Storage (OLTP) | Columnar Storage (OLAP) |
|---|---|---|
| Workload | CRUD, many small transactions | Reporting, Large-scale analysis |
| Reads | Fetch specific rows | Aggregations over columns |
| Writes | Very Fast | Batch writes preferred |
| Compression | Moderate | Very High |

---

## 🔄 Follow-up Questions
1. **What is Apache Parquet?** (A popular columnar storage file format in the Big Data ecosystem.)
2. **What is a star schema?** (A denormalized DB design common in OLAP.)
3. **Can Postgres do columnar?** (Using extensions like `citus` or `zombodb`, or specific storage layouts.)
