# Changelog - Compiler Project

## [Unreleased] - 2025-11-26

### Added
- **Rules Implemented**:
    - **C0 (Revised)**: `Context.java`. Pushes `orderNumber` to `orderNumberStack` upon entering a new scope (procedure definition logic).
    - **C2 (Revised)**: `Context.java`. Pops `orderNumber` from `orderNumberStack` upon exiting a scope.
    - **C22**: `Context.java`, `Parser.cup`. Sets Lexical Level and Order Number for a procedure identifier.
    - **C24**: `Context.java`, `Parser.cup`. Sets symbol Kind to `PROCEDURE` (ID Kind 2).
    - **R1 (Revised)**: `Generate.java`. Saves the address of the procedure's entry point (first instruction) to its symbol table entry.
    - **R42**: `Generate.java`. Generates a `BR` instruction for returning from a procedure (assumes return address is on stack).

- **Classes/Files**:
    - `Bucket.java`: Added `private int address` field with getter/setter to store procedure entry points.
    - `Context.java`: Added `orderNumberStack` to manage nested scope order numbers.

### Modified
- `Parser.cup`:
    - Updated `PROC` declaration rule to include `C24` and `C22` actions.
    - Added definition of `C22` and `C24` non-terminals.
- `Context.java`:
    - Updated `C(0)` and `C(2)` for stack management.
    - Added `C(22)` and `C(24)` implementations.
- `Generate.java`:
    - Updated `R(1)` to save procedure address.
    - Added `R(42)` implementation.
