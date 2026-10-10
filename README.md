# Windows Time Sync & Management Project

A robust utility suite built with **Windows Batch (.bat)** and **VBScript (.vbs)** designed to accurately fetch, synchronize, and manage system time using online time APIs. Specially optimized for older Windows systems (such as Windows 7) where native time synchronization services might fail or need custom automation.

---

## 📂 Project Structure & Files Overview

### 1. `fix_time.bat` (The Core Engine)
- **Role:** The core script responsible for updating and setting the system's date and time.
- **Mechanism:** It connects to an online time API (`https://timeapi.io/api/time/current/zone?timeZone=Africa/Cairo`) to fetch precise, zone-specific time data.
- **Dependencies:** Requires `curl.exe` to execute network requests. By default, it looks for `curl` inside the Git installation path, so make sure to update the path if your environment differs.
- **Error Handling Codes (via VBScript integration):**
  * `10001`: `curl.exe was not found at the specified path.`
  * `10002`: `Could not fetch time. Check your internet connection.`
  * `10003`: `Could not parse date from API response.`
  * `10004`: `Failed to set system Date. Please Run as Administrator.`
  * `10005`: `Failed to set system Time. Please Run as Administrator.`

---

### 2. `main.vbs` (The Orchestrator)
- **Role:** The primary manager script that controls, executes, and handles `fix_time.bat`.
- **Arguments Supported:**
  * `silent` or `s`: Runs in silent mode (suppresses error dialogs/popups while still returning the correct error code).
  * `ignore-net-error` or `i`: Ignores network-related failures (ideal for devices that are not constantly connected to the internet). Returns exit code `0` when triggered.
  * `delay` (e.g., `/delay:10`): Introduces a custom waiting period in seconds before executing `fix_time.bat`. If the script lacks administrator privileges, it will prompt the user before starting the countdown.

---

### 3. `add_task.bat` (Task Scheduler Automator)
- **Role:** Automates the creation of a Windows Task Scheduler entry to run the time synchronization script seamlessly at system startup/logon.
- **Arguments:** 
  * Use `/defaults` or `-y` to automatically bypass prompts and apply default configurations.
- **Interactive Prompts:**
  1. **Task Name:** Defaults to `CustomTimeSync`.
  2. **Delay Time:** The preferred delay duration before execution.
- **Under the Hood:** Leverages Windows native `schtasks` utility:
  ```cmd
  schtasks /create /tn "%TASK_NAME%" /tr "wscript.exe "%SCRIPT_PATH%" /delay:%INPUT_DELAY%" /sc ONLOGON /rl HIGHEST /f```

---

### 4. `manage_task.bat` (Task Management Utility)

- **Role:** A comprehensive management tool designed to handle background tasks effortlessly.
- **Supported Operations:** Create, run, enable, disable, delete, and query tasks.
- **Privilege Requirements:**
- Administrative privileges are **mandatory** for creating, deleting, and modifying states (such as enabling or disabling tasks).



---

## 🚀 Usage Guide

1. Ensure `curl.exe` path inside the script matches your system setup (typically mapped from your Git directory).
2. Run `fix_time.bat` manually with **Administrator privileges** to test synchronization.
3. Use `add_task.bat` to schedule it automatically on logon.
4. Use `manage_task.bat` whenever you need to check, run, or alter the scheduled synchronization tasks.