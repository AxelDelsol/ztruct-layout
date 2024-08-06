# ztruct-layout

Project to find the best struct order to minimize memory.

In Zig (and other programming languages), every data type has a known size and natural alignment:

* The size corresponds to the number of bytes required to store a value of that type.
* Most variables we use live in the RAM where each "slot" is given a number: its address. The natural alignment imposes that the address of an object of that data type to be a multiple of the alignment.

Note: the size is always a multiple of the alignment.

Example: a `u16` variable in Zig has a size and an alignment of 2. That means the variable will use 2 bytes of memory and its address can only be on an even address.

---

What about structs ? 

The aligment of a struct is the aligment of the bigger field. The size of the struct is computed based on the size and alignment of each field.

Examples: let's try to find the size and aligment of the following structs using the table provided below

| **Type** | **Size** | **Natural alignment** |
|----------|----------|-----------------------|
| i32      | 4        | 4                     |
| f64      | 8        | 8                     |
| u8       | 1        | 1                     |

Example 1: What is the size of alignment of the following struct ?

```rs
const Test = struct { a: i32, b: f64, c: i32 };
```

| **Field** | **Size** | **Alignment** | **Starting address** | **Padding required for the next field** | **Total** |
|---|---|---|---|---|---|
| a | 4 | 4 | 0 | 4 |  |
| b | 8 | **_8_** | 8 | 0 |  |
| c | 4 | 4 | 16 | 4 | **_24_** |

The alignment is `8` (alignment of field `b`) and the total size is `24`.

Notes: 
* Field `b` is `8` because field `b` has an alignment of `8`
* The total size of the struct is `24` because the size must be a multiple of the alignment

Example 2: What is the size of alignment of the following struct ?

```rs
const Test = struct { a: i32, c: i32, b: f64 };
```

| **Field** | **Size** | **Alignment** | **Starting address** | **Padding required for the next field** | **Total (padding included)** |
|---|---|---|---|---|---|
| a | 4 | 4 | 0 | 0 |  |
| c | 4 | 4 | 4 | 0 |  |
| b | 8 | 8 | 8 | 0 | 16 |

Reordering the struct allows us to save 8 bytes. Some compilers (like zig) can optimize the memory layout of a struct and ignore the field order.

## Step 0 - Motivation

As one can see, finding the memory layout that minimizes the size of a struct is not trivial. The goal of this project is to find the best layout for a given list of fields.

We can see this as a combinatorial optimization problem and apply various optimization techniques.

## Step 1 - Finding a feasible solution

This steps will use the same algorithm as the one used in the example: take each field in order and assign them an address.

Expected result:

* Define how to use the executable
* Parse a problem file
* Output a feasible solution