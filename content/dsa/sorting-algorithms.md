---
title: "Sorting Algorithms Internals and Merge Sort"
date: 2024-04-04
draft: false
weight: 9
---

# 🧩 Question: Java's `Arrays.sort()` uses different algorithms for different types. Explain why. Implement merge sort. What are the real-world applications of merge sort beyond simple sorting?

## 🎯 What the interviewer is testing
- Comparison-based sorting bounds: O(n log n)
- Merge sort: stable, O(n log n), divide-and-conquer
- QuickSort vs Merge Sort trade-offs
- Real applications: external sort, inversion count, count smaller numbers

---

## 🧠 Deep Explanation

### 1. Java's Dual-Pivot QuickSort vs TimSort

`Arrays.sort(int[])` — uses **Dual-Pivot QuickSort**:
- In-place, O(n log n) average, O(n²) worst (randomized in practice)
- Not stable — object identity may not be preserved for equal elements
- Optimal for **primitive arrays** (no object overhead)

`Arrays.sort(Object[])` — uses **TimSort**:
- Merge sort + insertion sort hybrid
- Stable (equal elements maintain relative order)
- Exploits existing sorted "runs" in real-world data → often O(n)
- Required for object arrays because stability matters for Comparator chains

### 2. Merge Sort Internals

**Divide**: Split array in half recursively until size 1.
**Merge**: Merge two sorted halves by comparing elements.

**Recurrence**: T(n) = 2T(n/2) + O(n) → **O(n log n)** by Master Theorem.

**Space**: O(n) auxiliary for the merge step. NOT in-place.

### 3. Inversion Count (Merge Sort application)

An inversion is a pair `(i, j)` where `i < j` but `arr[i] > arr[j]`.
Inversion count = how "unsorted" an array is → modified merge sort counts inversions during merge.

### 4. External Sort (Disk-based Merge Sort)

For sorting files too large for RAM (e.g., sorting 1TB of logs):
1. Read chunks that fit in RAM, sort them, write back as "runs".
2. K-way merge the runs using a Min-Heap.

---

## ✅ Ideal Answer

- `Arrays.sort(int[])` = Dual-Pivot QuickSort (fast, in-place, not stable).
- `Arrays.sort(Object[])` = TimSort (stable, exploits natural runs).
- Merge sort: stable, O(n log n) guaranteed (no worst case unlike QuickSort), O(n) space.
- Real applications: external sort, inversion count, merge in linked lists, count smaller numbers.

---

## 💻 Java Code

```java
public class SortingAlgorithms {

    // 1. Merge Sort — O(n log n) time, O(n) space
    public void mergeSort(int[] arr, int left, int right) {
        if (left >= right) return; // Base case
        int mid = left + (right - left) / 2;
        mergeSort(arr, left, mid);       // Sort left half
        mergeSort(arr, mid + 1, right);  // Sort right half
        merge(arr, left, mid, right);    // Merge
    }

    private void merge(int[] arr, int left, int mid, int right) {
        // Copy to temporary arrays (can also use one temp array for less allocation)
        int[] L = java.util.Arrays.copyOfRange(arr, left, mid + 1);
        int[] R = java.util.Arrays.copyOfRange(arr, mid + 1, right + 1);

        int i = 0, j = 0, k = left;
        while (i < L.length && j < R.length) {
            if (L[i] <= R[j]) arr[k++] = L[i++]; // ≤ ensures stability
            else arr[k++] = R[j++];
        }
        while (i < L.length) arr[k++] = L[i++];
        while (j < R.length) arr[k++] = R[j++];
    }

    // 2. Count Inversions (Merge Sort variant)
    // Inversion: i < j but arr[i] > arr[j]
    // O(n log n) — much better than O(n²) brute force
    public long countInversions(int[] arr) {
        return mergeCount(arr, 0, arr.length - 1);
    }

    private long mergeCount(int[] arr, int left, int right) {
        if (left >= right) return 0;
        int mid = left + (right - left) / 2;
        long count = mergeCount(arr, left, mid)
                   + mergeCount(arr, mid + 1, right);
        count += mergeAndCount(arr, left, mid, right);
        return count;
    }

    private long mergeAndCount(int[] arr, int left, int mid, int right) {
        int[] L = java.util.Arrays.copyOfRange(arr, left, mid + 1);
        int[] R = java.util.Arrays.copyOfRange(arr, mid + 1, right + 1);
        int i = 0, j = 0, k = left;
        long inversions = 0;

        while (i < L.length && j < R.length) {
            if (L[i] <= R[j]) {
                arr[k++] = L[i++];
            } else {
                // L[i] > R[j]: All remaining elements in L (from i to end) form inversions with R[j]
                inversions += (L.length - i);
                arr[k++] = R[j++];
            }
        }
        while (i < L.length) arr[k++] = L[i++];
        while (j < R.length) arr[k++] = R[j++];
        return inversions;
    }

    // 3. QuickSort — O(n log n) average, O(n²) worst, in-place, NOT stable
    public void quickSort(int[] arr, int left, int right) {
        if (left < right) {
            int pivotIdx = partition(arr, left, right);
            quickSort(arr, left, pivotIdx - 1);
            quickSort(arr, pivotIdx + 1, right);
        }
    }

    private int partition(int[] arr, int left, int right) {
        // Use median-of-three to reduce worst-case probability
        int mid = left + (right - left) / 2;
        if (arr[left] > arr[mid]) swap(arr, left, mid);
        if (arr[left] > arr[right]) swap(arr, left, right);
        if (arr[mid] > arr[right]) swap(arr, mid, right);
        // arr[mid] is median — use as pivot
        swap(arr, mid, right - 1);
        int pivot = arr[right - 1];

        int i = left, j = right - 1;
        while (i < j) {
            while (arr[++i] < pivot);
            while (arr[--j] > pivot);
            if (i < j) swap(arr, i, j);
        }
        swap(arr, i, right - 1);
        return i;
    }

    private void swap(int[] arr, int i, int j) {
        int tmp = arr[i]; arr[i] = arr[j]; arr[j] = tmp;
    }
}
```

---

## ⚠️ Common Mistakes
- Using `left + right / 2` for mid instead of `left + (right - left) / 2` — integer overflow
- Not maintaining stability in merge (using `<` instead of `<=` in merge comparison)
- Allocating new arrays in every merge call at scale (use a single scratch array for all merges)
- Forgetting QuickSort is not stable — don't use it when relative order of equal elements matters

---

## 🔄 Follow-up Questions
1. **What is the best-case for Merge Sort? Does it improve with nearly-sorted input?** (O(n log n) even best-case; no. TimSort DOES: it detects existing sorted runs and skips merging them.)
2. **How would you sort 1 billion integers that don't fit in RAM?** (External sort: sort N/M chunks of size M in RAM, write M sorted files, K-way merge them using Min-Heap.)
3. **Why is Counting Sort O(n) and not comparable to merge/quick sort?** (Not comparison-based. Exploits the fact that elements are integers in range [0, k]; O(n+k). Inapplicable for arbitrary objects.)
