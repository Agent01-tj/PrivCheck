# 🔒 PrivCheck - Windows Privilege Escalation Auditor

**Identify high-risk privileges that could lead to system compromise**  
Batch script for security professionals to audit dangerous Windows privileges.

![Windows Privilege Audit](https://img.shields.io/badge/Platform-Windows-blue?logo=windows) 
![Batch Script](https://img.shields.io/badge/Language-Batch-green)

## 📌 Features

- Detects 6 critical privileges enabling privilege escalation
- Automated risk assessment (LOW/MEDIUM/HIGH)
- Self-contained batch script - no dependencies
- Timestamped audit reports
- Administrator context detection
- Remediation guidance with policy steps
- Human-readable impact analysis

## 🚀 Usage

1. Download [`PrivCheck.txt`](PrivCheck.txt) and rename to `PrivCheck.bat`
2. **Run as Administrator**:
   ```cmd
   PrivCheck.bat
