###############################################################################
#
# AGIT Deployment Kit
#
# Module      : Logging.ps1
# Version     : 1.0.0
# Windows     : Windows 11 Enterprise 25H2
#
# Author      : Christian Treffenstaedt
# Copyright   : (c) 2026 Christian Treffenstaedt
#
# Description :
# Provides centralized logging, counters, and deployment summary output.
#
###############################################################################

if (-not $Global:AGITLogCounters) {
    $Global:AGITLogCounters = [ordered]@{
        INFO = 0
        OK = 0
        WARNING = 0
        ERROR = 0
    }
}

function Get-AGITLogFile {
    if ($Global:AGITConfig -and $Global:AGITConfig.LogFile) {
        return $Global:AGITConfig.LogFile
    }
    return 'C:\Windows\Temp\Deployment.log'
}

function Write-AGITLog {
    param(
        [ValidateSet('INFO','OK','WARNING','ERROR')]
        [string]$Level,
        [string]$Message
    )

    $logFile = Get-AGITLogFile
    $logDir = Split-Path -Path $logFile -Parent
    if (-not (Test-Path $logDir)) { New-Item -Path $logDir -ItemType Directory -Force | Out-Null }

    if ($Global:AGITLogCounters.Contains($Level)) { $Global:AGITLogCounters[$Level]++ }

    $line = '{0} [{1}] {2}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Level.PadRight(7), $Message
    Add-Content -Path $logFile -Value $line -Encoding UTF8
}

function Start-AGITLogSection {
    param([string]$Name)
    Write-AGITLog -Level INFO -Message ('--- {0} ---' -f $Name)
}

function Write-AGITSummary {
    param([string]$Status = 'SUCCESS')
    $lines = @(
        '',
        '============================================================',
        'AGIT Deployment Kit - Deployment Summary',
        '============================================================',
        ('Project        : {0}' -f $Global:AGITConfig.ProjectName),
        ('Version        : {0}' -f $Global:AGITConfig.Version),
        ('Windows target : {0}' -f $Global:AGITConfig.WindowsTarget),
        ('INFO           : {0}' -f $Global:AGITLogCounters.INFO),
        ('OK             : {0}' -f $Global:AGITLogCounters.OK),
        ('WARNING        : {0}' -f $Global:AGITLogCounters.WARNING),
        ('ERROR          : {0}' -f $Global:AGITLogCounters.ERROR),
        ('Status         : {0}' -f $Status),
        '============================================================'
    )
    foreach ($line in $lines) { Add-Content -Path (Get-AGITLogFile) -Value $line -Encoding UTF8 }
}
