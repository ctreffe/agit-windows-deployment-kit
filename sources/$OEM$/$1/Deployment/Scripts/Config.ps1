###############################################################################
#
# AGIT Deployment Kit
#
# Module      : Config.ps1
# Version     : 1.0.0
# Windows     : Windows 11 Enterprise 25H2
#
# Author      : Christian Treffenstaedt
# Copyright   : (c) 2026 Christian Treffenstaedt
#
# Description :
# Central configuration file for credentials and module switches.
#
# IMPORTANT:
#   - Replace SetupPassword before deployment.
#   - Replace AdminPassword before deployment.
#   - SetupPassword must also be replaced twice in autounattend.xml because
#     Windows creates the temporary Setup account during OOBE before this
#     PowerShell configuration file is available.
#
# Security note:
#   Passwords are stored in clear text in this deployment package. Treat the USB
#   stick as sensitive administrative media.
#
###############################################################################

$Global:AGITConfig = @{
    ###########################################################################
    # Project metadata
    #
    # These values are used for logging, the deployment summary and validation.
    # Normally, you should not need to change them when preparing an installation
    # USB stick.
    ###########################################################################
    ProjectName    = 'AGIT Deployment Kit'
    Version        = '1.0.0'
    WindowsTarget  = 'Windows 11 Enterprise 25H2'
    Author         = 'Christian Treffenstaedt'
    LogFile        = 'C:\Windows\Temp\Deployment.log'
    DeploymentRoot = 'C:\Deployment'
    ScriptsRoot    = 'C:\Deployment\Scripts'

    ###########################################################################
    # Passwords
    #
    # SetupPassword
    #   Temporary password for the local Setup account created during OOBE.
    #   This account is used only to bootstrap the deployment. It is deleted
    #   automatically after the built-in Administrator has been configured.
    #
    #   IMPORTANT:
    #   This value must match the two CHANGE_ME_SETUP_PASSWORD entries in
    #   autounattend.xml. Windows creates the Setup account before PowerShell
    #   can read this Config.ps1 file.
    #
    # AdminPassword
    #   Password for the built-in local Administrator account. This is the
    #   account that remains after deployment and is used until the computer is
    #   joined to AD or otherwise managed.
    #
    # Security note:
    #   Both passwords are stored in clear text on the USB stick. Treat the USB
    #   stick as sensitive administrative media.
    ###########################################################################
    SetupPassword = 'CHANGE_ME_SETUP_PASSWORD'
    AdminPassword = 'CHANGE_ME_ADMIN_PASSWORD'

    ###########################################################################
    # Explorer and shell settings
    #
    # ShowFileExtensions
    #   Shows known file extensions such as .exe, .cmd, .ps1 and .txt.
    #   Recommended for administrators because it reduces ambiguity.
    #
    # ShowHiddenFiles
    #   Shows hidden files and folders in File Explorer.
    #
    # ExplorerOpenThisPC
    #   Opens File Explorer on "This PC" instead of the Windows 11 home/start
    #   view.
    #
    # ClassicContextMenu
    #   Enables the classic full Windows context menu instead of the shortened
    #   Windows 11 right-click menu for the Administrator profile.
    #
    # TaskbarLeftAligned
    #   Aligns taskbar icons to the left. Set to $false to keep the Windows 11
    #   centered default.
    #
    # DisableWidgets
    #   Hides/disables the Windows Widgets entry point.
    #
    # KeepSearchBox
    #   Documentation flag: the kit intentionally leaves the search box visible.
    #   This setting is kept for clarity and future expansion.
    ###########################################################################
    ShowFileExtensions  = $true
    ShowHiddenFiles     = $true
    ExplorerOpenThisPC  = $true
    ClassicContextMenu  = $true
    TaskbarLeftAligned  = $true
    DisableWidgets      = $true
    KeepSearchBox       = $true

    ###########################################################################
    # Microsoft defaults
    #
    # DisableOneDrive
    #   Prevents OneDrive file sync integration by policy-style registry values.
    #   OneDrive is not removed from Windows and can later be enabled by domain,
    #   GPO or Intune policy.
    #
    # DisableTeamsAutostart
    #   Removes/blocks Teams auto-start entries for the Administrator profile.
    #   Teams is not uninstalled.
    #
    # DisableCopilot
    #   Disables Windows Copilot by policy-style registry values and hides its
    #   taskbar entry where applicable.
    #
    # DisableConsumerFeatures
    #   Disables Microsoft consumer suggestions/features where supported by
    #   policy-style registry values.
    ###########################################################################
    DisableOneDrive       = $true
    DisableTeamsAutostart = $true
    DisableCopilot        = $true
    DisableConsumerFeatures = $true

    ###########################################################################
    # Privacy settings
    #
    # ReduceTelemetry
    #   Sets supported policy-style values to reduce diagnostic data collection.
    #   This is intentionally conservative and does not remove services or break
    #   Windows Update, Defender, SmartScreen or enterprise management.
    #
    # DisableAdvertisingId
    #   Disables the per-user advertising ID.
    #
    # DisableTipsAndSuggestions
    #   Reduces Windows tips, suggestions and similar recommendation surfaces.
    #
    # ReduceFeedbackPrompts
    #   Reduces feedback prompt frequency where supported.
    ###########################################################################
    ReduceTelemetry          = $true
    DisableAdvertisingId     = $true
    DisableTipsAndSuggestions = $true
    ReduceFeedbackPrompts    = $true

    ###########################################################################
    # Security-related settings
    #
    # DisableAutomaticDeviceEncryption
    #   Prevents Windows from automatically enabling device encryption during or
    #   shortly after setup. This does not remove BitLocker and does not prevent
    #   a later deliberate BitLocker rollout via AD, GPO, Intune or manual setup.
    #
    # The kit intentionally does NOT disable:
    #   - Microsoft Defender
    #   - SmartScreen
    #   - UAC
    #   - Windows Update
    ###########################################################################
    DisableAutomaticDeviceEncryption = $true
}
