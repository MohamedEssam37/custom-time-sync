@echo off
setlocal

title add time sync task when login

:: get vbs file path
set "SCRIPT_PATH=%~dp0main.vbs"

:: Set defaults
set "DEFAULT_TASK_NAME=CustomTimeSync"
set "DEFAULT_DELAY=20"

:: check if -y or /defaults args passed in call
if /i "%~1"=="/defaults" (
    call :set_defaults
    goto MAKE_TASK
) else if /i "%~1"=="-y" (
    call :set_defaults
    goto MAKE_TASK
)

:: Get task name and set to default if user press enter
set /p "TASK_NAME=Enter Task Name (Press Enter for default: "%DEFAULT_TASK_NAME%"): "
if "%TASK_NAME%"=="" set "TASK_NAME=%DEFAULT_TASK_NAME%"

:: Get delay secs

:PROMPT_DELAY
set /p "INPUT_DELAY=Enter delay secs (Press Enter for default: "%DEFAULT_DELAY%"): "
if "%INPUT_DELAY%"=="" set "INPUT_DELAY=%DEFAULT_DELAY%"

:: check if INPUT_DELAY is nums only
echo %INPUT_DELAY%| findstr /r "[^0-9]" >nul 2>&1
if %errorlevel% equ 0 goto PROMPT_DELAY

:: del 0s in the start
for /f "tokens=* delims=0" %%A in ("%INPUT_DELAY%") do set "INPUT_DELAY=%%A"

:: if it == "" set it to 0
if "%INPUT_DELAY%"=="" set "INPUT_DELAY=0"


:: make the task
:MAKE_TASK

schtasks /create /tn "%TASK_NAME%" /tr "wscript.exe \"%SCRIPT_PATH%\" /delay:%INPUT_DELAY%" /sc ONLOGON /rl HIGHEST /f

pause
endlocal
exit /b 0

:set_defaults
set "TASK_NAME=%DEFAULT_TASK_NAME%"
set "INPUT_DELAY=%DEFAULT_DELAY%"
