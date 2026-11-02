<h1 align="center">🌿 Omarchy Dotfiles</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Version-v4.3.0-00ff88?style=for-the-badge" alt="Version">
  <img src="https://img.shields.io/badge/Environment-Omarchy-00e5c3?style=for-the-badge" alt="Omarchy">
  <img src="https://img.shields.io/badge/WM-Hyprland-00ff88?style=for-the-badge" alt="Hyprland">
  <img src="https://img.shields.io/badge/Bar-Quickshell-00e5c3?style=for-the-badge" alt="Quickshell">
  <img src="https://img.shields.io/badge/Shell-Zsh-00ff88?style=for-the-badge" alt="Zsh">
</p>

<p align="center">
  Personal Omarchy setup with two themes, a custom Quickshell bar,<br>
  a themed Kitty/Zsh environment and a pentesting-oriented workflow.
</p>

<p align="center">
  <a href="#-themes">Themes</a> •
  <a href="#-features">Features</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-repository-structure">Structure</a> •
  <a href="#-releases">Releases</a>
</p>

---

## 📖 Overview

This repository contains my personal **Omarchy dotfiles**: a customized Linux desktop with a consistent visual identity, built around Hyprland, Quickshell, Kitty and Zsh.

Highlights:

- 🎨 **Two themes**: a colorful one and a dark hacker-style one.
- 🧩 **Custom Quickshell plugins** (`caste.*`) for CPU, IP, pentesting target, workspaces, Spotify, Bluetooth and tray.
- 🪟 **Hyprland effects**: transparent windows with blur.
- 🐚 **Zsh setup** with a Git-aware prompt and target management for CTFs / HackTheBox.

## 🎨 Themes

### Color Theme

A colorful setup with a custom palette for a clean and consistent look.

<p align="center">
  <img src="https://github.com/user-attachments/assets/af8cf726-7e00-46c4-a113-f5476b8938c7" width="49%" alt="Color Theme desktop">
  <img src="https://github.com/user-attachments/assets/055c7745-3d4c-482d-80d9-b0f28438443f" width="49%" alt="Color Theme terminal">
</p>

### Dark Theme

A dark interface with green and cyan accents, inspired by hacking and cybersecurity aesthetics.

<p align="center">
  <img src="https://github.com/user-attachments/assets/ac11e975-cb18-4f9d-b151-b8c10abc142e" width="49%" alt="Dark Theme desktop">
  <img src="https://github.com/user-attachments/assets/dbadd17c-1f1a-4eb6-bec5-c771097d43dc" width="49%" alt="Dark Theme terminal">
</p>

## ✨ Features

### Quickshell bar

The bar is split into three sections:

| Section | Contents |
|---|---|
| **Left** | Menu, Dots, CPU, IP address, current target |
| **Center** | System updates, workspaces |
| **Right** | System tray, network, volume, battery, clock |

Custom plugins:

| Plugin | Description |
|---|---|
| `caste.cpu` | Displays CPU information. |
| `caste.ip` | Displays IP address information. |
| `caste.target` | Shows the current pentesting target. |
| `caste.workspaces` | Custom workspace integration. |
| `caste.spotify` | Spotify integration. |
| `caste.bluetooth` | Bluetooth integration. |
| `caste.tray` | Custom system tray integration. |

### Hyprland

Window styling tuned to match both themes:

- Transparent windows.
- Blur for a glass-like look.
- Better visual integration between windows, wallpaper and desktop elements.

<p align="center">
  <img src="https://github.com/user-attachments/assets/fc95a403-d4b1-4e27-8187-1dadbcfc14fb" width="49%" alt="Hyprland window configuration">
  <img src="https://github.com/user-attachments/assets/662dfd60-7749-42ad-bafe-bb2ced7fd79f" width="49%" alt="Hyprland transparent windows with blur">

  

</p>

### Kitty

Custom Kitty configuration for each theme, with matching colors and appearance.

### Zsh

- Custom prompt with Git branch information.
- Syntax highlighting and autosuggestions.
- Useful aliases and shell functions.
- `lsd` and `bat` integrations.
- Pentesting target management (see below).

#### 🎯 Target management

Set the current target. It shows up in the Quickshell bar through `caste.target`:

```bash
settarget 10.10.11.100 HTB-Machine
```

Clear it when you are done:

```bash
cleartarget
```

> [!NOTE]
> These helpers are meant for labs and authorized environments only (HackTheBox, CTFs, your own machines).

## 🚀 Installation

### 1. Requirements

- [Omarchy](https://omarchy.org/)
- [Hyprland](https://hypr.land/)
- [Quickshell](https://quickshell.org/)
- Kitty
- Zsh
- `lsd`, `bat`, `git`
- Zsh plugins: `zsh-syntax-highlighting`, `zsh-autosuggestions`

Some plugins (Spotify, Bluetooth, network) may need extra system tools.

### 2. Clone the repository

```bash
git clone https://github.com/MrCaste/Omarchy-dotfiles.git
cd Omarchy-dotfiles
```

### 3. Back up your current config

```bash
BACKUP=~/dotfiles-backup-$(date +%F)
mkdir -p "$BACKUP"
cp -a ~/.config/omarchy "$BACKUP/omarchy" 2>/dev/null
cp -a ~/.config/kitty   "$BACKUP/kitty"   2>/dev/null
cp -a ~/.zshrc          "$BACKUP/.zshrc"  2>/dev/null
```

### 4. Install a theme

<details open>
<summary><b>🌑 Dark Theme</b></summary>

```bash
mkdir -p ~/.config/omarchy ~/.config/kitty

cp -a DarkTheme/DarkOmarchy/. ~/.config/omarchy/
cp DarkTheme/kitty/kitty.conf ~/.config/kitty/kitty.conf
cp DarkTheme/.zshrc ~/.zshrc
```

</details>

<details>
<summary><b>🌈 Color Theme</b></summary>

```bash
mkdir -p ~/.config/omarchy ~/.config/kitty

cp -a ColorTheme/ColorOmarchy/. ~/.config/omarchy/
cp ColorTheme/kitty/kitty.conf ~/.config/kitty/kitty.conf
cp ColorTheme/.zshrc ~/.zshrc
```

</details>

### 5. Apply the changes

```bash
source ~/.zshrc
hyprctl reload
```

Restart Quickshell (or log out and back in) to load the plugins.

> [!WARNING]
> These commands **overwrite** existing files. Do the backup in step 3 first, and review any hardcoded paths in scripts and plugins (e.g. `/home/caste/...`) and adapt them to your system.

## 📁 Repository structure

```text
Omarchy-dotfiles/
├── ColorTheme/
│   ├── ColorOmarchy/
│   ├── kitty/
│   └── .zshrc
│
├── DarkTheme/
│   ├── DarkOmarchy/
│   ├── kitty/
│   └── .zshrc
│
└── README.md
```

## 🏷️ Releases

| Version | Description |
|---|---|
| **v4.3.0** | Transparent Hyprland windows and blur effects. |
| v4.2.0 | _Add a short summary of this release._ |
| v4.1.0 | _Add a short summary of this release._ |
| v4.0.0 | _Add a short summary of this release._ |
| v3.0.0 | _Add a short summary of this release._ |

See all versions in the [Releases page](https://github.com/MrCaste/Omarchy-dotfiles/releases).

## 🤝 Feedback

Found a bug or have a suggestion? Open an [issue](https://github.com/MrCaste/Omarchy-dotfiles/issues). These are personal dotfiles, so I can't promise they will work out of the box on every setup, but ideas are always welcome.

## 🙏 Credits

- [Omarchy](https://omarchy.org/)
- [Hyprland](https://hypr.land/)
- [Quickshell](https://quickshell.org/)

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/MrCaste">MrCaste</a>
</p>
