# =========================
# Lazyy Windows 10 Optimizer v2
# =========================

Function Show-Menu {
    Clear-Host
    Write-Host "=============================="
    Write-Host "     Lazyy Windows 10 Optimizer"
    Write-Host "=============================="
    Write-Host "1) Basic Optimize"
    Write-Host "2) Ultimate Optimize"
    Write-Host "0) Quit"
}

Function Basic-Optimize {
    Write-Host "`n▶ Starting Basic Optimization..." -ForegroundColor Cyan

    # Power Plan
    powercfg -setactive SCHEME_MIN

    # Visual Effects
    Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects VisualFXSetting 2

    # Background Apps
    Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | 
        ForEach-Object { Set-ItemProperty $_.PSPath "GlobalUserDisabled" 1 }

    # Game Mode
    Set-ItemProperty HKCU:\Software\Microsoft\GameBar AllowAutoGameMode 1

    # UI Tweaks
    Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize AppsUseLightTheme 0
    Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize EnableTransparency 1
    Set-ItemProperty HKCU:\Control Panel\Desktop WindowArrangementActive 1
    Set-ItemProperty HKCU:\Control Panel\Mouse MouseSensitivity 10
    Set-ItemProperty HKCU:\Software\Microsoft\Clipboard EnableClipboardHistory 1

    # Security
    Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server fDenyTSConnections 1
    Set-MpPreference -DisableRealtimeMonitoring $false

    # Disk Cleanup
    Start-Process cleanmgr.exe -ArgumentList "/sagerun:1" -Wait

    Write-Host "`n✅ Basic Optimization Complete!"
    Read-Host "Press Enter to return to menu..."
}

Function Ultimate-Optimize {
    Write-Host "`n▶ Starting Ultimate Optimization..." -ForegroundColor Magenta

    # ---------- Boot & Startup ----------
    powercfg -setactive SCHEME_MIN
    # Fast Startup
    powercfg /hibernate on
    # Minimal Boot: info only, cannot automate fully
    Write-Host "⚠ Minimal Boot: run msconfig -> Boot -> Minimal manually"
    # Startup delay services
    Write-Host "⚠ Delayed services: adjust Windows Update in services.msc"
    # OneDrive
    Write-Host "⚠ Disable OneDrive manually in Task Manager -> Startup"

    # ---------- Memory & Performance ----------
    Write-Host "⚠ ReadyBoost: plug USB -> Properties -> ReadyBoost manually"
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "DisablePagingExecutive" 1
    Write-Host "⚠ CPU Priority: set manually in Task Manager"
    bcdedit /set disabledynamictick yes
    Write-Host "⚠ Turn off animations manually via Performance Settings"

    # ---------- Disk & Storage ----------
    fsutil behavior query DisableDeleteNotify
    Write-Host "⚠ Enable Write Caching via Device Manager manually"
    Dism /Online /Cleanup-Image /StartComponentCleanup
    Write-Host "⚠ Move TEMP folders manually via Environment Variables"
    Write-Host "⚠ Compact OS optional: run 'compact /compactos:always' manually"

    # ---------- Network ----------
    Write-Host "⚠ Disable Large Send Offload and Auto-Tuning manually"
    netsh interface tcp set global autotuninglevel=disabled
    Write-Host "⚠ Disable RDC manually via Windows Features"
    Write-Host "⚠ QoS Packet Scheduler check manually"
    Write-Host "⚠ Set DNS manually: 8.8.8.8 / 1.1.1.1"

    # ---------- GPU & Graphics ----------
    Write-Host "⚠ GPU: disable hardware-accelerated GPU scheduling manually"
    Write-Host "⚠ Force max performance / V-Sync / Shader Cache: set in NVIDIA/AMD panel"
    Set-ItemProperty "HKCU:\System\GameConfigStore" "GameDVR_FSEBehavior" 0

    # ---------- UI & Experience ----------
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackDocs" 0
    Write-Host "⚠ Disable Taskbar Peek manually"
    Write-Host "⚠ High DPI scaling: manually via app properties"
    Write-Host "⚠ Smooth scrolling Edge: manually via Settings"
    Write-Host "⚠ Customize title bars colors via Settings -> Personalization"

    # ---------- Privacy & Security ----------
    Write-Host "⚠ Disable Wi-Fi Sense / Auto connections manually"
    Write-Host "⚠ Turn off Advertising ID manually via Settings -> Privacy"
    Write-Host "⚠ Disable Feedback & Diagnostic Data manually"
    Write-Host "⚠ Enable Controlled Folder Access via Windows Security"
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" "fAllowToGetHelp" 0

    Write-Host "`n✅ Ultimate Optimization Complete!"
    Read-Host "Press Enter to return to menu..."
}

# ================== MAIN MENU LOOP ==================
Do {
    Show-Menu
    $choice = Read-Host "Enter your choice"

    Switch ($choice) {
        "1" { Basic-Optimize }
        "2" { Ultimate-Optimize }
        "0" { Break }
        Default { Write-Host "❌ Invalid option" -ForegroundColor Red; Start-Sleep 1 }
    }
} While ($true)
