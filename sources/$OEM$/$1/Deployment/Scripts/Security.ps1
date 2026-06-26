###############################################################################
#
# AGIT Deployment Kit
#
# Module      : Security.ps1
# Version     : 1.0.0
# Windows     : Windows 11 Enterprise 25H2
#
# Author      : Christian Treffenstaedt
# Copyright   : (c) 2026 Christian Treffenstaedt
#
# Description :
# Applies security-related deployment defaults while keeping Defender, SmartScreen, and UAC unchanged.
#
###############################################################################

Start-AGITLogSection 'Security'

if ($Global:AGITConfig.DisableAutomaticDeviceEncryption) {
    Set-AGITRegistryValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\BitLocker' -Name 'PreventDeviceEncryption' -Value 1 -Type DWord | Out-Null
    Set-AGITRegistryValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\FVE' -Name 'PreventDeviceEncryption' -Value 1 -Type DWord | Out-Null
    Write-AGITLog -Level INFO -Message 'Automatic device encryption is prevented. BitLocker itself is not removed or disabled.'
}

Write-AGITLog -Level INFO -Message 'Defender, SmartScreen, and UAC are intentionally left unchanged.'
