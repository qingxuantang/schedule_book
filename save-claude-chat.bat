@echo off
chcp 65001 >nul
echo =============================================
echo     Claude Chat Backup Script (Windows)
echo =============================================

REM Get current directory info
set CURRENT_DIR=%CD%
for %%I in (.) do set PROJECT_NAME=%%~nxI

echo Current project: %PROJECT_NAME%
echo Current directory: %CURRENT_DIR%
echo.

REM Check WSL environment
wsl --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Error: WSL environment not detected
    echo Please ensure WSL is installed and Ubuntu is configured
    pause
    exit /b 1
)

echo Checking Claude log file...
wsl test -f /home/qingxuantang/.claude.json
if %ERRORLEVEL% NEQ 0 (
    echo Error: Claude log file not found
    echo Path: /home/qingxuantang/.claude.json
    echo Please confirm Claude is running and has generated chat history
    pause
    exit /b 1
)

echo Claude log file found
echo.

REM Convert Windows path to WSL format
set WSL_PATH=%CURRENT_DIR:\=/%
set WSL_PATH=%WSL_PATH:D:=/mnt/d%

REM Run backup script in WSL
echo Running backup script...
wsl cd "%WSL_PATH%" ^&^& ./save-claude-chat.sh

if %ERRORLEVEL% EQU 0 (
    echo.
    echo =============================================
    echo Claude chat history backup successful!
    echo =============================================
    echo.
    echo Save location: %CURRENT_DIR%\.claude\
    echo Latest record: claude-chat-latest.json
    echo Documentation: claude-chat-history-location.md
    echo.
    echo Quick tips:
    echo   • View records: cd .claude ^&^& ls -la
    echo   • Next time: double-click save-claude-chat.bat
    echo   • Or run: ./save-claude-chat.sh
) else (
    echo.
    echo Error occurred during backup process
    echo Please check WSL environment and file permissions
)

echo.
pause