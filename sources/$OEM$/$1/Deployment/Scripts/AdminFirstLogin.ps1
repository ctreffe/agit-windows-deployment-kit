###############################################################################
#
# AGIT Deployment Kit
#
# Module      : AdminFirstLogin.ps1
# Version     : 1.0.0
# Windows     : Windows 11 Enterprise 25H2
#
# Author      : Christian Treffenstaedt
# Copyright   : (c) 2026 Christian Treffenstaedt
#
# Description :
# Runs once as Administrator and applies all configured deployment modules.
#
###############################################################################

$ErrorActionPreference = 'Continue'
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $scriptRoot 'Config.ps1')
. (Join-Path $scriptRoot 'Logging.ps1')
. (Join-Path $scriptRoot 'Common.ps1')

Start-AGITLogSection 'AdminFirstLogin'
Write-AGITLog -Level INFO -Message 'Applying administrator profile and system defaults.'

Invoke-AGITStep -Name 'Clear AutoLogon' -Critical -ScriptBlock { Clear-AGITAutoLogon }

$modules = @('Explorer.ps1','Taskbar.ps1','ContextMenu.ps1','Microsoft.ps1','Privacy.ps1','Security.ps1')
foreach ($module in $modules) {
    $path = Join-Path $scriptRoot $module
    Invoke-AGITStep -Name ("Run module {0}" -f $module) -ScriptBlock {
        if (Test-Path $path) { . $path } else { throw "Module not found: $path" }
    }
}

Invoke-AGITStep -Name 'Validation' -ScriptBlock { . (Join-Path $scriptRoot 'Validation.ps1') }
Write-AGITSummary -Status $(if ($Global:AGITLogCounters.ERROR -gt 0) { 'COMPLETED WITH ERRORS' } else { 'SUCCESS' })
