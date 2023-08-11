<#
.SYNOPSIS
    App Installer Tool
.DESCRIPTION
    App installer Tool installs various applications making it easy to automate the installartion of various tools for a windows machine.

    Option 1. Install General Apps (Utilities apps, easy of use apps)
    Option 2. Install Gaming Apps (Steam, Epic, Discord)
    Option 3. Install Developer specific Apps (IDE, tools, etc.)

.NOTES
    Author     Date       Status
    ---------- ---------- --------------
    Edwin Soto 04/28/2023 Initial Script
#>
function Show-Menu {
    param (
        [string]$Title = 'App Installer Tool'
    )
    Clear-host
    Write-Host
    Write-Host $Title -ForegroundColor Green
    Write-Host
    Write-Host "Version 1.0"
    Write-Host
    Write-Host "Options:"
    Write-Host "1. Install Default Apps" -ForegroundColor Cyan
    Write-Host "2. Install Gaming Apps" -ForegroundColor Cyan
    Write-Host "3. Install Development Apps" -ForegroundColor Cyan
    Write-Host "4. Install All Apps" -ForegroundColor Cyan
    Write-Host "Q. Quit"
    Write-Host
}

Function InstallAppList($appList) {

    Foreach ($app in $appList) {
        $listApp = winget list --exact -q $app.name
        if (![String]::Join("", $listApp).Contains($app.name)) {
            Write-host "Installing: " $app.name
            winget install -e -h --accept-source-agreements --accept-package-agreements --id $app.name 
        }
        else {
            Write-host "Skipping: " $app.name " (already installed)"
        }
    }
}

Function Get-GPU {
    $GPU = (Get-WmiObject Win32_VideoController).Name
    
    Write-Host 
    Write-Host "Found GPU: $GPU"
    Write-Host
    If ($GPU -like "*NVIDIA*") {
        $nvidiaApp = @(
            @{name = "Nvidia.GeForceNow" }
        )
        InstallAppList($nvidiaApp)
    }
    
    If ($GPU -like "*AMD*") {
        Write-Host "Please Install Required Software Independently"
        Write-Host
    }

    If ($GPU -like "*INTEL*") {
        Write-Host "Please Install Required Software Independently"
        Write-Host
    }
}

Function Install-DefaultApps {
    $defaultApps = @(
        @{name = "Dropbox.Dropbox" },
        @{name = "Google.Chrome" },
        @{name = "Greenshot.Greenshot" },
        @{name = "Microsoft.PowerShell" },
        @{name = "Microsoft.WindowsTerminal" },
        @{name = "Google.Chrome" },
        @{name = "WinDirStat.WinDirStat" },
        @{name = "Mozilla.Firefox" },
        @{name = "VideoLAN.VLC" },
        @{name = "voidtools.Everything" }
    )

    Write-Host
    Write-Host "Installing Default Applications"
    Write-Host 

    InstallAppList($defaultApps)
}

Function Install-GamingApps {
    $gamingApps = @(
        @{name = "EpicGames.EpicGamesLauncher" },
        @{name = "Valve.Steam" },
        @{name = "Discord.Discord" }
    )


    Write-Host
    Write-Host "Installing Gaming Applications"
    Write-Host

    InstallAppList($gamingApps)

    Get-GPU
}

Function Install-DevelopmentApps {
    $devApps = @(
        @{name = "Axosoft.GitKraken" },
        @{name = "Git.Git" },
        @{name = "JanDeDobbeleer.OhMyPosh" },
        @{name = "JohnMacFarlane.Pandoc" },
        @{name = "Microsoft.dotnet" },
        @{name = "Microsoft.PowerToys" },
        @{name = "Microsoft.SQLServerManagementStudio" }, 
        @{name = "Microsoft.SQLServer.2019.Express" },
        @{name = "Microsoft.VisualStudio.2022.Community" },
        @{name = "Microsoft.VisualStudioCode" },
        @{name = "Notepad++.Notepad++" },
        @{name = "OpenJS.NodeJS.LTS" },
        @{name = "WinSCP.WinSCP" },
        @{name = "Insomnia.Insomnia" },
        @{name = "Docker.DockerDesktop" },    
        @{name = "Rufus.Rufus" }

    )

    Write-Host
    Write-Host "Installing Development Applications"
    Write-Host 

    InstallAppList($devApps)
}

Function Install-AppInstaller {
    $appInstaller = Get-AppxPackage Microsoft.DesktopAppInstaller -ErrorAction SilentlyContinue
    if (!$appInstaller) {
        Write-Host "Microsoft App Installer is not installed. Installing..."
        Add-AppxPackage -Register "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\AppxManifest.xml" -DisableDevelopmentMode
    }
    else {
        Write-Host "Microsoft App Installer is already installed."
    }
}

do {

    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
            $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
            Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
            Exit
        }
    }

    Install-AppInstaller
    
    Show-Menu
    $selected = Read-Host "Please enter 1,2,3, or Q"

    switch ($selected) {
        '1' {

            Install-DefaultApps
        } '2' {
            Install-GamingApps
        } '3' {
            Install-DevelopmentApps
        }  '4' {
            Write-Host "Installing All Apps"
            Install-DefaultApps
            Install-GamingApps
            Install-DevelopmentApps
        }'q' {
            return
        }
    } pause
}
until ($selected -eq 'q')












