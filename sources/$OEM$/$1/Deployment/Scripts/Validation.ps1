###############################################################################
#
# AGIT Deployment Kit
#
# Module      : Validation.ps1
# Version     : 1.0.0
# Windows     : Windows 11 Enterprise 25H2
#
# Author      : Christian Treffenstaedt
# Copyright   : (c) 2026 Christian Treffenstaedt
#
# Description :
# Performs a lightweight self-test after deployment.
#
###############################################################################

Start-AGITLogSection 'Validation Report'
$checks = New-Object System.Collections.Generic.List[object]

function Add-Check {
    param([string]$Name, [bool]$Passed, [string]$Details = '')
    $status = if ($Passed) { 'PASS' } else { 'FAIL' }
    $checks.Add([pscustomobject]@{ Name = $Name; Status = $status; Details = $Details }) | Out-Null
    $level = if ($Passed) { 'OK' } else { 'WARNING' }
    Write-AGITLog -Level $level -Message ("Validation {0}: {1} {2}" -f $status, $Name, $Details)
}

try {
    $admin = Get-LocalUser -Name 'Administrator' -ErrorAction Stop
    Add-Check -Name 'Administrator account enabled' -Passed ($admin.Enabled -eq $true)
} catch { Add-Check -Name 'Administrator account enabled' -Passed $false -Details $_.Exception.Message }

Add-Check -Name 'Setup account removed' -Passed (-not (Test-AGITUserExists -UserName 'Setup'))

try {
    $wl = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
    Add-Check -Name 'AutoLogon disabled' -Passed ($wl.AutoAdminLogon -eq '0')
} catch { Add-Check -Name 'AutoLogon disabled' -Passed $false -Details $_.Exception.Message }

try {
    $adv = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    Add-Check -Name 'Taskbar left aligned' -Passed ($adv.TaskbarAl -eq 0)
    Add-Check -Name 'File extensions visible' -Passed ($adv.HideFileExt -eq 0)
    Add-Check -Name 'Hidden files visible' -Passed ($adv.Hidden -eq 1)
} catch { Add-Check -Name 'Explorer defaults' -Passed $false -Details $_.Exception.Message }

Add-Check -Name 'Classic context menu configured' -Passed (Test-Path 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32')
Add-Check -Name 'OneDrive policy configured' -Passed (Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive')
Add-Check -Name 'Copilot policy configured' -Passed (Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot')
Add-Check -Name 'Telemetry policy configured' -Passed (Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection')

$failCount = ($checks | Where-Object { $_.Status -eq 'FAIL' }).Count
if ($failCount -eq 0) {
    Write-AGITLog -Level OK -Message 'Validation completed without failed checks.'
} else {
    Write-AGITLog -Level WARNING -Message ("Validation completed with {0} failed check(s)." -f $failCount)
}
