@echo off
title LazyTWK - Windows 10 Basic Optimizer
color 1F
setlocal enabledelayedexpansion

:: Log file for applied tweaks
set "logfile=%~dp0LazyTWK_AppliedTweaks.txt"
echo LazyTWK Basic Optimizer Log > "%logfile%"

:menu
cls
echo ================================
echo        LAZY TWK MENU
echo ================================
echo.
echo 1: Basic Optimizer
echo 0: Quit
echo.
set /p choice="Select an option (0-1): "

if "%choice%"=="1" goto optimizer
if "%choice%"=="0" goto exit
goto menu

:optimizer
cls
echo Running Basic Optimizer...
echo.

:: 1. Performance Tweaks
echo [Performance Tweaks]
echo - Disable Startup Programs
echo Please disable unnecessary apps manually via Ctrl+Shift+Esc -> Startup tab
echo Disabled Startup Programs advised >> "%logfile%"

echo - Set Power Plan to High Performance
powercfg -setactive SCHEME_MIN
echo Power Plan set to High Performance >> "%logfile%"

echo - Disable Visual Effects for Best Performance
echo Please open System Properties -> Advanced -> Performance Settings -> Adjust for best performance
echo Visual Effects advised >> "%logfile%"

echo - Increase Virtual Memory
echo Please set Virtual Memory manually (1.5-2x RAM)
echo Virtual Memory advised >> "%logfile%"

echo - Turn Off Background Apps
start ms-settings:privacy-backgroundapps
echo Background Apps OFF advised >> "%logfile%"

echo - Enable Game Mode
start ms-settings:gaming-gamemode
echo Game Mode ON advised >> "%logfile%"

echo - Update Graphics Drivers
echo Please visit Intel/NVIDIA/AMD to update drivers
echo Graphics Drivers update advised >> "%logfile%"

echo - Defragment HDD / Optimize SSD
start dfrgui
echo Disk Optimization advised >> "%logfile%"

echo - Disable Search Indexing
echo Right-click drive -> Properties -> Uncheck "Allow files on this drive to have contents indexed"
echo Search Indexing advised >> "%logfile%"

echo - Disable Unnecessary Services
echo Open services.msc -> disable unused services like Fax, Print Spooler
echo Unnecessary Services advised >> "%logfile%"
echo.

:: 2. UI & Usability Tweaks
echo [UI & Usability Tweaks]
start ms-settings:personalization-colors
echo - Dark Mode & Taskbar Transparency advised >> "%logfile%"
start ms-settings:multitasking
echo - Faster Window Snapping advised >> "%logfile%"
control main.cpl,,1
echo - Increase Mouse Pointer Speed advised >> "%logfile%"
start ms-settings:clipboard
echo - Enable Clipboard History advised >> "%logfile%"
start control folders
echo - Show File Extensions advised >> "%logfile%"
echo.

:: 3. Security & Privacy Tweaks
echo [Security & Privacy Tweaks]
start ms-settings:remotedesktop
echo - Remote Desktop OFF advised >> "%logfile%"
start ms-settings:network-mobilehotspot
echo - Wi-Fi Sharing OFF advised >> "%logfile%"
start ms-settings:windowsdefender
echo - Windows Defender ON advised >> "%logfile%"
echo.

:: 4. System Maintenance
echo [System Maintenance Tweaks]
cleanmgr
echo - Disk Cleanup advised >> "%logfile%"
echo Please run Malwarebytes or Windows Defender for a full scan
echo Malware/Adware check advised >> "%logfile%"
echo.

echo Basic Optimizer completed!
echo Applied tweaks log saved at "%logfile%"
pause
goto menu

:exit
cls
echo Exiting LazyTWK. Goodbye!
pause
exit
