### QUICKEST INSTALL (Windows or Mac)
```
npx image-uploader-claude-code
```

Then restart Claude Code and type **paste**.

### Or install manually:# Image Uploader for Claude Code

**Copy an image. Type `image upload` in Claude Code. It sees it.**

Claude Code runs in a terminal — terminals can't handle images. If you screenshot an error, a UI bug, or a chart, you have no way to show it to Claude.

This tool fixes that. Works on **Windows** and **macOS**.

---

## Setup

### Windows

Open PowerShell and run:

```powershell
git clone https://github.com/Jobbha/image-uploader-claude-code.git; cd image-uploader-claude-code; .\install.ps1
```

If you get a "script is not digitally signed" error, run `Unblock-File .\install.ps1` first.

### macOS

Open Terminal and run:

```bash
git clone https://github.com/Jobbha/image-uploader-claude-code.git && cd image-uploader-claude-code && bash install.sh
```

Requires Xcode Command Line Tools. If not installed, run `xcode-select --install` first.

---

Then restart Claude Code (`/exit` → `claude`).

---

## Usage

1. Copy an image to your clipboard:
   - **Windows**: `Win + Shift + S` to screenshot
   - **Mac**: `Cmd + Ctrl + Shift + 4` to screenshot to clipboard
   - **Any OS**: right-click an image in a browser → "Copy image"

2. In Claude Code, type:

```
image upload
```

Claude sees your image and waits for instructions. You can also add context:

```
image upload the button is behind the navbar
image upload match this design
image upload this is the error I'm getting
```

Other trigger words: `paste`, `screenshot`, `clipboard`.

---

## How It Works

Two small files in `~/.claude/`:

| File | What it does |
|---|---|
| `clipboard-grab.ps1` (Win) / `clipboard-grab.sh` (Mac) | Grabs clipboard image and saves as temp PNG |
| `skills/image-upload/SKILL.md` | Tells Claude Code to run the script and read the image |

- **No API keys** — uses your existing Claude subscription
- **No network calls** — everything runs locally
- **No dependencies** — uses built-in OS APIs
- **Fully open source** — easy to read and verify

---

## Troubleshooting

**"NO_IMAGE" every time**
- Make sure you copied an image, not text
- Windows: use `Win + Shift + S` to test
- Mac: use `Cmd + Ctrl + Shift + 4` (screenshots to clipboard, not file)

**Claude doesn't react to "image upload"**
- Make sure you restarted Claude Code after installing
- Check files exist: `ls ~/.claude/skills/image-upload/SKILL.md`

**Mac: "xcode-select: error"**
- Run `xcode-select --install` and try again

**Windows: "script is not digitally signed"**
- Run: `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned`

---

## Uninstall

**Windows:**
```powershell
Remove-Item "$env:USERPROFILE\.claude\clipboard-grab.ps1" -Force
Remove-Item "$env:USERPROFILE\.claude\skills\image-upload" -Recurse -Force
```

**macOS:**
```bash
rm ~/.claude/clipboard-grab.sh
rm -rf ~/.claude/skills/image-upload
```

---

## Roadmap

- [x] Windows support
- [x] macOS support
- [ ] Linux support (xclip)
- [ ] Multi-image support

## Contributing

PRs welcome — especially for Linux support!

## License

MIT
