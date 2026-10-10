Option Explicit

Dim intReturn, errorMsgs, msgText
Dim fso, WshShell, oShell
Dim argsNamed, scriptDir, batPath
Dim bSilent, bIgnoreNet, iDelay


Set WshShell = CreateObject("WScript.Shell")
Set oShell = CreateObject("Shell.Application")

Set fso = CreateObject("Scripting.FileSystemObject")
scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)

batPath = fso.BuildPath(scriptDir, "fix_time.bat")

Set argsNamed = WScript.Arguments.Named

Function HasArgs(arr)
    Dim alias
    HasArgs = False

    For Each alias in arr
        If argsNamed.Exists(alias) Then
            HasArgs = True
            Exit Function
        End If
    Next
End Function

Function GetRawArgs()
    Dim arg, sArgs

    sArgs = ""

    For Each arg in WScript.Arguments
        If InStr(arg, " ") > 0 Then
            arg = """" & arg & """"
        End If

        sArgs = sArgs & " " & arg
    Next

    GetRawArgs = sArgs
End Function

Function IsAdmin()
    Dim exitCode

    ' try using net session
    exitCode = WshShell.Run("cmd /c net session >nul 2>&1", 0, True)
    IsAdmin = (exitCode = 0)
End Function

' Ensure that file runs as admin, and if not, ask through UAC
If Not IsAdmin() Then
    ' rerun and ask for admin
    oShell.ShellExecute "wscript.exe", "//nologo """ & WScript.ScriptFullName & """" & GetRawArgs(), scriptDir, "runas", 0
    WScript.Quit 0
End If


' Get args
bSilent = HasArgs(Array("silent", "s"))
bIgnoreNet = HasArgs(Array("ignore-net-error", "i"))

' Get iDelay and assign it to 0 if it's empty, and convert to integer safely
iDelay = WScript.Arguments.Named("delay")
If iDelay = "" Then
    iDelay = 0
Else
    iDelay = CInt(iDelay)
End If

' Wait delay time (Corrected comment and safe multiplication)
WScript.Sleep iDelay * 1000

' Run batch file without window (0) and wait code to end (True)
intReturn = WshShell.Run("cmd /c """ & batPath & """", 0, True)

If intReturn = 0 Or (intReturn = 10002 And bIgnoreNet) Then
    WScript.Quit 0
End If

' Create a Dictionary map for custom error messages
Set errorMsgs = CreateObject("Scripting.Dictionary")

errorMsgs.Add 10001, "curl.exe was not found at the specified path."
errorMsgs.Add 10002, "Could not fetch time. Check your internet connection."
errorMsgs.Add 10003, "Could not parse date from API response."
errorMsgs.Add 10004, "Failed to set system Date. Please Run as Administrator."
errorMsgs.Add 10005, "Failed to set system Time. Please Run as Administrator."

' Retrieve msg from Map or set a fallback default
If errorMsgs.Exists(intReturn) Then
    msgText = errorMsgs.Item(intReturn)
Else
    msgText = "An unknown error occurred."
End If

If intReturn <> 0 And Not bSilent Then
    ' 4096 means always on top
    MsgBox "Error [" & intReturn & "]: " & msgText, 16 + 4095, "Time Sync Failed"
End If

WScript.Quit intReturn