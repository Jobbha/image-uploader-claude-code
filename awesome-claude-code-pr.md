# PR for awesome-claude-code

## Line to add (under Slash Commands section)

```markdown
[Image Uploader](https://github.com/YOUR_USERNAME/image-uploader-claude-code) by YOUR_USERNAME - Paste clipboard images into Claude Code. Grabs images from the Windows clipboard via .NET APIs so Claude can see screenshots, error messages, charts, and more. One-command install, zero dependencies.
```

## PR title

Add Image Uploader — clipboard image paste for Claude Code

## PR description

Claude Code runs in a terminal which can't receive pasted images. Image Uploader is a lightweight skill that bridges this gap using Windows .NET clipboard APIs (System.Windows.Forms.Clipboard).

Features:
- Two files, zero dependencies
- One-command install (PowerShell paste block)
- Works globally across all projects
- Triggers on natural language: "image upload", "paste", "screenshot"
- No extra API costs — uses existing Claude subscription
- No API keys stored or referenced
- No network calls — fully local
