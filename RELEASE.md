# AGIT Deployment Kit 1.0.0 Release Notes

Release date: 2026-06-25  
Status: Stable  
Target: Windows 11 Enterprise 25H2  
Author: Christian Treffenstaedt

## Release summary

AGIT Deployment Kit 1.0.0 is the first stable release of the project. It is based
on the validated 0.9.0 release-candidate build. The release candidate completed a
full clean deployment on physical hardware without errors or warnings in the
AGIT deployment log.

No intentional deployment behavior changes were introduced between 0.9.0 and
1.0.0. Version 1.0.0 formalizes the stable release by updating metadata,
documentation, release notes and project philosophy documentation.

## Validated environment

- Windows edition: Windows 11 Enterprise
- Windows generation: 25H2
- ISO: `SW_DVD9_Win_Pro_11_25H2.8_64BIT_German_Pro_Ent_EDU_N_MLF_X24-31690`
- Boot mode: UEFI
- Partitioning style: GPT
- USB creation: Rufus, without Rufus Windows customization options enabled

## Supported workflow

1. Create a Windows installation USB stick.
2. Copy the AGIT Deployment Kit files to the root of the USB stick.
3. Replace the required password placeholders.
4. Boot the target device from the USB stick.
5. Select the target disk/partition manually.
6. Let Windows Setup and the deployment scripts finish automatically.
7. Review `C:\Windows\Temp\Deployment.log`.

## Known limitations

- Disk selection and partition deletion are intentionally manual.
- `SetupPassword` must be changed in both `autounattend.xml` and `Config.ps1`.
- Passwords are stored in plain text on the deployment media.
- The kit is validated for the listed Windows 11 Enterprise 25H2 ISO only.
- The built-in Administrator account is intentionally enabled for the intended
  temporary staging workflow.

## Release criteria

Version 1.0.0 is considered stable because:

- OOBE automation was validated.
- The temporary `Setup` account workflow was validated.
- The built-in `Administrator` account workflow was validated.
- AutoLogon cleanup was validated.
- Explorer, taskbar, context menu, Microsoft, privacy and security modules were
  validated through the deployment log and validation report.
- The final test completed with zero warnings and zero errors.

## Upgrade guidance

If you are already using 0.9.0 successfully, 1.0.0 does not require a functional
redeployment test. It contains the same validated deployment behavior plus
release-level documentation and metadata.
