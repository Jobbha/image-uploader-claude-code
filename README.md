# Image Uploader for Claude Code

**Paste images from your clipboard directly into Claude Code.**

Claude Code is a powerful AI coding assistant that runs in your terminal — but terminals can't handle images. If you screenshot an error, a UI bug, or a chart, you have no way to show it to Claude.

This tool fixes that. Copy an image, type `image upload`, and Claude sees it.

---

## What You Need

Before installing, make sure you have:

1. **Windows 10 or 11** (this tool uses Windows-only clipboard APIs — Mac/Linux coming soon)
2. **Claude Code** installed and working. If you don't have it yet:
   - Install Node.js from [nodejs.org](https://nodejs.org) (LTS version)
   - Install Git from [git-scm.com](https://git-scm.com/downloads/win)
   - Open PowerShell and run: `npm install -g @anthropic-ai/claude-code`
   - You need a [Claude Pro, Max, or Team subscription](https://claude.ai) to use Claude Code
3. **An Anthropic account** — you already have one if you use Claude Code

No extra API keys needed. This runs through your existing Claude subscription.

---

## Installation

### Option A: One-command install (recommended)

1. Press the **Windows key**, type **PowerShell**, and open it
2. Copy this entire block and paste it in (right-click to paste):

```powershell
$d=Join-Path $env:USERPROFILE '.claude';$s=Join-Path $d 'skills' 'image-upload';New-Item -ItemType Directory -Path $s -Force|Out-Null;@'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$img = [System.Windows.Forms.Clipboard]::GetImage()
if ($null -eq $img) { Write-Host 'NO_IMAGE'; return }
$path = Join-Path $env:TEMP 'claude-clipboard.png'
$img.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
$img.Dispose()
Write-Host $path
'@|Set-Content (Join-Path $d 'clipboard-grab.ps1');@'
---
name: image-upload
description: Grab an image from the Windows clipboard and analyze it. Use when the user says image upload, paste, screenshot, clipboard, or asks to look at something they copied.
---

Run this PowerShell command to grab the image from the user's Windows clipboard:

powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.claude\clipboard-grab.ps1"

If the output is a file path (not "NO_IMAGE"), read that image file. Briefly acknowledge what you see in one sentence, then wait for the user's instructions. Do NOT write a detailed description, table, or analysis. The user is sharing the image as context for their next message — treat it like they showed you their screen. Just confirm you see it and ask what they need, or if they included a message with the upload, respond to that.

If the output is "NO_IMAGE", tell the user no image was found in the clipboard and to copy an image first (e.g. Win+Shift+S).

$ARGUMENTS
'@|Set-Content (Join-Path $s 'SKILL.md');Write-Host 'Done! Restart Claude Code, then type: image upload' -ForegroundColor Green
```

3. You should see: **"Done! Restart Claude Code, then type: image upload"**

### Option B: Clone this repo

```powershell
git clone https://github.com/YOUR_USERNAME/image-uploader-claude-code.git
cd image-uploader-claude-code
.\install.ps1
```

If you get a "script is not digitally signed" error, run this first:
```powershell
Unblock-File .\install.ps1
```

---

## How to Use

### Step 1: Copy an image to your clipboard

You can do this in several ways:
- **Screenshot**: Press `Win + Shift + S` and select an area
- **From browser**: Right-click any image and choose "Copy image"
- **From any app**: Use Ctrl+C on an image, or the app's copy function

### Step 2: Open Claude Code

Open your terminal (PowerShell, Cursor terminal, etc.) and run:
```
claude
```

### Step 3: Type "image upload"

In the Claude Code prompt, just type:

```
image upload
```

Claude will grab the image from your clipboard, confirm what it sees, and wait for your instructions.

You can also include context with the upload:

```
image upload the button is hidden behind the navbar
image upload match this design
image upload this is the error I'm getting
```

Other trigger words that also work: `paste`, `screenshot`, `clipboard`.

---

## How It Works

This tool installs two small files into your `~/.claude/` folder:

| File | What it does |
|---|---|
| `clipboard-grab.ps1` | Reads the image from your Windows clipboard and saves it as a temporary PNG file |
| `skills/image-upload/SKILL.md` | Tells Claude Code how to use the script — when you say "image upload", Claude runs the script and reads the resulting image |

When you type "image upload" in Claude Code:
1. Claude recognizes the skill from the description
2. It runs `clipboard-grab.ps1` which saves your clipboard image to a temp file
3. Claude reads that image file
4. Claude responds about what it sees

---

## Security and Privacy

This tool is designed to be safe and transparent:

- **No API keys** — none of your keys are stored, used, or referenced anywhere in the code
- **No network calls** — the script only accesses your local clipboard and saves to your local temp folder
- **No data leaves your machine** — the image goes from clipboard → temp file → Claude Code (which you already trust)
- **No elevated permissions** — runs as your normal user, no admin needed
- **Fully open source** — two small files, easy to read and verify yourself

**Privacy note:** The clipboard image is saved to your temp folder as `claude-clipboard.png`. It stays there until you paste another image (which overwrites it) or until you clear your temp folder. If you screenshot sensitive information, be aware this file exists. You can delete it anytime:
```powershell
Remove-Item "$env:TEMP\claude-clipboard.png" -ErrorAction SilentlyContinue
```

---

## Troubleshooting

**"Unknown skill: project:paste"**
- This means Claude Code hasn't picked up the new skill yet. Type `/exit`, then run `claude` again.

**"NO_IMAGE" every time**
- Make sure you copied an image, not text. Use `Win + Shift + S` to screenshot something, then try again.
- Some apps copy images in formats the clipboard can't read. Try screenshotting with `Win + Shift + S` as a test.

**"script is not digitally signed" error**
- Run: `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned` and type Y to confirm.
- Or run: `Unblock-File` on the specific script file.

**Claude Code doesn't react to "image upload"**
- Make sure the files are in the right place. Run this to check:
  ```powershell
  Test-Path "$env:USERPROFILE\.claude\skills\image-upload\SKILL.md"
  Test-Path "$env:USERPROFILE\.claude\clipboard-grab.ps1"
  ```
  Both should return `True`.
- Try typing the full command manually in Claude Code:
  ```
  run powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.claude\clipboard-grab.ps1" and read the image it outputs
  ```

**It worked before but stopped working**
- Claude Code may have updated. Re-run the installer to refresh the files.

---

## Uninstall

To remove completely:
```powershell
Remove-Item "$env:USERPROFILE\.claude\clipboard-grab.ps1" -Force
Remove-Item "$env:USERPROFILE\.claude\skills\image-upload" -Recurse -Force
Remove-Item "$env:TEMP\claude-clipboard.png" -ErrorAction SilentlyContinue
```

---

## Roadmap

- [ ] Mac support (using `osascript` / `pbpaste`)
- [ ] Linux support (using `xclip`)
- [ ] Claude Code plugin for one-command `/plugin install`
- [ ] Multi-image support
- [ ] Auto-cleanup of temp files

## Contributing

PRs welcome — especially for Mac/Linux support!

## License

MIT
