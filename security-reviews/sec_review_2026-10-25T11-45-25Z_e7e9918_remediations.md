# Remediations of Security Review Findings

Review date and time: 2026-10-25T11:45:25Z

## Remediations

### Remediation of Finding 1: Missing `android:allowBackup="false"` Allows Unencrypted Application Data Extraction

- [x] This remediation implements the security review's recommendation for this finding.
- [ ] This remediation addresses the finding in a way that differs from the security review's recommendation.

Remediation commits:
- Applied in `android/app/src/main/AndroidManifest.xml`

Description: Added `android:allowBackup="false"` to the `<application>` tag in `android/app/src/main/AndroidManifest.xml` to prevent unauthorized ADB data extraction of private application SQLite databases while maintaining normal app operations.

## Non-remediated findings

### Finding 2: Unnecessary `android.permission.INTERNET` Declared in Production Manifest

This finding was not remediated because the application requires `android.permission.INTERNET` in production for dynamic runtime asset fetching and caching, specifically for Google Fonts via `google_fonts` and remote exercise video/image animations via `AnimationCacheService`. Removing this permission in production would cause network exceptions during asset loading.

## Comments

The project has established an official `SECURITY.md` defining private vulnerability reporting workflows and SLA timelines for disclosure.
