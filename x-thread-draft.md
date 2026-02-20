# X Thread Draft — Image Uploader for Claude Code

## Tweet 1 (Hook)

Claude Code can't see images. Paste a screenshot and... nothing. It gets dropped.

I built a fix. Two files, zero dependencies, 30 seconds to install.

Type "image upload" and Claude Code grabs your clipboard image instantly.

🧵

## Tweet 2 (Problem)

The problem: Claude Code runs in a terminal. Terminals are text-only.

Screenshot an error, a UI bug, a chart — you can't show it to Claude.

You end up having to describe things in words that would take 2 seconds to see.

## Tweet 3 (Solution)

The fix: a Claude Code skill that taps into Windows .NET clipboard APIs.

It grabs your image, saves it as PNG, and feeds it to Claude — all inside your existing session.

No extra API costs. Uses your Claude subscription.

## Tweet 4 (Demo)

Here's the whole workflow:

1. Win+Shift+S → screenshot something
2. Type "image upload" in Claude Code
3. Claude sees it and responds

[attach demo screenshot/video here]

## Tweet 5 (Install)

30-second install. Open PowerShell, paste one block, done.

No npm. No pip. No dependencies. Just two tiny files.

github.com/YOUR_USERNAME/image-uploader-claude-code

## Tweet 6 (CTA)

Coming soon:
→ Mac support
→ Linux support
→ Claude Code plugin marketplace

Star the repo. PRs welcome.

@AnthropicAI @alexalbert__
