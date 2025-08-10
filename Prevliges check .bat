@echo off
chcp 65001 > nul
color 5f

REM ===================================================================================
REM
REM J. Abubakr | github.com: juraev.exe | @azmsec: Secure System Administration Course 
REM 
REM ===================================================================================
REM Windows Privilege Auditor 
REM Purpose: Identifies dangerous privileges that could lead to privilege escalation
REM Usage: Run as administrator for full system visibility
REM ===================================================================================
setlocal enabledelayedexpansion

:: *********************** CONFIGURATION SECTION ***********************
:: Report filename format: user_privileges_YYYYMMDD_HHMM.txt
set "report=user_privileges_%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%.txt"

:: Initialize counters and lists
set /a found=0                  & REM Tracks number of dangerous privileges found
set "dangerous_list="           & REM Comma-separated list of dangerous privileges
set "privilege_desc="           & REM Contains formatted descriptions of found privileges

:: *********************** ADMIN CHECK ***********************
:: Verify script execution context - warns if not running elevated
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [WARNING] Script not running as administrator
    echo   - Some privileges might not be visible
    echo   - Run script from elevated command prompt for full audit
    echo.
)

:: *********************** PRIVILEGE COLLECTION ***********************
echo Collecting privilege data...
echo   Command: whoami /priv
whoami /priv > "%report%"
echo   Report saved to: %cd%\%report%
echo.

:: *********************** PRIVILEGE ANALYSIS ***********************
echo Scanning for high-risk privileges...
echo -----------------------------------

:: Define target privileges with internal identifiers
set "privileges=SeDebugPrivilege SeImpersonatePrivilege SeAssignPrimaryTokenPrivilege SeTakeOwnershipPrivilege SeBackupPrivilege SeRestorePrivilege"

:: Loop through each privilege and check status
for %%P in (%privileges%) do (
    REM Check if privilege exists AND is enabled in report
    findstr /I /C:"%%P" "%report%" | findstr /I "Enabled" > nul
    
    if !errorlevel! equ 0 (
        REM Update counters and lists when dangerous privilege found
        set /a found+=1
        set "dangerous_list=!dangerous_list!%%P, "
        
        REM Add human-readable descriptions with impact assessment
        if "%%P"=="SeDebugPrivilege" set "privilege_desc=!privilege_desc!  [DEBUG]    Debug programs (Memory access)^!"
        if "%%P"=="SeImpersonatePrivilege" set "privilege_desc=!privilege_desc!  [IMPERSON] Impersonate security contexts^!"
        if "%%P"=="SeAssignPrimaryTokenPrivilege" set "privilege_desc=!privilege_desc!  [TOKEN]    Replace process tokens^!"
        if "%%P"=="SeTakeOwnershipPrivilege" set "privilege_desc=!privilege_desc!  [OWNER]    Take object ownership^!"
        if "%%P"=="SeBackupPrivilege" set "privilege_desc=!privilege_desc!  [BACKUP]   Read bypassing ACLs^!"
        if "%%P"=="SeRestorePrivilege" set "privilege_desc=!privilege_desc!  [RESTORE]  Write bypassing ACLs^!"
    )
)

:: *********************** RISK ASSESSMENT ***********************
echo.
if %found% gtr 0 (
    REM Build risk assessment message
    set "risk_level=LOW"
    if %found% gtr 1 set "risk_level=MEDIUM"
    if %found% gtr 3 set "risk_level=HIGH (CRITICAL)"
    
    REM Privilege detection header
    echo [!!!] SECURITY ALERT: %found% DANGEROUS PRIVILEGES FOUND [!!!]
    echo =============================================================
    echo Privileges: %dangerous_list:~0,-2%
    echo.
    echo Threat Level: %risk_level%
    echo.
    echo Security Impact:
    for /f "tokens=1* delims=!" %%a in ("!privilege_desc!") do echo %%a
    echo =============================================================
    
    REM Mitigation recommendations
    echo Remediation Steps:
    echo  1. Open Local Security Policy (secpol.msc)
    echo  2. Navigate to: Security Settings > Local Policies > User Rights Assignment
    echo  3. Remove unnecessary accounts from these privileges:
    echo     - %dangerous_list:~0,-2%
    echo  4. Apply the principle of least privilege
    echo  5. Audit service accounts monthly
) else (
    REM Clean system notification
    echo   SECURITY STATUS: NO DANGEROUS PRIVILEGES DETECTED
    echo   - System configuration appears secure
    echo   - Maintain regular privilege audits
)

:: *********************** AUDIT METADATA ***********************
echo.
echo Audit Report Summary:
echo --------------------
echo Report Path:   %cd%\%report%
echo Audit Time:    %date% %time:~0,8%
echo User Context:  %USERDOMAIN%\%USERNAME%
echo Host System:   %COMPUTERNAME%
echo Script Engine: Windows Batch
echo Version:       Final

:: *********************** EXECUTION COMPLETE ***********************
echo.
echo Press any key to exit...
pause > nul