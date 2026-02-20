#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');

const homeDir = os.homedir();
const claudeDir = path.join(homeDir, '.claude');
const skillDir = path.join(claudeDir, 'skills', 'image-upload');

// Create directories
fs.mkdirSync(skillDir, { recursive: true });

// Detect OS and write the correct clipboard script
const platform = os.platform();

if (platform === 'win32') {
  const script = `Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$img = [System.Windows.Forms.Clipboard]::GetImage()
if ($null -eq $img) { Write-Host 'NO_IMAGE'; return }
$path = Join-Path $env:TEMP 'claude-clipboard.png'
$img.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
$img.Dispose()
Write-Host $path
`;
  fs.writeFileSync(path.join(claudeDir, 'clipboard-grab.ps1'), script);
  console.log('  Wrote clipboard-grab.ps1');

} else if (platform === 'darwin') {
  const script = `#!/bin/bash
swift - <<'SWIFT'
import AppKit

let pb = NSPasteboard.general

if let data = pb.data(forType: .png) {
    try? data.write(to: URL(fileURLWithPath: "/tmp/claude-clipboard.png"))
    print("/tmp/claude-clipboard.png")
} else if let tiffData = pb.data(forType: .tiff),
          let rep = NSBitmapImageRep(data: tiffData),
          let pngData = rep.representation(using: .png, properties: [:]) {
    try? pngData.write(to: URL(fileURLWithPath: "/tmp/claude-clipboard.png"))
    print("/tmp/claude-clipboard.png")
} else {
    print("NO_IMAGE")
}
SWIFT
`;
  const scriptPath = path.join(claudeDir, 'clipboard-grab.sh');
  fs.writeFileSync(scriptPath, script);
  fs.chmodSync(scriptPath, '755');
  console.log('  Wrote clipboard-grab.sh');

} else {
  console.log('  Linux detected — clipboard support coming soon.');
  console.log('  For now, you can contribute at:');
  console.log('  https://github.com/Jobbha/image-uploader-claude-code');
  process.exit(0);
}

// Write SKILL.md (same for all platforms)
const skillMd = `---
name: image-upload
description: Grab an image from the clipboard and analyze it. Use when the user says image upload, paste, screenshot, clipboard, or asks to look at something they copied.
---

Grab the user's clipboard image by detecting their OS and running the correct script:

**Windows:**
powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\\.claude\\clipboard-grab.ps1"

**macOS:**
bash ~/.claude/clipboard-grab.sh

Run the appropriate command for the user's operating system. If you're unsure which OS, check with: uname -s (returns "Darwin" for macOS, or fails/returns something else on Windows).

If the output is a file path (not "NO_IMAGE"), read that image file. Briefly acknowledge what you see in one sentence, then wait for the user's instructions. Do NOT write a detailed description, table, or analysis. The user is sharing the image as context for their next message — treat it like they showed you their screen. Just confirm you see it and ask what they need, or if they included a message with the upload, respond to that.

If the output is "NO_IMAGE", tell the user no image was found in the clipboard and to copy an image first (Win+Shift+S on Windows, Cmd+Ctrl+Shift+4 on Mac, or copy from any app).

$ARGUMENTS
`;

fs.writeFileSync(path.join(skillDir, 'SKILL.md'), skillMd);
console.log('  Wrote SKILL.md');

// Done
console.log('');
console.log('  ✅ Image Uploader for Claude Code installed!');
console.log('');
console.log('  Next steps:');
console.log('    1. If Claude Code is running, type /exit and run "claude" again');
if (platform === 'win32') {
  console.log('    2. Copy an image (Win+Shift+S to screenshot)');
} else {
  console.log('    2. Copy an image (Cmd+Ctrl+Shift+4 to screenshot)');
}
console.log('    3. Type: image upload');
console.log('');
