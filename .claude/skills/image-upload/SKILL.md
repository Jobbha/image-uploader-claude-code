---
name: image-upload
description: Grab an image from the Windows clipboard and analyze it. Use when the user says image upload, paste, screenshot, clipboard, or asks to look at something they copied.
---

Run this PowerShell command to grab the image from the user's Windows clipboard:

powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.claude\clipboard-grab.ps1"

If the output is a file path (not "NO_IMAGE"), read that image file. Briefly acknowledge what you see in one sentence, then wait for the user's instructions. Do NOT write a detailed description, table, or analysis. The user is sharing the image as context for their next message — treat it like they showed you their screen. Just confirm you see it and ask what they need, or if they included a message with the upload, respond to that.

If the output is "NO_IMAGE", tell the user no image was found in the clipboard and to copy an image first (e.g. Win+Shift+S).

$ARGUMENTS
