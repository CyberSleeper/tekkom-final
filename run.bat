@echo off
setlocal enabledelayedexpansion

REM
set "FILEPATH=%~1"

REM 
if exist "%FILEPATH%" (
    set "FILEPATH_DIR=%~dp1"
    set "FILENAME_WITHOUT_EXT=%~n1"
    
    REM 
    if "!FILEPATH_DIR:~-1!"=="\" set "FILEPATH_DIR=!FILEPATH_DIR:~0,-1!"
    
    java parser < "%FILEPATH%" > "!FILEPATH_DIR!\!FILENAME_WITHOUT_EXT!.obj"
    java Machine "!FILEPATH_DIR!\!FILENAME_WITHOUT_EXT!.obj"
) else (
    echo File '%FILEPATH%' does not exist.
)

endlocal