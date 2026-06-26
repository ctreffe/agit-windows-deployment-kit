###############################################################################
#
# AGIT Deployment Kit
#
# Module      : Taskbar.ps1
# Version     : 1.0.0
# Windows     : Windows 11 Enterprise 25H2
#
# Author      : Christian Treffenstaedt
# Copyright   : (c) 2026 Christian Treffenstaedt
#
# Description :
# Configures Windows 11 taskbar defaults.
#
###############################################################################

Start-AGITLogSection 'Taskbar'
$advanced = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'

if ($Global:AGITConfig.TaskbarLeftAligned) {
    Set-AGITRegistryValue -Path $advanced -Name 'TaskbarAl' -Value 0 -Type DWord | Out-Null
}

if ($Global:AGITConfig.DisableWidgets) {
    Set-AGITRegistryValue -Path $advanced -Name 'TaskbarDa' -Value 0 -Type DWord | Out-Null
    Set-AGITRegistryValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Dsh' -Name 'AllowNewsAndInterests' -Value 0 -Type DWord | Out-Null
}

if ($Global:AGITConfig.KeepSearchBox) {
    Write-AGITLog -Level INFO -Message 'Search box configuration intentionally left unchanged.'
}

Restart-AGITExplorer
