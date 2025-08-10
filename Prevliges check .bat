@echo off
setlocal enabledelayedexpansion

:: Configuration
set "report=user_privileges_%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%.txt"
set /a found=0
set "dangerous_list="
set "privilege_desc="

:: Admin check
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Script not running as administrator
    echo Some privileges might not be visible
    echo.
)

echo Checking user privileges...
whoami /priv > "%report%"

echo Analyzing dangerous privileges...
echo -------------------------------

:: Dangerous privilege list with descriptions
set "privileges=SeDebugPrivilege SeImpersonatePrivilege SeAssignPrimaryTokenPrivilege SeTakeOwnershipPrivilege SeBackupPrivilege SeRestorePrivilege"

for %%P in (%privileges%) do (
    findstr /I /C:"%%P" "%report%" | findstr /I "Enabled" > nul
    
    if !errorlevel! equ 0 (
        set /a found+=1
        set "dangerous_list=!dangerous_list!%%P, "
        
        :: Add descriptions
        if "%%P"=="SeDebugPrivilege" set "privilege_desc=!privilege_desc!  [DEBUG]    Debug programs (access any process memory)^!"
        if "%%P"=="SeImpersonatePrivilege" set "privilege_desc=!privilege_desc!  [IMPERSON] Impersonate other accounts^!"
        if "%%P"=="SeAssignPrimaryTokenPrivilege" set "privilege_desc=!privilege_desc!  [TOKEN]    Replace process level token^!"
        if "%%P"=="SeTakeOwnershipPrivilege" set "privilege_desc=!privilege_desc!  [OWNER]    Take ownership of system objects^!"
        if "%%P"=="SeBackupPrivilege" set "privilege_desc=!privilege_desc!  [BACKUP]   Bypass file ACLs for reading^!"
        if "%%P"=="SeRestorePrivilege" set "privilege_desc=!privilege_desc!  [RESTORE]  Bypass file ACLs for writing^!"
    )
)

echo.
if %found% gtr 0 (
    echo [!!!] DANGEROUS PRIVILEGES DETECTED [!!!]
    echo ========================================
    echo Privileges: %dangerous_list:~0,-2%
    echo.
    echo Risk Level: 
    if %found% gtr 3 (echo HIGH (critical exposure)) else if %found% gtr 1 (echo MEDIUM) else echo LOW
    echo.
    echo Privilege Details:
    for /f "tokens=1* delims=!" %%a in ("!privilege_desc!") do echo %%a
    echo ========================================
    echo Mitigation Advice:
    echo 1. Remove unnecessary privileges via secpol.msc
    echo 2. Follow least-privilege principle
    echo 3. Audit service accounts regularly
) else (
    echo [✓] Security Status: No dangerous privileges found
)

echo.
echo Report Information:
echo - Report Path:   %cd%\%report%
echo - Audit Time:    %date% %time:~0,8%
echo - User:          %USERNAME%@%COMPUTERNAME%
echo.
echo Press any key to exit...
pause > nul