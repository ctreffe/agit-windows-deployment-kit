# AGIT Deployment Kit Philosophy

The AGIT Deployment Kit is not intended to be a collection of random Windows
tweaks. It is a small, maintainable deployment framework with explicit design
principles.

## 1. Safety over automation

Automation is useful, but not at the cost of accidental data loss. Disk and
partition selection remain manual by design. The administrator must make the
final decision before a target disk is modified.

## 2. Keep Windows supportable

The kit should produce a clean and supportable Windows installation. It does not
remove core Windows components, disable Defender, disable SmartScreen, disable
UAC or apply aggressive debloating.

## 3. Prefer supported configuration methods

Whenever possible, the kit uses Microsoft-supported policy and configuration
locations. Registry changes are documented and kept limited to the intended
administrative baseline.

## 4. Documentation is part of the product

The README files, comments, changelog, release notes and philosophy document are
part of the kit. They are not afterthoughts. A future administrator should be
able to understand why a decision was made.

## 5. Every module must be idempotent

A module should be safe to run more than once. If a setting already exists, the
module should log that fact and continue instead of failing unnecessarily.

## 6. Every meaningful action must be logged

The deployment log is the operational record of the installation. It must show
what happened, what succeeded, what was skipped and what failed.

## 7. Warnings are not errors

A cosmetic refresh failure must not break an otherwise successful deployment.
Only core failures, such as missing configuration, failed account setup or a
missing required script, should be treated as errors.

## 8. Validation before success

The kit does not merely apply settings. It also validates the most important
expected outcomes and writes a validation report.

## 9. Evolution instead of revolution

After version 1.0.0, the core workflow should remain stable. New functionality
should be added as modules whenever possible. Core components should only be
changed to fix bugs or to support a new Windows release.

## 10. No hidden magic

Every important decision should be visible in code, configuration, comments,
documentation or the deployment log.
