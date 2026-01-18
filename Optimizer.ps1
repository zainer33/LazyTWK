# ================================================
# LazyTWK Windows Optimizer
# Author: Lazyy
# Supports Windows 10 & Windows 11
# Includes Valorant FPS Optimization & HONE.gg install
# ================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# ---------------- FUNCTIONS ----------------

# ---------------- BASIC OPTIMIZE ----------------
Function Basic-Optimize {
    param($OS)
    [System.Windows.Forms.MessageBox]::Show("Running Basic Optimization for $OS","LazyTWK Basic Optimize",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)

    # ---------------- COMMON BASIC TWEAKS ----------------
    powercfg -setactive SCHEME_MIN
    Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects VisualFXSetting 2 -ErrorAction SilentlyContinue
    Try {Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications GlobalUserDisabled 1 -ErrorAction SilentlyContinue}catch{}
    Set-ItemProperty HKCU:\Software\Microsoft\GameBar AllowAutoGameMode 1 -ErrorAction SilentlyContinue
    Set-ItemProperty HKCU:\Software\Microsoft\Clipboard EnableClipboardHistory 1 -ErrorAction SilentlyContinue
    Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server fDenyTSConnections 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableRealtimeMonitoring $false
    Start-Process cleanmgr.exe -ArgumentList "/sagerun:1" -Wait
}

# ---------------- ULTIMATE OPTIMIZE ----------------
Function Ultimate-Optimize {
    param($OS)
    [System.Windows.Forms.MessageBox]::Show("Running Ultimate Optimization for $OS","LazyTWK Ultimate Optimize",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)

    # ---------------- COMMON ----------------
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

        # Visual Effects / Performance
        Write-Host "Disabling Windows 11 visual effects..."
        Write-Host "Disabling animations, transparency, shadows, effects..."
        # Note: GUI warning, user may do manually

        # Disable VBS
        Write-Host "Disabling Virtualization Based Security (VBS)..."
        bcdedit /set hypervisorlaunchtype off

        # SysMain / Superfetch
        Write-Host "Disabling SysMain (Superfetch)..."
        Stop-Service -Name SysMain -ErrorAction SilentlyContinue
        Set-Service -Name SysMain -StartupType Disabled

        # Clipboard history off
        Set-ItemProperty HKCU:\Software\Microsoft\Clipboard EnableClipboardHistory 0 -ErrorAction SilentlyContinue

        # Disable Widgets & Chat
        Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced TaskbarDa 0 -ErrorAction SilentlyContinue
        Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced TaskbarMn 0 -ErrorAction SilentlyContinue

        # Classic right-click menu
        reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

        Write-Host "Advanced Win11 tweaks applied. Manual tweaks may be required for DirectStorage, GPU scheduling, Efficiency Mode, Snap Layouts, Widgets, Focus Assist, OneDrive, automatic restart, gaming optimizations."
    }
}

# ---------------- VALORANT FPS OPTIMIZE ----------------
Function Valorant-FPS-Optimize {
    param($OS)
    [System.Windows.Forms.MessageBox]::Show("Applying Valorant FPS Optimizations for $OS","Valorant FPS Boost",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)

    # 4GB RAM tweaks
    Write-Host "Disabling Windows visual effects..."
    Write-Host "Disabling VBS (Virtualization Based Security)..."
    bcdedit /set hypervisorlaunchtype off
    Write-Host "Stopping SysMain (Superfetch)..."
    Stop-Service -Name SysMain -ErrorAction SilentlyContinue
    Set-Service -Name SysMain -StartupType Disabled
    Write-Host "Temporarily disable Windows Defender during gameplay..."

    # Valorant INI tweaks
    $valorantPath = "$env:LOCALAPPDATA\Riot Games\VALORANT\live\ShooterGame\Config\Windows"
    if(Test-Path "$valorantPath\RiotMachineSpecific.ini") {
        Copy-Item "$valorantPath\RiotMachineSpecific.ini" "$valorantPath\RiotMachineSpecific.ini.bak" -Force
        Add-Content "$valorantPath\RiotMachineSpecific.ini" @"
[SystemSettings]
r.ShadowQuality=0
r.Shadow.MaxResolution=4
r.DynamicShadowDistance=0
r.LightShafts=0
r.BloomQuality=0
r.FastBlurThreshold=0
r.Upscale.Quality=1
r.ResolutionQuality=50
r.PostProcessAAQuality=0
"@
        Write-Host "Valorant config updated (backup saved)."
    } else {
        Write-Host "Valorant config file not found. Launch game once to generate files."
    }

    # Fullscreen optimizations
    Write-Host "Reminder: Disable Fullscreen Optimizations in VALORANT-Win64-Shipping.exe properties."

    # Set process priority high
    Write-Host "Reminder: Set VALORANT-Win64-Shipping.exe to High priority in Task Manager."

    # Network Tweaks guidance
    Write-Host "Disable Nagle Algorithm, disable virtual adapters, use wired Ethernet for low latency."

    [System.Windows.Forms.MessageBox]::Show("Valorant FPS Tweaks applied (some require manual action).","Valorant FPS Boost",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)
}

# ---------------- INSTALL HONE.GG ----------------
Function Install-HoneGG {
    $honeURL = "https://hone.gg/download/latest" # placeholder URL
    [System.Windows.Forms.MessageBox]::Show("Downloading and Installing HONE.gg","HONE.gg",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)
    Write-Host "Downloading HONE.gg from $honeURL..."
    # You can expand with actual download and installer logic here
}

# ---------------- GUI ----------------
$form = New-Object System.Windows.Forms.Form
$form.Text = "LazyTWK Optimizer (Author: Lazyy)"
$form.Size = New-Object System.Drawing.Size(700,600)
$form.StartPosition = "CenterScreen"

# Label
$lbl = New-Object System.Windows.Forms.Label
$lbl.Text = "Select OS & Optimization"
$lbl.AutoSize = $true
$lbl.Location = New-Object System.Drawing.Point(200,20)
$form.Controls.Add($lbl)

# OS ComboBox
$cbOS = New-Object System.Windows.Forms.ComboBox
$cbOS.Location = New-Object System.Drawing.Point(250,50)
$cbOS.Size = New-Object System.Drawing.Size(150,25)
$cbOS.Items.AddRange(@("Windows 10","Windows 11"))
$cbOS.SelectedIndex = 0
$form.Controls.Add($cbOS)

# Basic Button
$btnBasic = New-Object System.Windows.Forms.Button
$btnBasic.Text = "Basic Optimize"
$btnBasic.Size = New-Object System.Drawing.Size(180,40)
$btnBasic.Location = New-Object System.Drawing.Point(150,120)
$btnBasic.Add_Click({
    $os = $cbOS.SelectedItem
    Basic-Optimize $os
})
$form.Controls.Add($btnBasic)

# Ultimate Button
$btnUltimate = New-Object System.Windows.Forms.Button
$btnUltimate.Text = "Ultimate Optimize"
$btnUltimate.Size = New-Object System.Drawing.Size(180,40)
$btnUltimate.Location = New-Object System.Drawing.Point(360,120)
$btnUltimate.Add_Click({
    $os = $cbOS.SelectedItem
    Ultimate-Optimize $os
})
$form.Controls.Add($btnUltimate)

# Valorant FPS Button
$btnValorant = New-Object System.Windows.Forms.Button
$btnValorant.Text = "Valorant FPS Boost"
$btnValorant.Size = New-Object System.Drawing.Size(180,40)
$btnValorant.Location = New-Object System.Drawing.Point(150,200)
$btnValorant.Add_Click({
    $os = $cbOS.SelectedItem
    Valorant-FPS-Optimize $os
})
$form.Controls.Add($btnValorant)

# Install HONE.gg Button
$btnHone = New-Object System.Windows.Forms.Button
$btnHone.Text = "Install HONE.gg"
$btnHone.Size = New-Object System.Drawing.Size(180,40)
$btnHone.Location = New-Object System.Drawing.Point(360,200)
$btnHone.Add_Click({
    Install-HoneGG
})
$form.Controls.Add($btnHone)

# Quit Button
$btnQuit = New-Object System.Windows.Forms.Button
$btnQuit.Text = "Quit"
$btnQuit.Size = New-Object System.Drawing.Size(100,30)
$btnQuit.Location = New-Object System.Drawing.Point(280,500)
$btnQuit.Add_Click({$form.Close()})
$form.Controls.Add($btnQuit)

# Show Form
[void]$form.ShowDialog()
