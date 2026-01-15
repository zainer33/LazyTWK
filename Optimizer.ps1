# =========================
# Lazyy Windows Optimizer
# Win10 & Win11 Supported
# =========================

# Detect OS
$OSBuild = (Get-CimInstance Win32_OperatingSystem).BuildNumber
$DetectedOS = if ($OSBuild -ge 22000) { "Windows11" } else { "Windows10" }

Function Show-OSMenu {
    Clear-Host
    Write-Host "=============================="
    Write-Host "     Lazyy Windows Optimizer"
    Write-Host "=============================="
    Write-Host "Detected OS : $DetectedOS"
    Write-Host ""
    Write-Host "1) Optimize Windows 10"
    Write-Host "2) Optimize Windows 11"
    Write-Host "0) Exit"
}

Function Show-OptimizeMenu {
    Clear-Host
    Write-Host "=============================="
    Write-Host "   Optimization Level"
    Write-Host "=============================="
    Write-Host "1) Basic Optimize"
    Write-Host "2) Ultimate Optimize"
    Write-Host "0) Back"
}

# ---------------- BASIC OPTIMIZE ----------------
Function Basic-Optimize {
    param ($OS)

    Write-Host "`n▶ Running Basic Optimization for $OS..." -ForegroundColor Cyan

    # Power Plan
    powercfg -setactive SCHEME_MIN

    # Disable background apps
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" 1 -ErrorAction SilentlyContinue

    # Game Mode
    Set-ItemProperty "HKCU:\Software\Microsoft\GameBar" "AllowAutoGameMode" 1 -ErrorAction SilentlyContinue

    # Visual Effects
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" 2 -ErrorAction SilentlyContinue

    # UI Tweaks
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "EnableTransparency" 1 -ErrorAction SilentlyContinue
    Set-ItemProperty "HKCU:\Software\Microsoft\Clipboard" "EnableClipboardHistory" 1 -ErrorAction SilentlyContinue

    # Security
    Set-MpPreference -DisableRealtimeMonitoring $false
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" "fDenyTSConnections" 1

    Write-Host "`n✅ Basic Optimization Complete!"
    Read-Host "Press Enter to continue..."
}

# ---------------- ULTIMATE OPTIMIZE ----------------
Function Ultimate-Optimize {
    param ($OS)

    Write-Host "`n▶ Running Ultimate Optimization for $OS..." -ForegroundColor Magenta

    # ---------- BOOT & STARTUP ----------
    powercfg /hibernate on
    bcdedit /set disabledynamictick yes

    # ---------- MEMORY ----------
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "DisablePagingExecutive" 1

    # ---------- DISK ----------
    Dism /Online /Cleanup-Image /StartComponentCleanup

    # ---------- NETWORK ----------
    netsh interface tcp set global autotuninglevel=disabled

    # ---------- GPU ----------
    Set-ItemProperty "HKCU:\System\GameConfigStore" "GameDVR_FSEBehavior" 0

    # ---------- UI (Shared) ----------
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackDocs" 0

    # ---------- WINDOWS 11 ONLY ----------
    if ($OS -eq "Windows11") {
        Write-Host "Applying Windows 11 specific tweaks..."

        # Disable Widgets
        Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarDa" 0 -ErrorAction SilentlyContinue

        # Disable Chat
        Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarMn" 0 -ErrorAction SilentlyContinue

        # Old Right Click Menu
        reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

        Stop-Process -Name explorer -Force
    }

    # ---------- PRIVACY ----------
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" "fAllowToGetHelp" 0

    Write-Host "`n✅ Ultimate Optimization Complete!"
    Read-Host "Press Enter to continue..."
}

# ================= MAIN =================
Do {
    Show-OSMenu
    $osChoice = Read-Host "Select OS"

    Switch ($osChoice) {
        "1" { $SelectedOS = "Windows10" }
        "2" { $SelectedOS = "Windows11" }
        "0" { Exit }
        Default { continue }
    }

    Do {
        Show-OptimizeMenu
        $optChoice = Read-Host "Select Option"

        Switch ($optChoice) {
            "1" { Basic-Optimize $SelectedOS }
            "2" { Ultimate-Optimize $SelectedOS }
            "0" { break }
        }
    } While ($true)

} While ($true)
