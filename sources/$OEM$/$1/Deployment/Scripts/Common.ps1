###############################################################################
#
# AGIT Deployment Kit
#
# Module      : Common.ps1
# Version     : 1.0.0
# Windows     : Windows 11 Enterprise 25H2
#
# Author      : Christian Treffenstaedt
# Copyright   : (c) 2026 Christian Treffenstaedt
#
# Description :
# Shared helper functions for registry, users, process execution, and validation.
#
###############################################################################

function Import-AGITCore {
    $scriptRoot = Split-Path -Parent $MyInvocation.PSCommandPath
    . (Join-Path $scriptRoot 'Config.ps1')
    . (Join-Path $scriptRoot 'Logging.ps1')
}

function Set-AGITRegistryValue {
    param(
        [string]$Path,
        [string]$Name,
        [object]$Value,
        [ValidateSet('String','ExpandString','DWord','QWord','Binary','MultiString')]
        [string]$Type = 'DWord',
        [string]$Description = ''
    )
    try {
        if (-not (Test-Path $Path)) {
            New-Item -Path $Path -Force | Out-Null
        }
        $current = $null
        try { $current = (Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop).$Name } catch {}
        if ($null -ne $current -and "$current" -eq "$Value") {
            Write-AGITLog -Level INFO -Message ("Registry already set: {0}\{1} = {2}" -f $Path, $Name, $Value)
            return $true
        }
        New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $Type -Force | Out-Null
        Write-AGITLog -Level OK -Message ("Registry set: {0}\{1} = {2}" -f $Path, $Name, $Value)
        return $true
    } catch {
        Write-AGITLog -Level ERROR -Message ("Registry write failed: {0}\{1} - {2}" -f $Path, $Name, $_.Exception.Message)
        return $false
    }
}

function Remove-AGITRegistryValue {
    param([string]$Path, [string]$Name)
    try {
        if (Test-Path $Path) {
            Remove-ItemProperty -Path $Path -Name $Name -Force -ErrorAction SilentlyContinue
            Write-AGITLog -Level OK -Message ("Registry value removed if present: {0}\{1}" -f $Path, $Name)
        } else {
            Write-AGITLog -Level INFO -Message ("Registry path not present, skipping remove: {0}" -f $Path)
        }
        return $true
    } catch {
        Write-AGITLog -Level WARNING -Message ("Registry value removal skipped: {0}\{1} - {2}" -f $Path, $Name, $_.Exception.Message)
        return $false
    }
}

function Set-AGITAutoLogon {
    param([string]$Username, [string]$Password)
    $winlogon = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
    Set-AGITRegistryValue -Path $winlogon -Name 'AutoAdminLogon' -Value '1' -Type String | Out-Null
    Set-AGITRegistryValue -Path $winlogon -Name 'DefaultUserName' -Value $Username -Type String | Out-Null
    Set-AGITRegistryValue -Path $winlogon -Name 'DefaultPassword' -Value $Password -Type String | Out-Null
    Set-AGITRegistryValue -Path $winlogon -Name 'ForceAutoLogon' -Value '0' -Type String | Out-Null
}

function Clear-AGITAutoLogon {
    $winlogon = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
    Set-AGITRegistryValue -Path $winlogon -Name 'AutoAdminLogon' -Value '0' -Type String | Out-Null
    Remove-AGITRegistryValue -Path $winlogon -Name 'DefaultPassword' | Out-Null
    Remove-AGITRegistryValue -Path $winlogon -Name 'ForceAutoLogon' | Out-Null
}

function Register-AGITRunOnce {
    param([string]$Name, [string]$Command)
    $runOnce = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce'
    Set-AGITRegistryValue -Path $runOnce -Name $Name -Value $Command -Type String | Out-Null
}

function Restart-AGITExplorer {
    try {
        Stop-Process -Name explorer -Force -ErrorAction Stop
        Start-Sleep -Seconds 2
        Start-Process explorer.exe
        Write-AGITLog -Level OK -Message 'Explorer restarted.'
    } catch {
        Write-AGITLog -Level WARNING -Message ("Explorer restart skipped. Changes will apply after next sign-in. {0}" -f $_.Exception.Message)
    }
}

function Test-AGITUserExists {
    param([string]$UserName)
    try {
        $null = Get-LocalUser -Name $UserName -ErrorAction Stop
        return $true
    } catch { return $false }
}

function Invoke-AGITStep {
    param([string]$Name, [scriptblock]$ScriptBlock, [switch]$Critical)
    Write-AGITLog -Level INFO -Message ("Starting step: {0}" -f $Name)
    try {
        & $ScriptBlock
        Write-AGITLog -Level OK -Message ("Step completed: {0}" -f $Name)
        return $true
    } catch {
        $level = if ($Critical) { 'ERROR' } else { 'WARNING' }
        Write-AGITLog -Level $level -Message ("Step failed: {0} - {1}" -f $Name, $_.Exception.Message)
        if ($Critical) { throw }
        return $false
    }
}
