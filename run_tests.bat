@echo off
setlocal enabledelayedexpansion

set "TEST_DIR=tests"
set "PASS_COUNT=0"
set "FAIL_COUNT=0"

echo Running tests in %TEST_DIR%...
echo.

if not exist "%TEST_DIR%" (
    echo Error: Directory "%TEST_DIR%" not found.
    exit /b 1
)

for %%f in ("%TEST_DIR%\*.tk") do (
    set "FILENAME=%%~nf"
    set "FILEPATH=%%f"
    set "OBJPATH=%TEST_DIR%\!FILENAME!.obj"
    
    echo [TEST] !FILENAME!
    
    REM Run Parser
    cmd /c "java parser < "!FILEPATH!" > "!OBJPATH!""
    if !errorlevel! neq 0 (
        echo   [FAIL] Parser error
        set /a FAIL_COUNT+=1
    ) else (
        REM Run Machine
        java Machine "!OBJPATH!" > nul
        if !errorlevel! neq 0 (
            echo   [FAIL] Runtime error
            set /a FAIL_COUNT+=1
        ) else (
            echo   [PASS]
            set /a PASS_COUNT+=1
        )
    )
    echo.
)

echo.
echo ========================================
echo Test Summary
echo ========================================
echo Passed: %PASS_COUNT%
echo Failed: %FAIL_COUNT%
echo.

if %FAIL_COUNT% gtr 0 (
    exit /b 1
) else (
    exit /b 0
)
