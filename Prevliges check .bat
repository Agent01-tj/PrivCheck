@echo off
setlocal enabledelayedexpansion

set "report=user_privileges.txt"
set "dangerous_privileges="
set "found=0"

echo Checking user privileges...
whoami /all > "%report%"

echo Analyzing privileges...
for %%P in (
    SeDebugPrivilege
    SeImpersonatePrivilege
    SeAssignPrimaryTokenPrivilege
    SeTakeOwnershipPrivilege
    SeBackupPrivilege
    SeRestorePrivilege
) do (
    findstr /I /C:"%%P" "%report%" >nul
    if !errorlevel! equ 0 (
        set "dangerous_privileges=!dangerous_privileges!%%P, "
        set /a found+=1
    )
)

echo.
if !found! gtr 0 (
    echo WARNING: Dangerous privileges found!
    echo ==================================
    echo Privileges: !dangerous_privileges:~0,-2!
    echo ==================================
    echo These privileges can be used for privilege escalation.
) else (
    echo Security status: no dangerous privileges found
)

echo.
echo Report saved to: %cd%\%report%
echo.
pause