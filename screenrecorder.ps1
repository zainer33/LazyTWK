Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName System.Drawing

# Global variables
$ffmpegProcess = $null
$outputFolder = [Environment]::GetFolderPath("Desktop")
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
$audioDevice = ""  # Set your audio device name here if needed
$recording = $false

# XAML UI (Bandicam-like layout)
$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="LazyyX Recorder" Height="350" Width="450" ResizeMode="NoResize" WindowStartupLocation="CenterScreen" Background="#222222">
    <Grid Margin="10">
        <TextBlock x:Name="StatusLabel" Text="Idle" Foreground="White" FontSize="16" HorizontalAlignment="Center" VerticalAlignment="Top" Margin="0,10,0,0"/>
        
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="0,50,0,0" Spacing="10">
            <Button x:Name="StartStopBtn" Content="Start Recording" Width="120" Height="40" Background="#FF3A3A" Foreground="White"/>
            <Button x:Name="ScreenshotBtn" Content="Screenshot" Width="120" Height="40" Background="#3A9EFF" Foreground="White"/>
        </StackPanel>

        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" VerticalAlignment="Bottom" Margin="0,0,0,30" Spacing="10">
            <Button x:Name="FolderBtn" Content="Output Folder" Width="120" Height="30" Background="#888888" Foreground="White"/>
            <TextBlock x:Name="FolderLabel" Text="$outputFolder" Foreground="White" Width="250" TextWrapping="Wrap"/>
        </StackPanel>

        <TextBlock x:Name="FPSLabel" Text="FPS: 0" Foreground="Lime" FontSize="14" HorizontalAlignment="Left" VerticalAlignment="Bottom" Margin="10,0,0,10"/>
    </Grid>
</Window>
"@

# Load XAML
$reader = (New-Object System.Xml.XmlNodeReader ([xml]$XAML))
$Window = [Windows.Markup.XamlReader]::Load($reader)

# Get controls
$StartStopBtn = $Window.FindName("StartStopBtn")
$ScreenshotBtn = $Window.FindName("ScreenshotBtn")
$FolderBtn = $Window.FindName("FolderBtn")
$FolderLabel = $Window.FindName("FolderLabel")
$StatusLabel = $Window.FindName("StatusLabel")
$FPSLabel = $Window.FindName("FPSLabel")

# Helper functions
function Take-Screenshot {
    Add-Type -AssemblyName System.Drawing
    $bmp = New-Object System.Drawing.Bitmap $screenWidth, $screenHeight
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CopyFromScreen(0,0,0,0,$bmp.Size)
    $filePath = Join-Path $outputFolder ("screenshot_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".png")
    $bmp.Save($filePath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose()
    [System.Windows.MessageBox]::Show("Screenshot saved:`n$filePath")
}

function Start-Recording {
    $global:recording = $true
    $fileName = "recording_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".mp4"
    $filePath = Join-Path $outputFolder $fileName
    if ([string]::IsNullOrEmpty($audioDevice)) {
        $args = "-y -f gdigrab -framerate 30 -i desktop -video_size ${screenWidth}x${screenHeight} `"$filePath`""
    } else {
        $args = "-y -f gdigrab -framerate 30 -i desktop -f dshow -i audio=`"$audioDevice`" `"$filePath`""
    }
    $global:ffmpegProcess = Start-Process ffmpeg -ArgumentList $args -NoNewWindow -PassThru
    $StatusLabel.Text = "Recording..."
    $StartStopBtn.Content = "Stop Recording"
}

function Stop-Recording {
    if ($ffmpegProcess -ne $null) { $ffmpegProcess.Kill(); $ffmpegProcess=$null }
    $global:recording = $false
    $StatusLabel.Text = "Idle"
    $StartStopBtn.Content = "Start Recording"
    [System.Windows.MessageBox]::Show("Recording saved!")
}

# Button events
$StartStopBtn.Add_Click({
    if (-not $recording) { Start-Recording } else { Stop-Recording }
})
$ScreenshotBtn.Add_Click({ Take-Screenshot })
$FolderBtn.Add_Click({
    $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($dlg.ShowDialog() -eq "OK") {
        $outputFolder = $dlg.SelectedPath
        $FolderLabel.Text = $outputFolder
    }
})

# Show window
$Window.ShowDialog() | Out-Null
