@echo off
setlocal

title Manage time sync tasks
set "DEFAULT_TASK_NAME=CustomTimeSync"

:MAIN_LOOP
cls
echo ============================================
echo    Welcome in Manage Custom Time Sync Tasks
echo ============================================
echo  1. Create Task
echo  2. Run Task
echo  3. Enable Task
echo  4. Disable Task
echo  5. Delete Task
echo  6. Check Task Status (Query)
echo  7. Exit
echo.

set /p "CHOICE=Choose what you want to do (1-7): "

if "%CHOICE%"=="7" goto END
if "%CHOICE%"=="1" goto ADD_TASK
if "%CHOice%"=="2" goto RUN_TASK
if "%CHOICE%"=="3" goto ENABLE_TASK
if "%CHOICE%"=="4" goto DISABLE_TASK
if "%CHOICE%"=="5" goto DEL_TASK
if "%CHOICE%"=="6" goto QUERY_TASK

:: Invalid choice handling
echo.
echo [!] Invalid choice! Please enter a number from 1 to 7.
pause
goto MAIN_LOOP


:GET_TASK_NAME
echo.
set /p "TASK_NAME=Enter Task Name (Press Enter for default: %DEFAULT_TASK_NAME%): "
if "%TASK_NAME%"=="" set "TASK_NAME=%DEFAULT_TASK_NAME%"
exit /b


:ADD_TASK
echo.
echo Running add_task.bat...
call "%~dp0add_task.bat"
goto MAIN_LOOP


:RUN_TASK
call :GET_TASK_NAME
echo.
schtasks /run /tn "%TASK_NAME%"
pause
goto MAIN_LOOP


:ENABLE_TASK
call :GET_TASK_NAME
echo.
schtasks /change /tn "%TASK_NAME%" /enable
pause
goto MAIN_LOOP


:DISABLE_TASK
call :GET_TASK_NAME
echo.
schtasks /change /tn "%TASK_NAME%" /disable
pause
goto MAIN_LOOP


:DEL_TASK
call :GET_TASK_NAME
echo.
schtasks /delete /tn "%TASK_NAME%" /f
pause
goto MAIN_LOOP


:QUERY_TASK
call :GET_TASK_NAME
echo.
echo ============================================
schtasks /query /tn "%TASK_NAME%" /fo list /v
echo ============================================
pause
goto MAIN_LOOP


:END
endlocal
exit /b