###############################################################################
#
# AGIT Deployment Kit
#
# Module      : FirstBoot.ps1
# Version     : 1.0.0
# Windows     : Windows 11 Enterprise 25H2
#
# Author      : Christian Treffenstaedt
# Copyright   : (c) 2026 Christian Treffenstaedt
#
# Description :
# Runs during the temporary Setup account logon and switches control to Administrator.
#
###############################################################################

$ErrorActionPreference = 'Stop'
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $scriptRoot 'Config.ps1')
. (Join-Path $scriptRoot 'Logging.ps1')
. (Join-Path $scriptRoot 'Common.ps1')

Start-AGITLogSection 'FirstBoot'
Write-AGITLog -Level INFO -Message ('Starting {0} version {1}' -f $Global:AGITConfig.ProjectName, $Global:AGITConfig.Version)

Invoke-AGITStep -Name 'Enable built-in Administrator' -Critical -ScriptBlock {
    net user Administrator /active:yes | Out-Null
}

Invoke-AGITStep -Name 'Set built-in Administrator password' -Critical -ScriptBlock {
    net user Administrator $Global:AGITConfig.AdminPassword | Out-Null
}

Invoke-AGITStep -Name 'Configure Administrator AutoLogon' -Critical -ScriptBlock {
    Set-AGITAutoLogon -Username 'Administrator' -Password $Global:AGITConfig.AdminPassword
}

Invoke-AGITStep -Name 'Register AdminFirstLogin RunOnce' -Critical -ScriptBlock {
    Register-AGITRunOnce -Name 'AGIT-AdminFirstLogin' -Command 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Deployment\Scripts\AdminFirstLogin.ps1'
}

Invoke-AGITStep -Name 'Remove temporary Setup account' -ScriptBlock {
    if (Test-AGITUserExists -UserName 'Setup') {
        net user Setup /delete | Out-Null
        Write-AGITLog -Level OK -Message 'Temporary Setup account removed.'
    } else {
        Write-AGITLog -Level INFO -Message 'Temporary Setup account already absent.'
    }
}

Write-AGITLog -Level INFO -Message 'Restarting computer to continue as built-in Administrator.'
shutdown.exe /r /t 5 /c "AGIT Deployment Kit: switching to Administrator" | Out-Null
