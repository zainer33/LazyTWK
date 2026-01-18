Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Global variables
$ffmpegProcess = $null
$outputFolder = Get-Location
$audioDevice = ""
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

# Create form
$form = New-Object System.Windows.Forms.Form
$form.Text = "LazyScreenRecorder"
$form.Size = New-Object System.Drawing.Size(400,300)
$form.StartPosition = "CenterScreen"

# Start/Stop Button
$btnStartStop = New-Object System.Windows.Forms.Button
$btnStartStop.Location = New-Object System.Drawing.Point(50,30)
$btnStartStop.Size = New-Object System.Drawing.Size(120,40)
$btnStartStop.Text = "Start Recording"
$form.Controls.Add($btnStartStop)

# Screenshot Button
$btnScreenshot = New-Object System.Windows.Forms.Button
$btnScreenshot.Location = New-Object System.Drawing.Point(200,30)
$btnScreenshot.Size = New-Object System.Drawing.Size(120,40)
$btnScreenshot.Text = "Screenshot"
$form.Controls.Add($btnScreenshot)

# Output Folder Label & Button
$lblFolder = New-Object System.Windows.Forms.Label
$lblFolder.Location = New-Object System.Drawing.Point(50,90)
$lblFolder.Size = New-Object System.Drawing.Size(300,20)
$lblFolder.Text = "Output Folder: $outputFolder"
$form.Controls.Add($lblFolder)

$btnFolder = New-Object System.Windows.Forms.Button
$btnFolder.Location = New-Object System.Drawing.Point(50,120)
$btnFolder.Size = New-Object System.Drawing.Size(120,30)
$btnFolder.Text = "Change Folder"
$form.Controls.Add($btnFolder)

# Event Handlers

# Start/Stop Recording
$btnStartStop.Add_Click({
    if ($btnStartStop.Text -eq "Start Recording") {
        $fileName = "recording_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".mp4"
        $filePath = Join-Path $outputFolder $fileName

        if ([string]::IsNullOrEmpty($audioDevice)) {
            $ffmpegCmd = "-y -f gdigrab -framerate 30 -i desktop -video_size ${screenWidth}x${screenHeight} `"$filePath`""
        } else {
            $ffmpegCmd = "-y -f gdigrab -framerate 30 -i desktop -f dshow -i audio=`"$audioDevice`" `"$filePath`""
        }

        $ffmpegProcess = Start-Process -FilePath "ffmpeg" -ArgumentList $ffmpegCmd -NoNewWindow -PassThru
        $btnStartStop.Text = "Stop Recording"
    } else {
        if ($ffmpegProcess -ne $null) {
            $ffmpegProcess.Kill()
            $ffmpegProcess = $null
        }
        $btnStartStop.Text = "Start Recording"
        [System.Windows.Forms.MessageBox]::Show("Recording saved!")
    }
})

# Screenshot
$btnScreenshot.Add_Click({
    $bitmap = New-Object System.Drawing.Bitmap $screenWidth, $screenHeight
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen(0,0,0,0,$bitmap.Size)
    $screenshotPath = Join-Path $outputFolder ("screenshot_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".png")
    $bitmap.Save($screenshotPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()
    [System.Windows.Forms.MessageBox]::Show("Screenshot saved: $screenshotPath")
})

# Change Folder
$btnFolder.Add_Click({
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($fbd.ShowDialog() -eq "OK") {
        $outputFolder = $fbd.SelectedPath
        $lblFolder.Text = "Output Folder: $outputFolder"
    }
})

# Show form
$form.Topmost = $true
$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
