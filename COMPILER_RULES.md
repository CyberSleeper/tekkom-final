# Compiler Construction Rules

This document outlines the semantic rules and code generation actions for the compiler project.

## Scope and Symbol Table Management

*   **C0 (Procedure Definition):** Revised rule. If a procedure or function (`proc`/`func`) is defined, push the current `orderNumber` onto the `orderNumberStack`.
*   **C0 (Scope Entry):** Enter a new scope.
*   **C3:** Verify that the `identifier` has not already been declared within the current scope. Insert the `identifier` into the symbol table. Push the index of the new symbol table entry onto the stack.
*   **C22:** Insert the `lexic level` and `orderNumber` into the symbol table.
*   **C24:** Insert the `procedure` into the symbol table.

## Code Generation (R-Rules)

*   **R1:** 
    *   Check that `lexic level < displaySize`.
    *   Generate an instruction to enter the scope statement.
    *   **Note:** This is the first instruction of a `PROC`.
    *   **Important:** The location of this instruction must be saved in the procedure's entry in the symbol table.
    *   **Reminder:** R1 is used in other contexts as well.
*   **R7:** Generate an instruction for a forward branch (`BR`). Note that this is **NOT** the first instruction of the `PROC`.
*   **R9:** Generate an instruction to patch/fix the address of a forward branch-2 (conditional forward branch).
*   **R42:** Generate an instruction to return from the procedure.
    *   **Note:** The return address is assumed to have been PUSHed onto the stack before this procedure was called.
