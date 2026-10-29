# Security Policy

## Supported Versions

The following versions of **MoveYourBody** are currently supported with security updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0.0 | :x:                |

## Reporting a Vulnerability

We take the security and privacy of **MoveYourBody** seriously. If you discover a security vulnerability or privacy leak, we appreciate your help in responsibly disclosing it to us.

**Please do NOT disclose security vulnerabilities publicly through GitHub Issues or public Discord channels.**

### Private Submission Process

To report a vulnerability privately, choose one of the following methods:

1. **GitHub Private Vulnerability Reporting (Recommended):**
   - Go to the repository's [Security Advisories](https://github.com/AOSSIE-Org/MoveYourBody/security/advisories/new) tab.
   - Click **Report a vulnerability** to submit the advisory directly to the project maintainers.
2. **Private Discord Reporting:**
   - Join our [Discord Server](https://discord.gg/hjUhu33uAn) and contact a project maintainer or admin directly via direct message.

### What to Include

When submitting a vulnerability report, please provide:
- A clear description of the issue and potential impact.
- Affected versions and target platforms (Android, iOS).
- Step-by-step reproduction instructions or a proof-of-concept (PoC).
- Any proposed remediation or mitigation.

### Response Timelines (SLA)

- **Initial Response:** Maintainers will acknowledge your report within **48–72 hours**.
- **Assessment & Triage:** We will assess the severity and keep you informed of our investigation.
- **Fix & Disclosure:** For confirmed vulnerabilities, we target releasing a patch within **14 days** before public disclosure.

## Security Architecture & Best Practices

MoveYourBody is designed with **Privacy-by-Design**:
- **Fully Offline:** All user data, workouts, feedback, and on-device machine learning (all-MiniLM-L6-v2) run locally without cloud telemetry or external API servers.
- **Local Storage:** SQLite databases reside within the platform-enforced application sandbox with `android:allowBackup="false"` to prevent unauthorized data extraction.
- **Input Sanitization:** Tokenization and search queries are strictly bounded and normalized to safeguard against memory exhaustion or runtime exceptions.
