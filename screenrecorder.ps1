# Requires: FFmpeg installed and in PATH

Add-Type -AssemblyName System.Windows.Forms

# Output folder
$outputFolder = Read-Host "Enter output folder path (default: current folder)"
if ([string]::IsNullOrEmpty($outputFolder)) { $outputFolder = Get-Location }

# File name
$fileName = Read-Host "Enter base file name (example: recording)"
$filePath = Join-Path $outputFolder "$fileName.mp4"

# Screen resolution
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

# Audio device (optional)
$audioDevice = Read-Host "Enter audio device name (leave empty for no audio)"

# FFmpeg command
if ([string]::IsNullOrEmpty($audioDevice)) {
    $ffmpegCmd = "ffmpeg -y -f gdigrab -framerate 30 -i desktop -video_size ${screenWidth}x${screenHeight} `"$filePath`""
} else {
    $ffmpegCmd = "ffmpeg -y -f gdigrab -framerate 30 -i desktop -f dshow -i audio=`"$audioDevice`" `"$filePath`""
}

Write-Host "Recording started. Press Ctrl+C to stop."
Write-Host "Tip: Press 's' then Enter anytime to take a screenshot."

# Function to take screenshot
function Take-Screenshot {
    $bitmap = New-Object System.Drawing.Bitmap $screenWidth, $screenHeight
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen(0,0,0,0,$bitmap.Size)
    $screenshotPath = Join-Path $outputFolder ("screenshot_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".png")
    $bitmap.Save($screenshotPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()
    Write-Host "Screenshot saved: $screenshotPath"
}

# Start FFmpeg in background
$ffmpegProcess = Start-Process -FilePath "ffmpeg" -ArgumentList $ffmpegCmd -NoNewWindow -PassThru

# Hotkey loop
while (!$ffmpegProcess.HasExited) {
    $key = Read-Host ""
    switch ($key.ToLower()) {
        "s" { Take-Screenshot }
        "m" {
            Write-Host "Mute/unmute not supported in real-time via PowerShell. Use audio device control instead."
        }
    }
}

Write-Host "Recording stopped. File saved at $filePath"
