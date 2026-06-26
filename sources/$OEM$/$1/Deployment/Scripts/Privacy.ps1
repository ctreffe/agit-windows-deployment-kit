###############################################################################
#
# AGIT Deployment Kit
#
# Module      : Privacy.ps1
# Version     : 1.0.0
# Windows     : Windows 11 Enterprise 25H2
#
# Author      : Christian Treffenstaedt
# Copyright   : (c) 2026 Christian Treffenstaedt
#
# Description :
# Applies conservative, policy-based privacy defaults.
#
###############################################################################

Start-AGITLogSection 'Privacy'

if ($Global:AGITConfig.ReduceTelemetry) {
    Set-AGITRegistryValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'AllowTelemetry' -Value 0 -Type DWord | Out-Null
    Set-AGITRegistryValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'DisableTelemetryOptInChangeNotification' -Value 1 -Type DWord | Out-Null
}

if ($Global:AGITConfig.DisableAdvertisingId) {
    Set-AGITRegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Name 'Enabled' -Value 0 -Type DWord | Out-Null
    Set-AGITRegistryValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo' -Name 'DisabledByGroupPolicy' -Value 1 -Type DWord | Out-Null
}

if ($Global:AGITConfig.DisableTipsAndSuggestions) {
    Set-AGITRegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338389Enabled' -Value 0 -Type DWord | Out-Null
    Set-AGITRegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338388Enabled' -Value 0 -Type DWord | Out-Null
    Set-AGITRegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-310093Enabled' -Value 0 -Type DWord | Out-Null
    Set-AGITRegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SystemPaneSuggestionsEnabled' -Value 0 -Type DWord | Out-Null
}

if ($Global:AGITConfig.ReduceFeedbackPrompts) {
    Set-AGITRegistryValue -Path 'HKCU:\Software\Microsoft\Siuf\Rules' -Name 'NumberOfSIUFInPeriod' -Value 0 -Type DWord | Out-Null
}
