@echo off
setlocal EnableDelayedExpansion

:: store curl path at var
set "CURL=C:\PROGRA~1\Git\mingw32\bin\curl.exe"

if not exist "%CURL%" exit /b 10001

:: Fetch JSON date & time from TimeAPI.io
for /f "tokens=2,3 delims=T" %%A in ('%CURL% -k -s "https://timeapi.io/api/time/current/zone?timeZone=Africa/Cairo" ^| findstr /R "dateTime"') do (
    set "FULL_A=%%A"
    set "RAW_DATE=!FULL_A:~-10!"
    
    set "FULL_B=%%B"
    set "RAW_TIME=!FULL_B:~0,11!"
)

:: safe conds to check if all ok

:: check RAW_TIME defined
if not defined RAW_TIME exit /b 10002

:: check RAW_DATE defined
if not defined RAW_DATE exit /b 10003

:: Reformat YYYY-MM-DD to MM-DD-YYYY directly in one line
set "SYS_DATE=%RAW_DATE:~5,2%-%RAW_DATE:~8,2%-%RAW_DATE:~0,4%"

:: apply date and check if there are errors

echo.| date %SYS_DATE% >nul 2>&1
if %ERRORLEVEL% NEQ 0 exit /b 10004

echo.| time %RAW_TIME% >nul 2>&1
if %ERRORLEVEL% NEQ 0 exit /b 10005
