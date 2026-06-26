# Changelog

All notable changes to the AGIT Deployment Kit are documented in this file.

## [1.0.0] - 2026-06-25

### Added
- Added `RELEASE.md` for stable release notes and validation criteria.
- Added `PHILOSOPHY.md` with the project design principles.

### Changed
- Promoted the validated 0.9.0 release candidate to the first stable release.
- Updated project metadata, headers and documentation to version 1.0.0.
- Marked the release stage as `stable`.

### Notes
- No intentional deployment behavior changes compared with 0.9.0.
- The final 0.9.0 validation test completed on physical hardware with no warnings and no errors.

## [0.9.0] - 2026-06-25

### Changed
- Expanded English and German README files into administrator-facing user guides.
- Added a non-technical configuration reference for each option in `Config.ps1`.
- Added recommended configuration profiles for staging, Windows-standard and end-user-style scenarios.
- Added clearer troubleshooting and validation guidance.
- Updated project metadata to release-candidate status.

### Notes
- No intentional deployment behavior changes compared with 0.8.1.
- Intended as the documentation-complete release candidate before 1.0.0.

## [0.8.1] - 2026-06-25

### Changed
- Expanded `Config.ps1` with clearer explanations for every configurable setting.
- Added configuration reference tables to the English and German README files.
- Kept deployment behavior unchanged from 0.8.0.

## [0.8.0] - 2026-06-25

### Changed
- Improved operational documentation in `autounattend.xml`.
- Added explicit password replacement instructions directly inside the answer file.
- Expanded English and German README files with Quick Start, safety notes and known-good baseline information.
- Clarified the role of `SetupPassword` and `AdminPassword` in `Config.ps1`.

### Quality
- Treated 0.7.0 as the known-good functional baseline.
- Kept the tested Setup to Administrator workflow unchanged.
- Continued using UTF-8 with BOM for PowerShell, XML and Markdown files.

## [0.7.0] - 2026-06-25

### Added
- Unified AGIT Deployment Kit project structure.
- Central `Config.ps1` for credentials and feature switches.
- Manifest, VERSION file, LICENSE, English README and German README.
- Central logging with INFO, OK, WARNING and ERROR levels.
- Deployment summary and validation report.
- Explorer module.
- Taskbar module.
- Classic context menu module.
- Microsoft defaults module.
- Privacy module.
- Security module.

### Changed
- Converted the project into the AGIT Deployment Kit with semantic versioning.
- Standardized module structure and logging.

## [0.4.1] - 2026-06-25

### Fixed
- Fixed a PowerShell parser issue in `Common.ps1`.
- Converted project files to UTF-8 with BOM where appropriate.

## [0.3.1] - 2026-06-25

### Fixed
- Corrected the Administrator AutoLogon registry workflow.
- Improved defensive registry handling.

## [0.3.0] - 2026-06-25

### Added
- Administrator enablement workflow.
- Temporary Setup account cleanup.
- Automatic transition from Setup to Administrator.

## [0.2.0] - 2026-06-25

### Added
- Phase 1 OOBE automation.
- Windows 11 Enterprise selection.
- Temporary Setup account creation.
- Basic deployment logging.
