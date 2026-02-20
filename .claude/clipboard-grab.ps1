Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$img = [System.Windows.Forms.Clipboard]::GetImage()
if ($null -eq $img) { Write-Host 'NO_IMAGE'; return }
$path = Join-Path $env:TEMP 'claude-clipboard.png'
$img.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
$img.Dispose()
Write-Host $path
