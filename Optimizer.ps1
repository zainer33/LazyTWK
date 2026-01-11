# =========================
# Lazyy Windows 10 Optimizer
# =========================

Function Show-Menu {
    Clear-Host
    Write-Host "=============================="
    Write-Host "     Lazyy Windows 10 Optimizer"
    Write-Host "=============================="
    Write-Host "1) Basic Optimize"
    Write-Host "0) Quit"
}

Function Basic-Optimize {
    Write-Host "`n▶ Starting Basic Optimization..." -ForegroundColor Cyan

    # ---------------- Performance Tweaks ----------------
    Write-Host "`n[*] Setting Power Plan to High Performance"
    powercfg -setactive SCHEME_MIN

    Write-Host "[*] Disabling unnecessary startup apps..."
    Get-CimInstance Win32_StartupCommand | ForEach-Object {
        Write-Host " - $_.Name" -ForegroundColor Gray
    }
    Write-Host "⚠ Manual disable recommended via Ctrl+Shift+Esc → Startup tab"

    Write-Host "[*] Disabling visual effects for best performance..."
    $PerfKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
    If (!(Test-Path $PerfKey)) { New-Item -Path $PerfKey -Force }
    Set-ItemProperty -Path $PerfKey -Name VisualFXSetting -Value 2

    Write-Host "[*] Turning off background apps..."
    Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | 
        ForEach-Object { Set-ItemProperty $_.PSPath "GlobalUserDisabled" 1 }

    Write-Host "[*] Enabling Game Mode..."
    Set-ItemProperty "HKCU:\Software\Microsoft\GameBar" "AllowAutoGameMode" 1

    # ---------------- UI Tweaks ----------------
    Write-Host "[*] Enabling Dark Mode..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name AppsUseLightTheme -Value 0

    Write-Host "[*] Enabling Taskbar transparency..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name EnableTransparency -Value 1

    Write-Host "[*] Snap windows faster..."
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WindowArrangementActive -Value 1

    Write-Host "[*] Increase cursor speed..."
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name MouseSensitivity -Value 10

    Write-Host "[*] Enable clipboard history..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Clipboard" -Name EnableClipboardHistory -Value 1

    # ---------------- Security & Privacy ----------------
    Write-Host "[*] Turning off Remote Desktop..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name fDenyTSConnections -Value 1

    Write-Host "[*] Disabling Wi-Fi sharing / hotspot..."
    # No direct registry tweak, manual recommended
    Write-Host " ⚠ Turn off Mobile Hotspot manually if enabled"

    Write-Host "[*] Ensuring Windows Defender is on..."
    Set-MpPreference -DisableRealtimeMonitoring $false

    # ---------------- System Maintenance ----------------
    Write-Host "[*] Running Disk Cleanup..."
    Start-Process cleanmgr.exe -ArgumentList "/sagerun:1" -Wait

    Write-Host "`n✅ Basic Optimization Complete!"
    Read-Host "Press Enter to return to menu..."
}

# ================= MAIN MENU LOOP =================
Do {
    Show-Menu
    $choice = Read-Host "Enter your choice"

    Switch ($choice) {
        "1" { Basic-Optimize }
        "0" { Break }
        Default { Write-Host "❌ Invalid option" -ForegroundColor Red; Start-Sleep 1 }
    }
} While ($true)
