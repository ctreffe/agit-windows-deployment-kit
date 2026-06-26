# AGIT Deployment Kit

> **AI collaboration notice**  
> This project was conceived, designed, implemented and documented through an iterative collaboration between the repository maintainer (`ctreffe`) and ChatGPT (OpenAI).

> **Build once. Deploy consistently. Document everything.**

Version: **1.0.0**  
Target: **Windows 11 Enterprise 25H2**  
Validated ISO: `SW_DVD9_Win_Pro_11_25H2.8_64BIT_German_Pro_Ent_EDU_N_MLF_X24-31690`

AGIT Deployment Kit is a modular Windows 11 deployment package for creating a
clean local-administrator workstation from a Windows installation USB stick.

Version 1.0.0 is the first stable release of the AGIT Deployment Kit.
It is based on the validated 0.9.0 release-candidate build, which completed a
full clean deployment on physical hardware without warnings or errors. No
intentional deployment behavior changes were introduced after that validation.

## Who this is for

This kit is intended for IT administrators who need to install Windows 11
Enterprise from a trusted organizational ISO and want a predictable local setup
before the device is later joined to Active Directory, Entra ID, Intune or other
management.

You do **not** need to understand PowerShell internals to use the kit. For a
normal deployment, you mainly edit two files:

1. `autounattend.xml`
2. `sources/$OEM$/$1/Deployment/Scripts/Config.ps1`

## What the kit does

At a high level, the kit performs this workflow:

1. Windows Setup starts from the USB stick.
2. Windows 11 Enterprise is selected automatically.
3. Disk and partition selection remains manual for safety.
4. Windows OOBE is automated.
5. A temporary local administrator named `Setup` is created.
6. `Setup` signs in once and bootstraps the deployment.
7. The built-in local `Administrator` account is enabled and configured.
8. The temporary `Setup` account is removed.
9. The device restarts and signs in once as `Administrator`.
10. User and system configuration modules run.
11. AutoLogon is disabled again.
12. A deployment summary and validation report are written.

## What the kit deliberately does not do

The kit intentionally does **not**:

- wipe disks automatically;
- disable Microsoft Defender;
- disable SmartScreen;
- disable UAC;
- disable Windows Update;
- remove Windows system components;
- remove OneDrive, Teams or Copilot binaries;
- apply broad “debloat” or “privacy hardening” scripts.

The goal is a supportable administrator workstation, not an unsupported or
heavily modified Windows installation.

## Project principles

- Safety over automation.
- Disk and partition selection remains manual.
- Keep Windows supportable.
- Prefer Microsoft-supported policy-style configuration over aggressive hacks.
- Do not disable Defender, SmartScreen, UAC or Windows Update.
- Every module must be idempotent.
- Every module must log its actions.
- Cosmetic configuration failures should not break the deployment.
- No hidden magic: important decisions must be documented.

## Quick start

1. Create a Windows installation USB stick with Rufus.
2. Copy the contents of this package to the root of the USB stick.
3. Edit `autounattend.xml`.
   - Replace `CHANGE_ME_SETUP_PASSWORD` in both locations.
4. Edit `sources/$OEM$/$1/Deployment/Scripts/Config.ps1`.
   - Replace `CHANGE_ME_SETUP_PASSWORD`.
   - Replace `CHANGE_ME_ADMIN_PASSWORD`.
5. Boot the target system from the USB stick.
6. Select/delete/create the target partitions manually.
7. Let the deployment complete.
8. Review `C:\Windows\Temp\Deployment.log`.

## Rufus recommendations

Use Rufus with:

| Rufus setting | Recommended value |
| --- | --- |
| Partition scheme | **GPT** |
| Target system | **UEFI without CSM** |
| File system | Let Rufus decide |
| Windows customization options | **All unchecked** |

Rufus Windows customization checkboxes can create their own answer-file logic.
The AGIT Deployment Kit should be the only component customizing Windows Setup.

## Passwords

Two passwords are used.

| Password | Where to edit | Purpose | Exists after deployment? |
| --- | --- | --- | --- |
| `SetupPassword` | `autounattend.xml` and `Config.ps1` | Temporary bootstrap account used during OOBE | No, `Setup` is deleted |
| `AdminPassword` | `Config.ps1` | Built-in local Administrator account | Yes |

### SetupPassword

`SetupPassword` is used for the temporary local `Setup` account. Windows creates
this account during OOBE, before PowerShell scripts are available. For that
reason, the same placeholder must be replaced in **both** locations:

- `autounattend.xml`
- `Config.ps1`

Although the `Setup` account is temporary, it is a local administrator while it
exists. Do not leave placeholder passwords in real use.

### AdminPassword

`AdminPassword` is used for the built-in local `Administrator` account. This is
the account that remains after deployment and is intended for temporary local
administration until the device is joined to a domain or otherwise managed.

## Configuration file

Most behavior is controlled in:

```text
sources/$OEM$/$1/Deployment/Scripts/Config.ps1
```

Use `$true` to enable an option and `$false` to disable it.

The configuration file intentionally contains detailed comments. The table below
is a non-technical reference for administrators who want to understand the
available choices without reading PowerShell code.

## Configuration reference for administrators

### Explorer and shell

| Setting | Default | What it does | Why it is useful | When to set `$false` |
| --- | --- | --- | --- | --- |
| `ShowFileExtensions` | `$true` | Shows file extensions such as `.exe`, `.cmd`, `.ps1`, `.txt`. | Reduces ambiguity when working with installers and scripts. | Rarely; only if you want Windows defaults. |
| `ShowHiddenFiles` | `$true` | Shows hidden files and folders in File Explorer. | Useful for troubleshooting and administration. | If the device is for non-admin end users. |
| `ExplorerOpenThisPC` | `$true` | Opens File Explorer on “This PC”. | Gives quick access to drives and system locations. | If you prefer the Windows 11 Home view. |
| `ClassicContextMenu` | `$true` | Restores the full classic right-click menu. | Reduces clicks for administrative workflows. | If you want the modern Windows 11 context menu. |

### Taskbar

| Setting | Default | What it does | Why it is useful | When to set `$false` |
| --- | --- | --- | --- | --- |
| `TaskbarLeftAligned` | `$true` | Aligns taskbar icons to the left. | Familiar layout for many administrators. | If you prefer centered Windows 11 icons. |
| `DisableWidgets` | `$true` | Disables or hides Windows Widgets. | Removes a non-essential consumer entry point. | If users should have Widgets. |
| `KeepSearchBox` | `$true` | Documents that the search box is intentionally kept visible. | Makes the design decision explicit. | Currently this is documentation-only. |

### Microsoft defaults

| Setting | Default | What it does | What it does not do | Recommended |
| --- | --- | --- | --- | --- |
| `DisableOneDrive` | `$true` | Prevents OneDrive integration using policy-style registry values. | Does not uninstall OneDrive. | Yes, for local admin staging systems. |
| `DisableTeamsAutostart` | `$true` | Prevents Teams from starting automatically. | Does not uninstall Teams. | Yes. |
| `DisableCopilot` | `$true` | Disables Copilot using policy-style registry values and hides entry points where applicable. | Does not remove Windows components. | Yes, unless Copilot is required. |
| `DisableConsumerFeatures` | `$true` | Reduces Microsoft consumer suggestions and promoted experiences. | Does not remove apps aggressively. | Yes. |

### Privacy

| Setting | Default | What it does | Design note |
| --- | --- | --- | --- |
| `ReduceTelemetry` | `$true` | Reduces diagnostic data collection using conservative policy-style values. | Does not break Windows Update, Defender or enterprise management. |
| `DisableAdvertisingId` | `$true` | Disables the per-user advertising ID. | A low-risk privacy default. |
| `DisableTipsAndSuggestions` | `$true` | Reduces Windows tips and recommendations. | Keeps the UI cleaner. |
| `ReduceFeedbackPrompts` | `$true` | Reduces feedback prompt frequency where supported. | Avoids interruptions. |

### Security-related settings

| Setting | Default | What it does | What it does not do |
| --- | --- | --- | --- |
| `DisableAutomaticDeviceEncryption` | `$true` | Prevents Windows from automatically enabling device encryption during or shortly after setup. | Does not remove BitLocker and does not prevent later deliberate BitLocker rollout. |

The kit intentionally leaves these Windows security features unchanged:

- Microsoft Defender
- SmartScreen
- UAC
- Windows Update

## Recommended configuration profiles

### Default administrator staging profile

Use the defaults. This is the intended profile for preparing a device locally
before joining it to AD or another management platform.

### More Windows-standard profile

If you want a system closer to Windows 11 defaults, consider setting:

```powershell
ClassicContextMenu = $false
TaskbarLeftAligned = $false
ShowHiddenFiles    = $false
```

### End-user profile

This kit is not primarily designed as an end-user image, but if it is used as a
base for one, consider disabling administrator-oriented Explorer settings:

```powershell
ShowHiddenFiles    = $false
ShowFileExtensions = $true
ExplorerOpenThisPC = $false
```

## Expected workflow

1. Boot from the USB stick.
2. Windows Setup selects Windows 11 Enterprise automatically.
3. Disk/partition selection remains manual.
4. OOBE is automated.
5. Temporary `Setup` account logs in once.
6. Built-in `Administrator` is enabled and configured.
7. `Setup` is removed.
8. The system restarts and logs in as `Administrator` once.
9. User and system configuration modules run.
10. AutoLogon is disabled.
11. A validation report and deployment summary are written.

## Log file

Deployment log:

```text
C:\Windows\Temp\Deployment.log
```

Log levels:

| Level | Meaning |
| --- | --- |
| `INFO` | Normal progress or explanation |
| `OK` | Successful action |
| `WARNING` | Non-critical issue; deployment continues |
| `ERROR` | Critical issue |

A deployment is considered successful when the final summary reports:

```text
Status : SUCCESS
ERROR  : 0
```

## Validation report

At the end of deployment, the kit performs a self-check. It validates important
items such as:

- built-in Administrator account enabled;
- temporary `Setup` account removed;
- AutoLogon disabled;
- Explorer and taskbar defaults;
- classic context menu;
- OneDrive, Copilot and telemetry policy values.

Validation is intended as a quick operational confidence check. It does not
replace proper administrative review before handing a device to a user.

## Modules included

- Explorer defaults
- Taskbar defaults
- Classic Windows 11 context menu
- OneDrive policy
- Teams auto-start cleanup
- Copilot policy
- Conservative privacy defaults
- Automatic device encryption prevention
- Validation report

## Troubleshooting

### I am stuck in the Setup account

Check:

```text
C:\Windows\Temp\Deployment.log
```

If the log does not exist, `FirstBoot.ps1` probably did not start. Check that the
USB contains the `sources/$OEM$/$1/Deployment/Scripts` folder and that
`FirstLogonCommands` in `autounattend.xml` points to the correct script path.

### The log shows a WARNING

Warnings are non-critical. They usually mean that a cosmetic change could not be
refreshed immediately and will apply after the next sign-in.

### The taskbar or Explorer does not update immediately

Some shell settings require Explorer restart or a new sign-in. The registry value
may already be correct even if the visible UI updates later.

### Windows asks for language, keyboard or account setup

This usually means the answer file was not processed as expected. Confirm that:

- `autounattend.xml` is in the USB root;
- Rufus Windows customization options were not used;
- the file was not saved with a broken encoding;
- the target ISO still contains the expected Windows 11 Enterprise image.

## Safety notes

- No automatic disk wipe is configured.
- Defender remains enabled.
- SmartScreen remains unchanged.
- UAC remains unchanged.
- BitLocker is not removed; only automatic device encryption is prevented.
- OneDrive and Copilot are disabled via policy-style registry settings, not by
  deleting system components.
- Passwords are stored in clear text on the USB stick. Treat it as sensitive
  administrative media.

## Release status

Version 1.0.0 is the first stable release of the AGIT Deployment Kit. It is based
on the validated 0.9.0 release candidate and contains no intentional deployment
behavior changes after the final successful hardware test.

For release details, see `RELEASE.md`. For the project principles, see
`PHILOSOPHY.md`.
