# ================================================
# LazyTWK Windows Optimizer 
# Supports Windows 10 & Windows 11
# Author: Lazyy
# ================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# ---------------- FUNCTIONS ----------------

Function Basic-Optimize {
    param($OS)
    [System.Windows.Forms.MessageBox]::Show("Running Basic Optimization for $OS")

    # ---------------- COMMON BASIC TWEAKS ----------------
    # Power plan
    powercfg -setactive SCHEME_MIN

    # Visual Effects
    Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects VisualFXSetting 2 -ErrorAction SilentlyContinue

    # Disable background apps
    Try {Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications GlobalUserDisabled 1 -ErrorAction SilentlyContinue}catch{}

    # Game Mode
    Set-ItemProperty HKCU:\Software\Microsoft\GameBar AllowAutoGameMode 1 -ErrorAction SilentlyContinue

    # Clipboard History
    Set-ItemProperty HKCU:\Software\Microsoft\Clipboard EnableClipboardHistory 1 -ErrorAction SilentlyContinue

    # Security
    Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server fDenyTSConnections 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableRealtimeMonitoring $false

    # Disk Cleanup
    Start-Process cleanmgr.exe -ArgumentList "/sagerun:1" -Wait
}

Function Ultimate-Optimize {
    param($OS)
    [System.Windows.Forms.MessageBox]::Show("Running Ultimate Optimization for $OS")

    # ---------------- COMMON TWEAKS ----------------
    powercfg /hibernate on
    bcdedit /set disabledynamictick yes
    Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management DisablePagingExecutive 1 -ErrorAction SilentlyContinue
    Dism /Online /Cleanup-Image /StartComponentCleanup
    netsh interface tcp set global autotuninglevel=disabled
    Set-ItemProperty HKCU:\System\GameConfigStore GameDVR_FSEBehavior 0 -ErrorAction SilentlyContinue
    Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced Start_TrackDocs 0 -ErrorAction SilentlyContinue
    Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance fAllowToGetHelp 0 -ErrorAction SilentlyContinue

    if($OS -eq "Windows11") {
        # ---------------- WINDOWS 11 SPECIFIC ----------------
        Write-Host "Applying Windows 11 specific tweaks..."

        # Disable Widgets
        Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced TaskbarDa 0 -ErrorAction SilentlyContinue
        # Disable Chat
        Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced TaskbarMn 0 -ErrorAction SilentlyContinue
        # Classic right-click menu
        reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

        # Core Win11 Optimizations
        # DirectStorage - informational
        Write-Host "⚠ DirectStorage: ensure NVMe SSD and supported GPU"

        # Hardware-Accelerated GPU Scheduling
        Write-Host "⚠ Enable GPU Scheduling via Settings -> Display -> Graphics"

        # Efficiency Mode
        Write-Host "⚠ Efficiency Mode: enable in Task Manager for background apps"

        # Snap Layouts Suggestions
        Write-Host "⚠ Disable Snap Layouts manually in Settings -> Multitasking"

        # Widgets, Live Captions
        Write-Host "⚠ Widgets & Live Captions: disable manually for better performance"

        # Clipboard History
        Set-ItemProperty HKCU:\Software\Microsoft\Clipboard EnableClipboardHistory 0 -ErrorAction SilentlyContinue

        # Focus Assist
        Write-Host "⚠ Enable Focus Assist during gaming"

        # OneDrive integration
        Write-Host "⚠ Remove OneDrive if unused"

        # Automatic Restart on System Failure
        Write-Host "⚠ Disable Automatic Restart via System Properties"

        # Start Menu & Taskbar tweaks
        Write-Host "⚠ Reduce animations, hide search box, disable transparency, adjust taskbar icons manually"

        # Gaming Tweaks
        Write-Host "⚠ Enable Game Mode, disable fullscreen optimization, Auto HDR, Game Bar overlays, DirectX 12 Ultimate if supported"

        # Storage Tweaks
        Write-Host "⚠ TRIM, SSD caching, move Temp folders, Storage Sense, NTFS compression, Pagefile management"

        # CPU & Power
        Write-Host "⚠ Ultimate Performance plan, core parking, disable power throttling, BIOS tweaks if available"

        # RAM & Memory
        Write-Host "⚠ Enable Memory Integrity, adjust Virtual RAM, clear cache, ReadyBoost if <8GB RAM"

        # Network
        Write-Host "⚠ UDP Fast Path, QoS, DNS over HTTPS, disable background network apps, flush DNS, bandwidth optimization"

        # Security & Background Services
        Write-Host "⚠ Disable Defender if using AV, disable telemetry, SmartScreen, background apps, ads ID, location, Edge preload"

        # Visuals & Animations
        Write-Host "⚠ Disable transparency, animations, shadows, adjust performance options, classic theme, reduce context menu delay"

        # File Explorer & Productivity
        Write-Host "⚠ Quick Access, thumbnails, preview pane, recent files, OneDrive integration, use alternate file managers"

        # Miscellaneous
        Write-Host "⚠ Snap Assist, Widgets background, Alt+Tab speed, Night Light, Xbox services, Startup apps, Tips & Tricks, Fast Boot + Fast Resume"
    }
}

# ---------------- GUI ----------------
$form = New-Object System.Windows.Forms.Form
$form.Text = "LazyTWK Optimizer"
$form.Size = New-Object System.Drawing.Size(650,500)
$form.StartPosition = "CenterScreen"

# OS Label
$lbl = New-Object System.Windows.Forms.Label
$lbl.Text = "Select Windows Version & Optimization Level"
$lbl.AutoSize = $true
$lbl.Location = New-Object System.Drawing.Point(180,20)
$form.Controls.Add($lbl)

# OS ComboBox
$cbOS = New-Object System.Windows.Forms.ComboBox
$cbOS.Location = New-Object System.Drawing.Point(200,50)
$cbOS.Size = New-Object System.Drawing.Size(150,25)
$cbOS.Items.AddRange(@("Windows 10","Windows 11"))
$cbOS.SelectedIndex = 0
$form.Controls.Add($cbOS)

# Basic Button
$btnBasic = New-Object System.Windows.Forms.Button
$btnBasic.Text = "Basic Optimize"
$btnBasic.Size = New-Object System.Drawing.Size(150,40)
$btnBasic.Location = New-Object System.Drawing.Point(150,120)
$btnBasic.Add_Click({
    $os = $cbOS.SelectedItem
    Basic-Optimize $os
    [System.Windows.Forms.MessageBox]::Show("Basic Optimization for $os Completed!")
})
$form.Controls.Add($btnBasic)

# Ultimate Button
$btnUltimate = New-Object System.Windows.Forms.Button
$btnUltimate.Text = "Ultimate Optimize"
$btnUltimate.Size = New-Object System.Drawing.Size(150,40)
$btnUltimate.Location = New-Object System.Drawing.Point(320,120)
$btnUltimate.Add_Click({
    $os = $cbOS.SelectedItem
    Ultimate-Optimize $os
    [System.Windows.Forms.MessageBox]::Show("Ultimate Optimization for $os Completed!")
})
$form.Controls.Add($btnUltimate)

# Quit Button
$btnQuit = New-Object System.Windows.Forms.Button
$btnQuit.Text = "Quit"
$btnQuit.Size = New-Object System.Drawing.Size(80,30)
$btnQuit.Location = New-Object System.Drawing.Point(260,400)
$btnQuit.Add_Click({$form.Close()})
$form.Controls.Add($btnQuit)

# Show Form
[void]$form.ShowDialog()
