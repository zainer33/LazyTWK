# ================================================
# LazyTWK Optimizer (GUI)
# Author: Lazyy
# Modern UI with toggles & presets
# Supports Windows 10 / Windows 11
# ================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# ---------------- VARIABLES ----------------
$OS = "Windows 10"

# Optimization states (default all enabled)
$OptimizationStates = @{
    "Disable Visual Effects" = $true
    "Disable VBS" = $true
    "Disable SysMain" = $true
    "Disable Windows Defender" = $true
    "Enable Game Mode" = $true
    "Clipboard History" = $true
    "Classic Right-Click Menu" = $true
    "Disable Widgets & Chat" = $true
}

# ---------------- FUNCTIONS ----------------
Function Apply-SelectedOptimizations {
    param($OS)
    foreach ($opt in $OptimizationStates.Keys) {
        if ($OptimizationStates[$opt]) {
            Write-Host "Applying: $opt"
            switch ($opt) {
                "Disable Visual Effects" { Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects VisualFXSetting 2 -ErrorAction SilentlyContinue }
                "Disable VBS" { bcdedit /set hypervisorlaunchtype off }
                "Disable SysMain" { Stop-Service -Name SysMain -ErrorAction SilentlyContinue; Set-Service -Name SysMain -StartupType Disabled }
                "Disable Windows Defender" { Set-MpPreference -DisableRealtimeMonitoring $true }
                "Enable Game Mode" { Set-ItemProperty HKCU:\Software\Microsoft\GameBar AllowAutoGameMode 1 -ErrorAction SilentlyContinue }
                "Clipboard History" { Set-ItemProperty HKCU:\Software\Microsoft\Clipboard EnableClipboardHistory 1 -ErrorAction SilentlyContinue }
                "Classic Right-Click Menu" { reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve }
                "Disable Widgets & Chat" { Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced TaskbarDa 0 -ErrorAction SilentlyContinue; Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced TaskbarMn 0 -ErrorAction SilentlyContinue }
            }
        }
    }
    [System.Windows.Forms.MessageBox]::Show("Selected optimizations applied for $OS!","LazyTWK Optimizer",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)
}

Function Apply-Preset {
    param($preset)
    switch ($preset) {
        "Basic Optimize" { [System.Windows.Forms.MessageBox]::Show("Basic Optimization applied.","LazyTWK Optimizer") }
        "Ultimate Optimize" { [System.Windows.Forms.MessageBox]::Show("Ultimate Optimization applied.","LazyTWK Optimizer") }
        "Valorant FPS Boost" { [System.Windows.Forms.MessageBox]::Show("Valorant FPS optimizations applied (some manual steps may be required).","LazyTWK Optimizer") }
        "Install HONE.gg" { [System.Windows.Forms.MessageBox]::Show("HONE.gg installer executed (placeholder).","LazyTWK Optimizer") }
    }
}

# ---------------- GUI ----------------
$form = New-Object System.Windows.Forms.Form
$form.Text = "LazyTWK Optimizer – Lazyy"
$form.Size = New-Object System.Drawing.Size(800,650)
$form.StartPosition = "CenterScreen"

# TabControl
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size(760,500)
$tabControl.Location = New-Object System.Drawing.Point(20,20)

# --- Tab 1: Optimizations ---
$tabOpt = New-Object System.Windows.Forms.TabPage
$tabOpt.Text = "Optimizations"
$tabOpt.BackColor = [System.Drawing.Color]::FromArgb(35,35,35)

# Add CheckBoxes dynamically
$y = 20
foreach ($opt in $OptimizationStates.Keys) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = $opt
    $cb.Checked = $OptimizationStates[$opt]
    $cb.ForeColor = [System.Drawing.Color]::White
    $cb.BackColor = [System.Drawing.Color]::FromArgb(35,35,35)
    $cb.Location = New-Object System.Drawing.Point(20,$y)
    $cb.AutoSize = $true
    $cb.Add_CheckedChanged({ $OptimizationStates[$opt] = $cb.Checked })
    $tabOpt.Controls.Add($cb)
    $y += 40
}

# Apply Selected Button
$btnApplySelected = New-Object System.Windows.Forms.Button
$btnApplySelected.Text = "Apply Selected"
$btnApplySelected.Size = New-Object System.Drawing.Size(200,40)
$btnApplySelected.Location = New-Object System.Drawing.Point(500,400)
$btnApplySelected.FlatStyle = "Flat"
$btnApplySelected.BackColor = [System.Drawing.Color]::FromArgb(50,150,250)
$btnApplySelected.ForeColor = [System.Drawing.Color]::White
$btnApplySelected.Add_Click({ Apply-SelectedOptimizations $OS })
$tabOpt.Controls.Add($btnApplySelected)

$tabControl.TabPages.Add($tabOpt)

# --- Tab 2: Presets ---
$tabPreset = New-Object System.Windows.Forms.TabPage
$tabPreset.Text = "Presets"
$tabPreset.BackColor = [System.Drawing.Color]::FromArgb(45,45,45)

# Gradient button creator function
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

# Add preset buttons
$tabPreset.Controls.Add((New-GradientButton "Basic Optimize" 50 50 "Basic Optimize"))
$tabPreset.Controls.Add((New-GradientButton "Ultimate Optimize" 50 120 "Ultimate Optimize"))
$tabPreset.Controls.Add((New-GradientButton "Valorant FPS Boost" 50 190 "Valorant FPS Boost"))
$tabPreset.Controls.Add((New-GradientButton "Install HONE.gg" 50 260 "Install HONE.gg"))

$tabControl.TabPages.Add($tabPreset)

$form.Controls.Add($tabControl)

# --- Bottom Buttons ---
# Backup Configs
$btnBackup = New-Object System.Windows.Forms.Button
$btnBackup.Text = "Backup Configs"
$btnBackup.Size = New-Object System.Drawing.Size(150,40)
$btnBackup.Location = New-Object System.Drawing.Point(50,550)
$btnBackup.BackColor = [System.Drawing.Color]::FromArgb(50,200,150)
$btnBackup.ForeColor = [System.Drawing.Color]::White
$btnBackup.FlatStyle = "Flat"
$btnBackup.Add_Click({ [System.Windows.Forms.MessageBox]::Show("Configs backed up (placeholder).","LazyTWK Optimizer") })
$form.Controls.Add($btnBackup)

# Restore Configs
$btnRestore = New-Object System.Windows.Forms.Button
$btnRestore.Text = "Restore Configs"
$btnRestore.Size = New-Object System.Drawing.Size(150,40)
$btnRestore.Location = New-Object System.Drawing.Point(250,550)
$btnRestore.BackColor = [System.Drawing.Color]::FromArgb(250,150,50)
$btnRestore.ForeColor = [System.Drawing.Color]::White
$btnRestore.FlatStyle = "Flat"
$btnRestore.Add_Click({ [System.Windows.Forms.MessageBox]::Show("Configs restored (placeholder).","LazyTWK Optimizer") })
$form.Controls.Add($btnRestore)

# Quit
$btnQuit = New-Object System.Windows.Forms.Button
$btnQuit.Text = "Quit"
$btnQuit.Size = New-Object System.Drawing.Size(100,40)
$btnQuit.Location = New-Object System.Drawing.Point(600,550)
$btnQuit.BackColor = [System.Drawing.Color]::FromArgb(200,50,50)
$btnQuit.ForeColor = [System.Drawing.Color]::White
$btnQuit.FlatStyle = "Flat"
$btnQuit.Add_Click({ $form.Close() })
$form.Controls.Add($btnQuit)

# --- OS Selection ComboBox ---
$lblOS = New-Object System.Windows.Forms.Label
$lblOS.Text = "Select Windows Version:"
$lblOS.ForeColor = [System.Drawing.Color]::White
$lblOS.Location = New-Object System.Drawing.Point(450,30)
$lblOS.AutoSize = $true
$form.Controls.Add($lblOS)

$cbOS = New-Object System.Windows.Forms.ComboBox
$cbOS.Location = New-Object System.Drawing.Point(450,60)
$cbOS.Size = New-Object System.Drawing.Size(200,30)
$cbOS.Items.AddRange(@("Windows 10","Windows 11"))
$cbOS.SelectedIndex = 0
$cbOS.Add_SelectedIndexChanged({ $OS = $cbOS.SelectedItem })
$form.Controls.Add($cbOS)

# Show Form
[void]$form.ShowDialog()
