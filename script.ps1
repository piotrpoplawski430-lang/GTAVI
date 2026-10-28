Clear-Host
Write-Host "GTA VI:" -ForegroundColor Cyan
Write-Host "Downloading GTA VI:" -ForegroundColor Yellow

$spinner = @('\', '|', '/', '-')

for ($p = 0; $p -le 100; $p++) {
    $spin = $spinner[$p % 4]
    $barLength = [math]::Floor($p / 5)
    $spaces = 20 - $barLength
    $bar = '=' * $barLength + ' ' * $spaces
    
    Write-Host "`r[$spin] $p% [$bar]" -NoNewline -ForegroundColor Cyan
    Start-Sleep -Seconds 3
}

Write-Host "`r[+] Downloading GTA VI Completed!                      " -ForegroundColor Green
Start-Sleep -Seconds 1

Write-Host "`nChecking Information About The System" -NoNewline
for ($i = 0; $i -le 10; $i++) {
    Write-Host "`rChecking Information About The System $($spinner[$i % 4])" -NoNewline -ForegroundColor Yellow
    Start-Sleep -Milliseconds 400
}
Write-Host "`rChecking Information About The System - DONE          " -ForegroundColor Green
Write-Host "`nInformation Checked:" -ForegroundColor Cyan

$cpu = (Get-CimInstance Win32_Processor).Name.Trim()
$gpu = (Get-CimInstance Win32_VideoController).Name
if ($gpu -is [array]) { $gpu = $gpu[0] }

$os = Get-CimInstance Win32_OperatingSystem
$totalRamGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 0)
$freeRamGB = [math]::Round($os.FreePhysicalMemory / 1MB, 1)

$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$totalDiskGB = [math]::Round($disk.Size / 1GB, 0)
$freeDiskGB = [math]::Round($disk.FreeSpace / 1GB, 0)

$components = @(
    "CPU Model - $cpu",
    "Graphics Card - $gpu",
    "Physical RAM - ${totalRamGB}GB Total (${freeRamGB}GB Free)",
    "System Drive C: - ${totalDiskGB}GB Total (${freeDiskGB}GB Free)",
    "DirectX Version - DirectX 12 Ultimate",
    "Operating System - $($os.Caption) ($($os.OSArchitecture))",
    "Shader Model 6.5 Support - Enabled",
    "Hardware Ray Tracing - Supported",
    "Storage Speed Protocol - NVMe / SSD Checked",
    "Display Resolution - Native Screen Resolution",
    "Audio Endpoint - Spatial Sound Enabled",
    "Network Adapter - Broadband Connection Active",
    "Vulkan API Compatibility - Verified",
    "Windows Subsystem For Games - Active",
    "Driver Signature Enforcement - Valid",
    "Kernel Security Check - Passed"
)

foreach ($comp in $components) {
    Start-Sleep -Milliseconds (Get-Random -Minimum 800 -Maximum 1500)
    Write-Host "$comp - " -NoNewline
    Write-Host "TRUE" -ForegroundColor Green
}

Write-Host "`nYour computer is ready for installing GTA VI" -ForegroundColor Cyan
Start-Sleep -Seconds 2

Write-Host "`nInstalling GTA VI:" -ForegroundColor Yellow

$targetCrashPercent = Get-Random -Minimum 21 -Maximum 58

for ($p = 0; $p -le 100; $p++) {
    $barLength = [math]::Floor($p / 5)
    $spaces = 20 - $barLength
    $bar = '=' * $barLength + ' ' * $spaces
    Write-Host "`rProgress: $p% [$bar]" -NoNewline
    
    if ($p -eq $targetCrashPercent) {
        Start-Sleep -Milliseconds 800
        break
    }
    
    Start-Sleep -Milliseconds (Get-Random -Minimum 80 -Maximum 200)
}

Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase

$bsodMain = @"
Komputer napotkał problem i musi zostać uruchomiony ponownie.
Zbieramy informacje o błędzie i uruchomimy komputer ponownie automatycznie.
"@
$bsodDetail = "Więcej informacji: https://windows.com/stopcode`nKod zatrzymania: MANUALLY_INITIATED_CRASH"

$window = New-Object System.Windows.Window
$window.WindowStyle = 'None'
$window.ResizeMode = 'NoResize'
$window.Topmost = $true
$window.WindowStartupLocation = 'CenterScreen'
$window.WindowState = 'Maximized'
$window.Background = New-Object System.Windows.Media.SolidColorBrush([System.Windows.Media.Color]::FromRgb(0,120,215))

$viewbox = New-Object System.Windows.Controls.Viewbox
$viewbox.Stretch = 'Uniform'

$rootGrid = New-Object System.Windows.Controls.Grid
$rootGrid.Width = 1920
$rootGrid.Height = 1080

$stack = New-Object System.Windows.Controls.StackPanel
$stack.HorizontalAlignment = 'Left'
$stack.VerticalAlignment = 'Top'
$stack.Margin = [System.Windows.Thickness]::new(120,120,0,0)

$face = New-Object System.Windows.Controls.TextBlock
$face.Text = ":("
$face.FontFamily = 'Segoe UI'
$face.FontSize = 320
$face.Foreground = [System.Windows.Media.Brushes]::White
$face.Margin = [System.Windows.Thickness]::new(0,0,0,40)
$stack.Children.Add($face)

$mainText = New-Object System.Windows.Controls.TextBlock
$mainText.Text = $bsodMain
$mainText.FontFamily = 'Segoe UI'
$mainText.FontSize = 44
$mainText.Foreground = [System.Windows.Media.Brushes]::White
$mainText.TextWrapping = 'Wrap'
$mainText.Width = 1400
$stack.Children.Add($mainText)

$percentText = New-Object System.Windows.Controls.TextBlock
$percentText.Text = "$targetCrashPercent% ukończono"
$percentText.FontFamily = 'Segoe UI'
$percentText.FontSize = 28
$percentText.Foreground = [System.Windows.Media.Brushes]::White
$percentText.Margin = [System.Windows.Thickness]::new(0,30,0,0)
$stack.Children.Add($percentText)

$detailText = New-Object System.Windows.Controls.TextBlock
$detailText.Text = $bsodDetail
$detailText.FontFamily = 'Segoe UI'
$detailText.FontSize = 22
$detailText.Foreground = [System.Windows.Media.Brushes]::White
$detailText.Margin = [System.Windows.Thickness]::new(0,80,0,0)
$stack.Children.Add($detailText)

$qr = New-Object System.Windows.Controls.Image
$qr.Source = New-Object System.Windows.Media.Imaging.BitmapImage([Uri]"https://upload.wikimedia.org/wikipedia/commons/7/7e/QR_code_for_mobile_English_Wikipedia.svg")
$qr.Width = 200
$qr.Height = 200
$qr.HorizontalAlignment = 'Left'
$qr.Margin = [System.Windows.Thickness]::new(120,820,0,0)

$rootGrid.Children.Add($stack)
$rootGrid.Children.Add($qr)
$viewbox.Child = $rootGrid
$window.Content = $viewbox

$window.Show()
[System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::None

$soundJob = Start-Job -ScriptBlock {
    while ($true) {
        [Console]::Beep(1200, 500)
    }
}

for ($i = $targetCrashPercent; $i -le 100; $i++) {
    $percentText.Text = "$i% ukończono"
    $window.Dispatcher.Invoke([Action]{} ,[System.Windows.Threading.DispatcherPriority]::Background)

    if ($i -in @(25, 50, 75, 99)) {
        $delay = Get-Random -Minimum 2.5 -Maximum 5.0
    } else {
        $delay = (Get-Random -Minimum 100 -Maximum 1200) / 1000
    }
    
    Start-Sleep -Seconds $delay
}

Start-Sleep -Seconds 3
Stop-Job $soundJob -ErrorAction SilentlyContinue
Remove-Job $soundJob -ErrorAction SilentlyContinue
[System.Windows.Input.Mouse]::OverrideCursor = $null
$window.Close()
