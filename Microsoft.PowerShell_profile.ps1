# Set the console encoding to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Import required modules
$modulesAImporter = @(
    'posh-git', 'Terminal-Icons', 'PSFzf'
)
foreach ($module in $modulesAImporter) {
    if (Get-Module -ListAvailable -Name $module) {
        Import-Module $module
    }
    else {
        Write-Warning "Le module $module n'est pas installé. Utilisez 'Install-Module $module' pour l'installer."
    }
}

# Configure Oh-My-Posh theme
$omp_config = Join-Path $PSScriptRoot ".\takuya.omp.json"
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\catppuccin_macchiato.omp.json" | Invoke-Expression

# Enable automated upgrades for Oh-My-Posh
$env:POSH_SETTINGS = @{
    auto_upgrade = $true
}

# Configure PSReadLine settings
$psReadLineSettings = @{
    EditMode                      = 'Emacs'
    BellStyle                     = 'None'
    PredictionSource              = 'History'
    HistorySearchCursorMovesToEnd = $true
    PredictionViewStyle           = 'ListView'
}
Set-PSReadLineOption @psReadLineSettings

# Set custom colors for PSReadLine
Set-PSReadLineOption -Colors @{
    InlinePrediction = '#2F7004'
}

# Configure keyboard shortcuts
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# Configure Fzf (Fuzzy Finder)
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Set environment variables
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

# Define aliases
$aliasesADefinir = @{
    vim   = 'nvim'
    ll    = 'ls'
    g     = 'git'
    grep  = 'findstr'
    tig   = 'C:\Program Files\Git\usr\bin\tig.exe'
    less  = 'C:\Program Files\Git\usr\bin\less.exe'
    touch = 'New-Item'
    open  = 'Invoke-Item'
    mkcd  = 'New-ItemAndEnter'
    du    = 'Get-DiskUsage'
    ff    = 'Find-File'
    top   = 'Get-TopProcesses'
    bak   = 'Backup-File'
    nf    = 'New-File'
    lsd   = 'Get-DetailedDirectory'
    sh    = 'Search-History'
    oe    = 'Open-Explorer'
}
foreach ($alias in $aliasesADefinir.GetEnumerator()) {
    Set-Alias -Name $alias.Key -Value $alias.Value
}

# Utility functions

# Function to get the path of a command
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Function to get public IP address
function Get-PubIP { 
    (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content 
}

# Fonction pour mettre à jour tous les paquets avec winget
function Update {
    winget upgrade --all --accept-package-agreements --accept-source-agreements
}

# Définir un alias pour la fonction de mise à jour
Set-Alias -Name u -Value Update


# Function to reload PowerShell profile
function Update-Profile {
    . $PROFILE
}

# Function to create a new directory and change to it
function mkcd {
    param([string]$path)
    New-Item -ItemType Directory -Path $path
    Set-Location $path
}

# Function to get disk usage information
function Get-DiskUsage {
    Get-WmiObject Win32_LogicalDisk | Select-Object DeviceID, @{Name = "Size(GB)"; Expression = { [math]::Round($_.Size / 1GB, 2) } }, @{Name = "FreeSpace(GB)"; Expression = { [math]::Round($_.FreeSpace / 1GB, 2) } }
}

# Function to find files by name
function Find-File {
    param([string]$name)
    Get-ChildItem -Recurse -Filter "*$name*" | Select-Object FullName
}

# Function to get top CPU-consuming processes
function Get-TopProcesses {
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU, WorkingSet
}

# Function to create a backup of a file
function Backup-File {
    param([string]$file)
    Copy-Item $file "$file.bak"
}

# Function to create a new file
function New-File {
    param([string]$name)
    New-Item -ItemType File -Name $name
}

# Function to get detailed directory listing
function Get-DetailedDirectory {
    Get-ChildItem | Select-Object Mode, LastWriteTime, Length, Name
}

# Function to search command history
function Search-History {
    param([string]$keyword)
    Get-History | Where-Object { $_.CommandLine -like "*$keyword*" }
}

# Function to open File Explorer in current directory
function Open-Explorer {
    explorer .
}

# Quick navigation function (z)
$global:ZDirs = @{}

function z {
    param(
        [Parameter(Position = 0)]
        [string]$Directory
    )

    # If no directory is provided, display all tracked directories
    if (-not $Directory) {
        $ZDirs.GetEnumerator() | Sort-Object Value -Descending | Format-Table @{l = 'Directory'; e = { $_.Key } }, @{l = 'Score'; e = { $_.Value } } -AutoSize
        return
    }

    # Find matching directories
    $matchingDirs = Get-ChildItem -Directory -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.FullName -like "*$Directory*" }

    if ($matchingDirs.Count -eq 0) {
        Write-Host "Aucun répertoire correspondant trouvé."
        return
    }

    # Choose the target directory
    if ($matchingDirs.Count -eq 1) {
        $targetDir = $matchingDirs[0].FullName
    }
    else {
        $targetDir = $matchingDirs | Sort-Object { $ZDirs[$_.FullName] } -Descending | Select-Object -First 1 | Select-Object -ExpandProperty FullName
    }

    # Change to the target directory and update its score
    Set-Location $targetDir
    if ($ZDirs.ContainsKey($targetDir)) {
        $ZDirs[$targetDir]++
    }
    else {
        $ZDirs[$targetDir] = 1
    }
}

# Update directory score on each directory change
Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    $currentDir = (Get-Location).Path
    if ($ZDirs.ContainsKey($currentDir)) {
        $ZDirs[$currentDir]++
    }
    else {
        $ZDirs[$currentDir] = 1
    }
}