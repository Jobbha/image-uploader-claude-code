#!/bin/bash
# ============================================================
#  Image Uploader for Claude Code — macOS Installer
#  Run: bash install.sh
# ============================================================

CLAUDE_DIR="$HOME/.claude"
SKILL_DIR="$CLAUDE_DIR/skills/image-upload"

mkdir -p "$SKILL_DIR"

# Clipboard grab script
cat > "$CLAUDE_DIR/clipboard-grab.sh" << 'GRAB'
#!/bin/bash
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
GRAB

chmod +x "$CLAUDE_DIR/clipboard-grab.sh"

# Skill definition
cat > "$SKILL_DIR/SKILL.md" << 'SKILL'
---
name: image-upload
description: Grab an image from the clipboard and analyze it. Use when the user says image upload, paste, screenshot, clipboard, or asks to look at something they copied.
---

Grab the user's clipboard image by detecting their OS and running the correct script:

**Windows:**
powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.claude\clipboard-grab.ps1"

**macOS:**
bash ~/.claude/clipboard-grab.sh

Run the appropriate command for the user's operating system. If you're unsure which OS, check with: uname -s (returns "Darwin" for macOS, or fails/returns something else on Windows).

If the output is a file path (not "NO_IMAGE"), read that image file. Briefly acknowledge what you see in one sentence, then wait for the user's instructions. Do NOT write a detailed description, table, or analysis. The user is sharing the image as context for their next message — treat it like they showed you their screen. Just confirm you see it and ask what they need, or if they included a message with the upload, respond to that.

If the output is "NO_IMAGE", tell the user no image was found in the clipboard and to copy an image first (Win+Shift+S on Windows, Cmd+Ctrl+Shift+4 on Mac, or copy from any app).

$ARGUMENTS
SKILL

echo ""
echo "  Image Uploader installed!"
echo ""
echo "  Next steps:"
echo "    1. If Claude Code is running, type /exit and run 'claude' again"
echo "    2. Copy an image (Cmd+Ctrl+Shift+4 to screenshot to clipboard)"
echo "    3. Type: image upload"
echo ""
