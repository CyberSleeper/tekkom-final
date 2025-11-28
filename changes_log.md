# Changes Log - Function and Procedure Implementation

## Overview
This document details the changes made to the compiler to support functions and procedures with parameters, based on the provided reference "Laporan PR 4 Kelompok 1.pdf".

## Files Modified

### 1. Bucket.java
- **Added `params` field:** To store the number of parameters for functions and procedures.
- **Added `setParams(int)` and `getParams()` methods:** Accessors for the new field.
- **Updated Constructor:** Initialized `params` to 0.

### 2. Hash.java
- **Updated `print` method:** Now prints `Address` and `Params` for each symbol in the symbol table dump.

### 3. Context.java
- **Added `argumentStack`:** To track the number of arguments/parameters during parsing.
- **Updated/Added `C` (Context Check) Rules:**
    - `C22`: Updated to increment `orderNumber`.
    - `C23`: Pushes copy of type to stack.
    - `C25`: Sets ID kind to SCALAR and sets order number for parameters (using `-6 - orderNumber`).
    - `C26`: Sets ID kind to FUNCTION.
    - `C27`: Calls `C(2)` (Exit scope).
    - `C30`: Pushes 0 to `argumentStack`.
    - `C32`: Verifies argument count matches parameter count.
    - `C33`: Checks if identifier is a valid function/array.
    - `C34`: Increments argument count.
    - `C35`: Sets parameter count in symbol table.
    - `C36`: Checks for type mismatch (Return type check).
    - `C37`: Checks context for function vs scalar (calls C33 or C20).
    - `C40`: Added as placeholder (empty).

### 4. Generate.java
- **Added `setAddress()` method:** Sets the address of the function/procedure if not already set.
- **Updated `R1` and `R2`:** Call `setAddress()` when entering scope.
- **Implemented/Updated `R` Rules (R42-R50):**
    - `R42`: Return (Branch).
    - `R43`: FLIP instruction.
    - `R44`: Procedure call (pushes return addr, pushes proc addr, branches).
    - `R45`: Push procedure address to `callStack`.
    - `R46`: Generic prepare call (pushes return address placeholder, pushes function/proc address to `callStack`). Note: Used in place of PDF's empty R46 for robustness.
    - `R47`: Function/Procedure call with args. Pops address from `callStack`, branches, and backpatches return address from `returnAddrStack`. Also includes cleanup code (FLIP, PUSHMT, SUB, STORE, POP).
    - `R48`: Argument passing logic (FLIP, PUSHMT, SUB, STORE).
    - `R49`: Function address load or prepare call (Context sensitive).
    - `R50`: Function call (BR) or Variable load.

### 5. Parser.cup
- **Updated Non-terminals:** Added `C23`, `C25`-`C37`, `C40`.
- **Added Action Definitions:** Linked C rules to `parser.context.C()`.
- **Updated Grammar Rules:**
    - `assignOrCall`: Supports procedure calls with parameters using `R46` and `R47`.
    - `subsOrCall`: Supports function calls with parameters.
    - `declaration`: Supports `FUNC` and `PROC` with new context rules.
    - `funcBody`: Supports parameters.
    - `procBody`: Supports parameters. Reinstated `R5` (Exit Scope) in first alternative which was missing in PDF reference.
    - `parameters` & `moreParameters`: Added context rules for parameter handling.
    - `arguments` & `moreArguments`: Added rules for argument passing.

## Key Decisions and Deviations
- **R46 Implementation:** The PDF described `R46` as empty (`break;`), but `R47` relied on `returnAddrStack` being populated. I implemented `R46` to push a return address placeholder to `returnAddrStack` and the function address to `callStack`, ensuring `R47` operates correctly.
- **R5 in procBody:** The PDF omitted `R5` (Exit Scope) in the first alternative of `procBody`. I included it to ensure proper scope management (resetting display).
- **R45 vs R46:** I updated `assignOrCall` (procedure call with args) to use `R46` instead of `R45` because `R45` does not push the return address placeholder required by `R47`.
- **C40:** Defined as empty action as its logic wasn't explicitly detailed but it is used in the grammar.

