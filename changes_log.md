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

# Changelog

## [Fixed] Function Parameter Passing - December 10, 2025

### Issue Description
Functions with parameters were not receiving correct argument values. For example, `funcWithParam(20)` was returning 10 instead of the expected 30 (20 + 10).

### Root Cause
The parameter offset in `Context.java` case 25 was incorrect. The offset determines where in the stack frame function parameters are located relative to the display pointer.

### Changes Made

#### 1. Fixed Parameter Offset in Context.java
**File:** `Context.java`  
**Location:** Case 25 (line ~290)  
**Change:** Modified parameter order number calculation

```java
// Before:
symbolHash.find(currentStr).setOrderNum(-3-orderNumber);

// After:
symbolHash.find(currentStr).setOrderNum(-4-orderNumber);
```

**Reason:** The stack frame analysis showed that function arguments are stored 4 positions back from the display pointer after the function call sequence:
1. Argument pushed (e.g., 25)
2. Return address pushed
3. Function address pushed
4. BR instruction jumps to function
5. Function pushes return value placeholder (-32768)
6. PUSHMT pushes current stack top
7. SETD sets display to point to stack top

#### 2. Simplified Function Call Cleanup in Generate.java
**File:** `Generate.java`  
**Location:** Case 47 (R47 - Function call instruction)  
**Change:** Reverted to simpler function call mechanism

```java
// Removed complex return value handling that was causing illegal operation codes
// Kept basic function call structure:
// - PUSH return address
// - PUSH function address  
// - BR (branch to function)
```

**Reason:** Previous modifications added too many instructions (11 instead of 5), causing memory address misalignment and illegal operation code errors.

### Technical Details

**Stack Frame Layout During Function Call:**
```
Stack (bottom to top):
[...previous content...]
[argument value]      <- -4 offset from display
[return address]      <- -3 offset from display  
[function address]    <- -2 offset from display
[return placeholder]  <- -1 offset from display
[current mt]          <- 0 offset (display points here)
```

**Function Call Sequence:**
1. Caller pushes argument onto stack
2. R47 generates function call instructions
3. Function entry (R1) sets up new scope
4. Parameter access uses -4 offset to reach argument
5. Function executes and returns value

### Files Modified
- `Context.java` - Fixed parameter offset calculation
- `Generate.java` - Simplified function call mechanism

### Validation
The fix was validated through iterative testing with different parameter offset values (-5, -4, -3, -2, -1, 0, 1) until the correct offset (-4) was identified that allows parameters to access the pushed arguments correctly.