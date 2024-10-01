# Install
Clone the repository inside the `$PROFILE` directory (Documents/PowerShell)

set the [nerd fonts](https://www.nerdfonts.com/font-downloads) in your terminal


```
# installing scoop
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

# installing oh-my-posh
```
winget install JanDeDobbeleer.OhMyPosh -s winget
```

# installing fzf with scoop
```
scoop install fzf
```


# Custom PowerShell Configuration

This `Microsoft.PowerShell_profile.ps1` file contains a personalized configuration for PowerShell, offering an enhanced user experience with various features and customizations.

## Table of Contents

1. [Key Features](#key-features)
2. [Notable Functions](#notable-functions)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Customization](#customization)
6. [Modules](#modules)
7. [Aliases](#aliases)
8. [Keyboard Shortcuts](#keyboard-shortcuts)

## Key Features

1. **UTF-8 Encoding**: Sets console encoding to UTF-8 for better character support.
2. **Module Auto-Import**: Automatically imports useful modules like `posh-git`, `Terminal-Icons`, and `PSFzf`.
3. **Oh-My-Posh Theme**: Configures an Oh-My-Posh theme for a customized prompt.
4. **PSReadLine Configuration**: Customizes PSReadLine options for an improved command-line experience.
5. **Keyboard Shortcuts**: Defines useful keyboard shortcuts for navigation and editing.
6. **Fzf Integration**: Configures Fzf (Fuzzy Finder) for quick history and file searching.
7. **Custom Aliases**: Defines numerous aliases for frequently used commands.
8. **Utility Functions**: Includes several helpful functions for common tasks.

## Notable Functions

- `which`: Finds the path of a command.
- `Get-PubIP`: Retrieves the public IP address.
- `Update`: Updates all packages using winget.
- `mkcd`: Creates a new directory and changes to it.
- `z`: Quick navigation function based on directory usage frequency.
- `Get-DiskUsage`: Displays disk usage information.
- `Find-File`: Searches for files by name.
- `Get-TopProcesses`: Shows top CPU-consuming processes.
- `Backup-File`: Creates a backup of a specified file.
- `Search-History`: Searches command history for a keyword.

## Installation

1. Clone this repository or download the `Microsoft.PowerShell_profile.ps1` file.
2. Place the file in your PowerShell profile directory (typically `$HOME\Documents\PowerShell`).
3. If you have an existing profile, you may want to merge the contents of this file with your current profile.

## Usage

The profile will automatically load when you start PowerShell. To reload the profile without restarting PowerShell, use the `Update-Profile` function.

## Customization

Feel free to modify this file according to your needs and preferences. You can add, remove, or modify functions, aliases, or configurations to tailor the environment to your workflow.

## Modules

This profile attempts to import the following modules:
- posh-git
- Terminal-Icons
- PSFzf

Ensure these modules are installed for full functionality.

## Aliases

Some of the defined aliases include:
- `vim` for `nvim`
- `ll` for `ls`
- `g` for `git`
- `u` for the `Update` function

Check the profile for a complete list of aliases.

## Keyboard Shortcuts

- `Ctrl+d`: Delete character
- `Ctrl+f`: Fzf provider chord
- `Ctrl+r`: Fzf reverse history search
- Up/Down Arrows: History search

For a complete list of keyboard shortcuts and their functions, refer to the profile file.

