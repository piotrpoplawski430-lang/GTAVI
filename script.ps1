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
$percentText.Text = "0% ukończono"
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

for ($i = 0; $i -le 100; $i++) {
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
