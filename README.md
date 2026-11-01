# Omarchy Dotfiles

<p align="center">
  <img src="https://img.shields.io/badge/Version-v4.3.0-00ff88?style=for-the-badge" alt="Version">
  <img src="https://img.shields.io/badge/Environment-Omarchy-00e5c3?style=for-the-badge" alt="Omarchy">
  <img src="https://img.shields.io/badge/WM-Hyprland-00ff88?style=for-the-badge" alt="Hyprland">
</p>

<p align="center">
  Personal Omarchy configuration featuring custom themes, a customized Quickshell bar, terminal styling and Hyprland window effects.
</p>

---

## Overview

This repository contains my personal **Omarchy dotfiles**, focused on creating a customized Linux desktop environment with a consistent visual identity.

It includes two different themes, custom Quickshell plugins, terminal configurations and Hyprland visual adjustments.

## Themes

### Color Theme

A colorful desktop setup with a custom palette designed to provide a clean and consistent appearance.

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

## Features

### Quickshell

Custom Quickshell bar with a collection of plugins and desktop integrations.

The bar is organized into three sections:

- **Left:** Menu, Dots, CPU, IP address and current target.
- **Center:** System updates and workspaces.
- **Right:** System tray, network, volume, battery and clock.

Custom plugins include:

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

Customized Hyprland window appearance designed to match both desktop themes.

- Transparent window styling.
- Blur effects for a modern glass-like appearance.
- Improved visual integration between windows, wallpaper and desktop elements.

<p align="center">
  <img src="https://github.com/user-attachments/assets/a1872526-3262-4bad-a668-96dd8dcb96b7" width="49%" alt="Hyprland window configuration">
  <img src="https://github.com/user-attachments/assets/4d356903-2557-40d2-a537-257d74603c89" width="49%" alt="Hyprland transparent windows with blur">
</p>

### Kitty

Custom Kitty terminal configuration for both themes, including matching colors and terminal appearance.

### Zsh

Customized Zsh configuration featuring:

- Custom prompt with Git branch information.
- Syntax highlighting and autosuggestions.
- Useful aliases and shell functions.
- `lsd` and `bat` integrations.
- Custom pentesting target management.

#### Target Management

The custom target functions allow you to manage your current pentesting target directly from the terminal.

```bash
settarget 10.10.11.100 HTB-Machine
```

Clear the current target:

```bash
cleartarget
```

## Repository Structure

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

## Installation

Clone the repository:

```bash
git clone https://github.com/MrCaste/Omarchy-dotfiles.git
cd Omarchy-dotfiles
```

Choose the theme you want to install.

### Dark Theme

```bash
mkdir -p ~/.config/omarchy ~/.config/kitty

cp -a DarkTheme/DarkOmarchy/. ~/.config/omarchy/
cp DarkTheme/kitty/kitty.conf ~/.config/kitty/kitty.conf
cp DarkTheme/.zshrc ~/.zshrc
```

### Color Theme

```bash
mkdir -p ~/.config/omarchy ~/.config/kitty

cp -a ColorTheme/ColorOmarchy/. ~/.config/omarchy/
cp ColorTheme/kitty/kitty.conf ~/.config/kitty/kitty.conf
cp ColorTheme/.zshrc ~/.zshrc
```

**Note:** These commands copy the selected configurations over existing files. Back up your current configuration before installing. Review any hardcoded paths in scripts and plugins and adapt them to your system.

## Requirements

- Omarchy Linux
- Hyprland
- Quickshell
- Kitty
- Zsh

Some custom plugins and shell functions may require additional dependencies.

## Releases

| Version | Description |
|---|---|
| **v4.3.0** | Transparent Hyprland windows and blur effects. |
| v4.2.0 | Previous configuration update. |
| v4.1.0 | Previous configuration update. |
| v4.0.0 | Previous configuration update. |
| v3.0.0 | Previous configuration update. |

## Credits

- [Omarchy](https://omarchy.org/)
- [Hyprland](https://hypr.land/)
- [Quickshell](https://quickshell.org/)

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/MrCaste">MrCaste</a>
</p>
