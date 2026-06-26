###############################################################################
#
# AGIT Deployment Kit
#
# Module      : Explorer.ps1
# Version     : 1.0.0
# Windows     : Windows 11 Enterprise 25H2
#
# Author      : Christian Treffenstaedt
# Copyright   : (c) 2026 Christian Treffenstaedt
#
# Description :
# Configures Windows Explorer defaults for administrator workstations.
#
###############################################################################

Start-AGITLogSection 'Explorer'
$advanced = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'

if ($Global:AGITConfig.ShowFileExtensions) {
    Set-AGITRegistryValue -Path $advanced -Name 'HideFileExt' -Value 0 -Type DWord | Out-Null
}
if ($Global:AGITConfig.ShowHiddenFiles) {
    Set-AGITRegistryValue -Path $advanced -Name 'Hidden' -Value 1 -Type DWord | Out-Null
    Set-AGITRegistryValue -Path $advanced -Name 'ShowSuperHidden' -Value 0 -Type DWord | Out-Null
}
if ($Global:AGITConfig.ExplorerOpenThisPC) {
    Set-AGITRegistryValue -Path $advanced -Name 'LaunchTo' -Value 1 -Type DWord | Out-Null
}
