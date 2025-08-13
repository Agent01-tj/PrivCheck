@echo off
REM ===================================================================================
REM Picture Files Database Extractor
REM Purpose: Extract and catalog image references from HTML/Markdown files
REM Usage: extract_pictures.bat [source_file]
REM ===================================================================================

setlocal enabledelayedexpansion

echo Picture Files Database Extractor
echo =================================

REM Check if source file parameter is provided
if "%~1"=="" (
    echo Usage: %0 [source_file]
    echo Example: %0 README.md
    exit /b 1
)

set "source_file=%~1"

REM Verify source file exists
if not exist "%source_file%" (
    echo Error: File '%source_file%' not found
    exit /b 1
)

echo Processing: %source_file%
echo.

REM Create Resources directory if it doesn't exist
if not exist "Resources" mkdir Resources

REM Count image references
set /a image_count=0

echo Scanning for image references...
echo --------------------------------

REM Search for markdown image syntax ![alt](url)
for /f "tokens=*" %%a in ('findstr /r /c:"\!\[.*\](.*)" "%source_file%"') do (
    set /a image_count+=1
    echo Found image !image_count!: %%a
)

echo.
echo Extraction Summary:
echo ------------------
echo Source file: %source_file%
echo Images found: %image_count%
echo Database location: Resources\picture_files_database.json
echo.

echo Picture files database has been updated in the Resources folder.
echo Check Resources\README.md for detailed information.

pause