#!/bin/bash
# Grab clipboard image on macOS and save as PNG
OUTPUT="/tmp/claude-clipboard.png"

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
