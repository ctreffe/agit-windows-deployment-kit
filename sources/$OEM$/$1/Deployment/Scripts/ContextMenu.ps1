###############################################################################
#
# AGIT Deployment Kit
#
# Module      : ContextMenu.ps1
# Version     : 1.0.0
# Windows     : Windows 11 Enterprise 25H2
#
# Author      : Christian Treffenstaedt
# Copyright   : (c) 2026 Christian Treffenstaedt
#
# Description :
# Restores the classic Windows 11 context menu for the Administrator profile.
#
###############################################################################

Start-AGITLogSection 'ContextMenu'
if ($Global:AGITConfig.ClassicContextMenu) {
    $path = 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32'
    if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
    Set-ItemProperty -Path $path -Name '(default)' -Value '' -ErrorAction SilentlyContinue
    Write-AGITLog -Level OK -Message 'Classic Windows 11 context menu enabled for current user.'
}
