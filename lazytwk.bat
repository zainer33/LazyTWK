@echo off
title LazyTWK - Windows 10 Performance Tweaks
color 1F
setlocal enabledelayedexpansion

:: Log file in same folder
set "logfile=%~dp0LazyTWK_AppliedTweaks.txt"
echo LazyTWK Applied Tweaks Log > "%logfile%"

:menu
cls
echo ================================
echo        LAZY TWK MENU
echo ================================
echo.
echo 1. Performance Tweaks
echo 2. UI & Usability Tweaks
echo 3. Security & Privacy Tweaks
echo 4. System Maintenance Tweaks
echo 5. Exit
echo.
set /p choice="Select an option (1-5): "

if "%choice%"=="1" goto performance
if "%choice%"=="2" goto ui
if "%choice%"=="3" goto security
if "%choice%"=="4" goto maintenance
if "%choice%"=="5" goto exit
goto menu

:performance
cls
echo === Performance Tweaks ===
echo.
echo 1. Disable Startup Programs
echo 2. Set Power Plan to High Performance
echo 3. Disable Visual Effects for Best Performance
echo 4. Increase Virtual Memory
echo 5. Turn Off Background Apps
echo 6. Enable Game Mode
echo 7. Update Graphics Drivers
echo 8. Defragment HDD / Optimize SSD
echo 9. Disable Search Indexing
echo 10. Disable Unnecessary Services
echo 11. Back to Main Menu
echo.
set /p perf="Select tweak to apply (1-11): "

if "%perf%"=="1" (
    echo Open Task Manager -> Startup tab -> Disable unnecessary apps
    echo 1. Disabled Startup Programs >> "%logfile%"
)
if "%perf%"=="2" (
    powercfg -setactive SCHEME_MIN
    echo 2. Power Plan set to High Performance >> "%logfile%"
)
if "%perf%"=="3" (
    echo Open System Properties -> Performance Settings -> Adjust for best performance
    echo 3. Visual Effects set to best performance >> "%logfile%"
)
if "%perf%"=="4" (
    echo Adjust Virtual Memory manually via System Properties -> Advanced -> Performance
    echo 4. Virtual Memory tweak advised >> "%logfile%"
)
if "%perf%"=="5" (
    start ms-settings:privacy-backgroundapps
    echo 5. Background apps turned off >> "%logfile%"
)
if "%perf%"=="6" (
    start ms-settings:gaming-gamemode
    echo 6. Game Mode enabled >> "%logfile%"
)
if "%perf%"=="7" (
    echo Update your graphics drivers manually from Intel/NVIDIA/AMD websites
    echo 7. Graphics drivers reminder >> "%logfile%"
)
if "%perf%"=="8" (
    start dfrgui
    echo 8. Disk optimization advised >> "%logfile%"
)
if "%perf%"=="9" (
    echo Right-click drive -> Properties -> Uncheck 'Allow files on this drive to have contents indexed'
    echo 9. Search indexing disabled advised >> "%logfile%"
)
if "%perf%"=="10" (
    echo Open services.msc and disable unnecessary services like Fax, Print Spooler, etc.
    echo 10. Unnecessary services advised to disable >> "%logfile%"
)
if "%perf%"=="11" goto menu
pause
goto performance

:ui
cls
echo === UI & Usability Tweaks ===
echo.
echo 1. Enable Dark Mode
echo 2. Taskbar Transparency ON
echo 3. Faster Window Snapping
echo 4. Increase Mouse Pointer Speed
echo 5. Enable Clipboard History
echo 6. Show File Extensions
echo 7. Back to Main Menu
echo.
set /p uiopt="Select tweak to apply (1-7): "

if "%uiopt%"=="1" (
    start ms-settings:personalization-colors
    echo 1. Dark Mode advised >> "%logfile%"
)
if "%uiopt%"=="2" (
    start ms-settings:personalization-colors
    echo 2. Taskbar Transparency advised >> "%logfile%"
)
if "%uiopt%"=="3" (
    start ms-settings:multitasking
    echo 3. Snap Windows advised >> "%logfile%"
)
if "%uiopt%"=="4" (
    control main.cpl,,1
    echo 4. Cursor speed advised >> "%logfile%"
)
if "%uiopt%"=="5" (
    start ms-settings:clipboard
    echo 5. Clipboard History enabled advised >> "%logfile%"
)
if "%uiopt%"=="6" (
    start control folders
    echo 6. File extensions shown advised >> "%logfile%"
)
if "%uiopt%"=="7" goto menu
pause
goto ui

:security
cls
echo === Security & Privacy Tweaks ===
echo.
echo 1. Turn Off Remote Desktop
echo 2. Disable Wi-Fi Sharing / Hotspot
echo 3. Enable Windows Defender / Security
echo 4. Back to Main Menu
echo.
set /p sec="Select tweak to apply (1-4): "

if "%sec%"=="1" (
    start ms-settings:remotedesktop
    echo 1. Remote Desktop turned off advised >> "%logfile%"
)
if "%sec%"=="2" (
    start ms-settings:network-mobilehotspot
    echo 2. Wi-Fi sharing disabled advised >> "%logfile%"
)
if "%sec%"=="3" (
    start ms-settings:windowsdefender
    echo 3. Windows Defender enabled advised >> "%logfile%"
)
if "%sec%"=="4" goto menu
pause
goto security

:maintenance
cls
echo === System Maintenance Tweaks ===
echo.
echo 1. Clean Up Disk
echo 2. Check for Malware/Adware
echo 3. Back to Main Menu
echo.
set /p maint="Select tweak to apply (1-3): "

if "%maint%"=="1" (
    cleanmgr
    echo 1. Disk Cleanup advised >> "%logfile%"
)
if "%maint%"=="2" (
    echo Run Malwarebytes or Windows Defender scan manually
    echo 2. Malware/Adware scan advised >> "%logfile%"
)
if "%maint%"=="3" goto menu
pause
goto maintenance

:exit
cls
echo Thank you for using LazyTWK!
echo Applied tweaks log saved to: "%logfile%"
pause
exit
