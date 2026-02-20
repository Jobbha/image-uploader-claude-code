# ============================================================
#  Image Uploader for Claude Code — Installer
#  
#  Run this in PowerShell:
#    .\install.ps1
# ============================================================

$claudeDir = Join-Path $env:USERPROFILE '.claude'
$skillsDir = Join-Path $claudeDir 'skills'
$skillDir = Join-Path $skillsDir 'image-upload'

New-Item -ItemType Directory -Path $skillDir -Force | Out-Null

# Clipboard grab script (local only — no network, no API keys)
@'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$img = [System.Windows.Forms.Clipboard]::GetImage()
if ($null -eq $img) { Write-Host 'NO_IMAGE'; return }
$path = Join-Path $env:TEMP 'claude-clipboard.png'
$img.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
$img.Dispose()
Write-Host $path
'@ | Set-Content (Join-Path $claudeDir 'clipboard-grab.ps1')

# Skill definition
@'
---
name: image-upload
description: Grab an image from the Windows clipboard and analyze it. Use when the user says image upload, paste, screenshot, clipboard, or asks to look at something they copied.
---

Run this PowerShell command to grab the image from the user's Windows clipboard:

powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.claude\clipboard-grab.ps1"

If the output is a file path (not "NO_IMAGE"), read that image file. Briefly acknowledge what you see in one sentence, then wait for the user's instructions. Do NOT write a detailed description, table, or analysis. The user is sharing the image as context for their next message — treat it like they showed you their screen. Just confirm you see it and ask what they need, or if they included a message with the upload, respond to that.

If the output is "NO_IMAGE", tell the user no image was found in the clipboard and to copy an image first (e.g. Win+Shift+S).

$ARGUMENTS
'@ | Set-Content (Join-Path $skillDir 'SKILL.md')

Write-Host ''
Write-Host '  Image Uploader for Claude Code installed!' -ForegroundColor Green
Write-Host ''
Write-Host '  What to do now:' -ForegroundColor White
Write-Host '    1. If Claude Code is running, type /exit and run "claude" again' -ForegroundColor White
Write-Host '    2. Copy an image (Win+Shift+S to screenshot)' -ForegroundColor White
Write-Host '    3. Type: image upload' -ForegroundColor Cyan
Write-Host ''
Write-Host '  Files installed to:' -ForegroundColor DarkGray
Write-Host "    $claudeDir\clipboard-grab.ps1" -ForegroundColor DarkGray
Write-Host "    $skillDir\SKILL.md" -ForegroundColor DarkGray
