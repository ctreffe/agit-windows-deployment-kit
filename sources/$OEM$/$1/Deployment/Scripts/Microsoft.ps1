###############################################################################
#
# AGIT Deployment Kit
#
# Module      : Microsoft.ps1
# Version     : 1.0.0
# Windows     : Windows 11 Enterprise 25H2
#
# Author      : Christian Treffenstaedt
# Copyright   : (c) 2026 Christian Treffenstaedt
#
# Description :
# Configures Microsoft application defaults without removing system components.
#
###############################################################################

Start-AGITLogSection 'Microsoft defaults'

if ($Global:AGITConfig.DisableOneDrive) {
    Set-AGITRegistryValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive' -Name 'DisableFileSyncNGSC' -Value 1 -Type DWord | Out-Null
    Set-AGITRegistryValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive' -Name 'DisableFileSync' -Value 1 -Type DWord | Out-Null
}

if ($Global:AGITConfig.DisableTeamsAutostart) {
    Remove-AGITRegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'com.squirrel.Teams.Teams' | Out-Null
    Remove-AGITRegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Teams' | Out-Null
    Remove-AGITRegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'MSTeams' | Out-Null
    Write-AGITLog -Level OK -Message 'Teams auto-start entries removed if present.'
}

if ($Global:AGITConfig.DisableCopilot) {
    Set-AGITRegistryValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot' -Name 'TurnOffWindowsCopilot' -Value 1 -Type DWord | Out-Null
    Set-AGITRegistryValue -Path 'HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot' -Name 'TurnOffWindowsCopilot' -Value 1 -Type DWord | Out-Null
}

if ($Global:AGITConfig.DisableConsumerFeatures) {
    Set-AGITRegistryValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsConsumerFeatures' -Value 1 -Type DWord | Out-Null
    Set-AGITRegistryValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableConsumerAccountStateContent' -Value 1 -Type DWord | Out-Null
}
