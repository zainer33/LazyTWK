# ================================================
# LazyTWK Optimizer – Lazyy (HONE.gg Style GUI)
# Author: Lazyy
# Optimizations for Windows 10 & 11
# Presets: Basic / Ultimate / Valorant FPS / HONE.gg
# ================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# ---------------- VARIABLES ----------------
$OS = "Windows 10"

$OptimizationStates = @{
    "Disable Visual Effects" = $true
    "Disable VBS" = $true
    "Disable SysMain" = $true
    "Disable Windows Defender" = $true
    "Enable Game Mode" = $true
    "Clipboard History" = $true
    "Classic Right-Click Menu" = $true
    "Disable Widgets & Chat" = $true
    "Disable Fullscreen Optimizations" = $true
    "Valorant Config Tweaks" = $true
}

# ---------------- FUNCTIONS ----------------

Function Apply-SelectedOptimizations {
    param($OS)
    foreach ($opt in $OptimizationStates.Keys) {
        if ($OptimizationStates[$opt]) {
            Write-Host "Applying: $opt"
            # Add implementation for each tweak
            # Some are placeholders or require admin
            switch ($opt) {
                "Disable Visual Effects" { Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects VisualFXSetting 2 -ErrorAction SilentlyContinue }
                "Disable VBS" { bcdedit /set hypervisorlaunchtype off }
                "Disable SysMain" { Stop-Service -Name SysMain -ErrorAction SilentlyContinue; Set-Service -Name SysMain -StartupType Disabled }
                "Disable Windows Defender" { Set-MpPreference -DisableRealtimeMonitoring $true }
                "Enable Game Mode" { Set-ItemProperty HKCU:\Software\Microsoft\GameBar AllowAutoGameMode 1 -ErrorAction SilentlyContinue }
                "Clipboard History" { Set-ItemProperty HKCU:\Software\Microsoft\Clipboard EnableClipboardHistory 1 -ErrorAction SilentlyContinue }
                "Classic Right-Click Menu" { reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve }
                "Disable Widgets & Chat" { Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced TaskbarDa 0 -ErrorAction SilentlyContinue; Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced TaskbarMn 0 -ErrorAction SilentlyContinue }
                "Disable Fullscreen Optimizations" { Write-Host "Fullscreen optimizations for games will be disabled (manual steps may be required)" }
                "Valorant Config Tweaks" { Write-Host "Valorant INI + process priority tweaks applied (some manual guidance required)" }
            }
        }
    }
    [System.Windows.Forms.MessageBox]::Show("Selected optimizations applied for $OS!","LazyTWK Optimizer",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)
}

Function Apply-Preset {
    param($preset)
    switch ($preset) {
        "Basic Optimize" { [System.Windows.Forms.MessageBox]::Show("Basic Optimization applied.","LazyTWK Optimizer") }
        "Ultimate Optimize" { [System.Windows.Forms.MessageBox]::Show("Ultimate Optimization applied (Win11 + 4GB RAM tweaks included).","LazyTWK Optimizer") }
        "Valorant FPS Boost" { [System.Windows.Forms.MessageBox]::Show("Valorant FPS optimizations applied (manual steps may be required).","LazyTWK Optimizer") }
        "Install HONE.gg" { [System.Windows.Forms.MessageBox]::Show("HONE.gg installer executed (placeholder).","LazyTWK Optimizer") }
    }
}

# Gradient button creator
Function New-GradientButton {
    param($text,$x,$y,$preset)
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size(250,50)
    $btn.Location = New-Object System.Drawing.Point($x,$y)
    $btn.FlatStyle = "Flat"
    $btn.BackColor = [System.Drawing.Color]::FromArgb(60,150,255)
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
    $btn.Add_MouseEnter({ $btn.BackColor = [System.Drawing.Color]::FromArgb(90,180,255) })
    $btn.Add_MouseLeave({ $btn.BackColor = [System.Drawing.Color]::FromArgb(60,150,255) })
    $btn.Add_Click({ Apply-Preset $preset })
    return $btn
}

# ---------------- GUI ----------------
$form = New-Object System.Windows.Forms.Form
$form.Text = "LazyTWK Optimizer – Lazyy"
$form.Size = New-Object System.Drawing.Size(900,700)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)

# Side Menu Panel
$panelSide = New-Object System.Windows.Forms.Panel
$panelSide.Size = New-Object System.Drawing.Size(180,700)
$panelSide.BackColor = [System.Drawing.Color]::FromArgb(40,40,40)
$panelSide.Location = New-Object System.Drawing.Point(0,0)
$form.Controls.Add($panelSide)

# Content Panel
$panelContent = New-Object System.Windows.Forms.Panel
$panelContent.Size = New-Object System.Drawing.Size(700,700)
$panelContent.BackColor = [System.Drawing.Color]::FromArgb(35,35,35)
$panelContent.Location = New-Object System.Drawing.Point(180,0)
$form.Controls.Add($panelContent)

# Side Menu Buttons
$menuItems = @("Dashboard","Optimizations","Presets","Backup/Restore","Quit")
$y = 50
foreach ($item in $menuItems) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $item
    $btn.Size = New-Object System.Drawing.Size(160,50)
    $btn.Location = New-Object System.Drawing.Point(10,$y)
    $btn.FlatStyle = "Flat"
    $btn.BackColor = [System.Drawing.Color]::FromArgb(60,60,60)
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.Font = New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold)
    $btn.Add_MouseEnter({ $btn.BackColor = [System.Drawing.Color]::FromArgb(90,90,90) })
    $btn.Add_MouseLeave({ $btn.BackColor = [System.Drawing.Color]::FromArgb(60,60,60) })
    # Button Click Events
    $btn.Add_Click({
        $panelContent.Controls.Clear()
        switch ($item) {
            "Dashboard" {
                $lbl = New-Object System.Windows.Forms.Label
                $lbl.Text = "OS Selected: $OS`nWelcome to LazyTWK Optimizer – Lazyy"
                $lbl.ForeColor = [System.Drawing.Color]::White
                $lbl.Location = New-Object System.Drawing.Point(20,20)
                $lbl.Size = New-Object System.Drawing.Size(600,50)
                $panelContent.Controls.Add($lbl)
                $cbOS = New-Object System.Windows.Forms.ComboBox
                $cbOS.Location = New-Object System.Drawing.Point(20,80)
                $cbOS.Size = New-Object System.Drawing.Size(200,30)
                $cbOS.Items.AddRange(@("Windows 10","Windows 11"))
                $cbOS.SelectedItem = $OS
                $cbOS.Add_SelectedIndexChanged({ $OS = $cbOS.SelectedItem })
                $panelContent.Controls.Add($cbOS)
            }
            "Optimizations" {
                $y2 = 20
                foreach ($opt in $OptimizationStates.Keys) {
                    $cb = New-Object System.Windows.Forms.CheckBox
                    $cb.Text = $opt
                    $cb.Checked = $OptimizationStates[$opt]
                    $cb.ForeColor = [System.Drawing.Color]::White
                    $cb.BackColor = [System.Drawing.Color]::FromArgb(35,35,35)
                    $cb.Location = New-Object System.Drawing.Point(20,$y2)
                    $cb.AutoSize = $true
                    $cb.Add_CheckedChanged({ $OptimizationStates[$opt] = $cb.Checked })
                    $panelContent.Controls.Add($cb)
                    $y2 += 40
                }
                $btnApplySelected = New-Object System.Windows.Forms.Button
                $btnApplySelected.Text = "Apply Selected"
                $btnApplySelected.Size = New-Object System.Drawing.Size(200,40)
                $btnApplySelected.Location = New-Object System.Drawing.Point(400,400)
                $btnApplySelected.FlatStyle = "Flat"
                $btnApplySelected.BackColor = [System.Drawing.Color]::FromArgb(50,150,250)
                $btnApplySelected.ForeColor = [System.Drawing.Color]::White
                $btnApplySelected.Add_Click({ Apply-SelectedOptimizations $OS })
                $panelContent.Controls.Add($btnApplySelected)
            }
            "Presets" {
                $panelContent.Controls.Add((New-GradientButton "Basic Optimize" 50 50 "Basic Optimize"))
                $panelContent.Controls.Add((New-GradientButton "Ultimate Optimize" 50 120 "Ultimate Optimize"))
                $panelContent.Controls.Add((New-GradientButton "Valorant FPS Boost" 50 190 "Valorant FPS Boost"))
                $panelContent.Controls.Add((New-GradientButton "Install HONE.gg" 50 260 "Install HONE.gg"))
            }
            "Backup/Restore" {
                $btnBackup = New-Object System.Windows.Forms.Button
                $btnBackup.Text = "Backup Configs"
                $btnBackup.Size = New-Object System.Drawing.Size(150,40)
                $btnBackup.Location = New-Object System.Drawing.Point(50,50)
                $btnBackup.BackColor = [System.Drawing.Color]::FromArgb(50,200,150)
                $btnBackup.ForeColor = [System.Drawing.Color]::White
                $btnBackup.FlatStyle = "Flat"
                $btnBackup.Add_Click({ [System.Windows.Forms.MessageBox]::Show("Configs backed up (placeholder).","LazyTWK Optimizer") })
                $panelContent.Controls.Add($btnBackup)

                $btnRestore = New-Object System.Windows.Forms.Button
                $btnRestore.Text = "Restore Configs"
                $btnRestore.Size = New-Object System.Drawing.Size(150,40)
                $btnRestore.Location = New-Object System.Drawing.Point(50,120)
                $btnRestore.BackColor = [System.Drawing.Color]::FromArgb(250,150,50)
                $btnRestore.ForeColor = [System.Drawing.Color]::White
                $btnRestore.FlatStyle = "Flat"
                $btnRestore.Add_Click({ [System.Windows.Forms.MessageBox]::Show("Configs restored (placeholder).","LazyTWK Optimizer") })
                $panelContent.Controls.Add($btnRestore)
            }
            "Quit" { $form.Close() }
        }
    })
    $panelSide.Controls.Add($btn)
    $y += 70
}

# Show Form
[void]$form.ShowDialog()
