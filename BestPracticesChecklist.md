# AOSSIE Best Practices Checklist

> Criteria adapted from the [OpenSSF Best Practices Badge](https://github.com/coreinfrastructure/best-practices-badge)
> (MIT / CC BY 3.0) by OpenSSF contributors. Modified for AOSSIE multi-repo template use.

> **Purpose:** Covers OpenSSF Best Practices criteria that are NOT auto-detected by OpenSSF Scorecard.
> Scorecard already handles: License, SAST tools, CI tests, Security Policy file, Branch Protection,
> Pinned Dependencies, Signed Releases, Maintained status, and Known Vulnerabilities.
>
> **How to use:**
> 1. Fill in checkboxes below — tick `[x]` for Met, leave `[ ]` for Unmet, use `[~]` for N/A
> 2. Add a brief note or URL after each item as evidence
> 3. Run the checklist-score workflow to update the badge automatically
>
> **Legend:**
> - 🔴 MUST — Required for passing
> - 🟡 SHOULD — Required unless documented rationale given
> - 🔵 SUGGESTED — Optional but recommended
> - ⚪ N/A — Mark `[~]` if not applicable, add justification

---

## Score Summary

<!-- Auto-updated by checklist-score.yml workflow — do not edit manually -->
| Category           | Met | Total | Status |
|--------------------|-----|-------|--------|
| Basics             | 0   | 8     | 🔴     |
| Change Control     | 0   | 6     | 🔴     |
| Reporting          | 0   | 8     | 🔴     |
| Quality            | 0   | 11     | 🔴     |
| Security           | 0   | 9     | 🔴     |
| Analysis           | 0   | 7     | 🔴     |
| **Total**          | **0** | **49** | **0%** |
---

## 🏗️ Basics

### Project Website & Documentation

- [x] 🔴 **description_good** — The project README/website clearly describes what the software does and what problem it solves.
  - *Evidence URL:* [README.md](./README.md)

- [x] 🔴 **interact** — The project provides information on how to obtain the software, submit bug reports, and contribute.
  - *Evidence URL:* [CONTRIBUTING.md](./CONTRIBUTING.md)

- [x] 🔴 **contribution** — `CONTRIBUTING.md` explains the contribution process (e.g., PRs are used, how to open one).
  - *Evidence URL:* [CONTRIBUTING.md](./CONTRIBUTING.md)

- [x] 🟡 **contribution_requirements** — `CONTRIBUTING.md` references acceptable contribution standards (coding style, tests required, etc.).
  - *Evidence URL:* [CONTRIBUTING.md](./CONTRIBUTING.md)

- [x] 🔴 **documentation_basics** — Basic documentation exists for the software (README, Wiki, or docs folder).
  - *Evidence URL:* [README.md](./README.md) and [PRIVACY_POLICY.md](./PRIVACY_POLICY.md)

- [~] 🔴 **documentation_interface** — Reference documentation describes the external interface (API inputs/outputs, CLI flags, config schema, etc.).
  - *Evidence URL:* `[~]` N/A — *Justification:* This is a fully offline mobile application with no public-facing API or CLI.

### Other Basics

- [x] 🔴 **discussion** — Project has a searchable, URL-addressable discussion mechanism (GitHub Issues, Discord with archive, mailing list, etc.) that doesn't require proprietary client software.
  - *Evidence URL:* [GitHub Issues](https://github.com/AOSSIE-Org/MoveYourBody/issues) and [Project Discord](https://discord.com/channels/1022871757289422898/1500966300782956634)

- [x] 🟡 **english** — Documentation is provided in English and English bug reports/comments are accepted.
  - *Note:* All project documentation is written in English.

---

## 🔄 Change Control

### Version Control

- [x] 🔵 **repo_distributed** — Project uses a distributed VCS (e.g., git). *(SUGGESTED)*
  - *Evidence URL:* Hosted on GitHub (Git is a distributed Version Control System).

### Version Numbering

- [x] 🔴 **version_unique** — Each release has a unique version identifier (e.g., v1.0.0).
  - *Evidence URL:* [GitHub Releases](https://github.com/AOSSIE-Org/MoveYourBody/releases) (e.g., `v1.0.0+3`) and [Google Play Store](https://play.google.com/store/apps/details?id=org.aossie.move) (`1.0.0+4`).

- [x] 🔵 **version_semver** — Project uses [SemVer](https://semver.org) or [CalVer](https://calver.org/) format. *(SUGGESTED)*
  - *Note:* Follows Semantic Versioning with Flutter build metadata (`MAJOR.MINOR.PATCH+BUILD`) as tracked in `VERSION` (`1.0.0`) and `pubspec.yaml` (`1.0.0+4`).

- [x] 🔵 **version_tags** — Releases are tagged in the VCS (e.g., `git tag v1.0.0`). *(SUGGESTED)*
  - *Evidence URL:* [GitHub Tags](https://github.com/AOSSIE-Org/MoveYourBody/tags) (e.g., `v1.0.0`, `v1.0.0+3`).

### Release Notes

- [x] 🔴 **release_notes** — Each release includes human-readable release notes summarizing major changes. Raw `git log` output is NOT acceptable.
  - *Evidence URL:* [GitHub Releases](https://github.com/AOSSIE-Org/MoveYourBody/releases) provides curated, human-readable release summaries for published versions.

- [~] 🔴 **release_notes_vulns** — Release notes identify every publicly known vulnerability (with CVE) fixed in that release.
  - *Evidence URL:* `[~]` N/A — *Justification:* No publicly known vulnerabilities or CVEs exist for this application to date.

---

## 🐛 Reporting

### Bug Reporting

- [x] 🔴 **report_process** — A bug-reporting process exists (e.g., GitHub Issues link in README).
  - *Evidence URL:* [README.md](./README.md)

- [x] 🟡 **report_tracker** — An issue tracker (e.g., GitHub Issues) is used to track individual bugs.
  - *Evidence URL:* GitHub Issues

- [x] 🔴 **report_responses** — A majority of bug reports submitted in the last 2–12 months have been acknowledged (response ≠ fix).
  - *Self-certification note:* Project started 3 months ago so there are no bugs reported yet. Responses and PRs are actively managed by maintainers (See: https://github.com/AOSSIE-Org/MoveYourBody/pulls)

- [~] 🟡 **enhancement_responses** — More than 50% of enhancement requests in the last 2–12 months have received a response.
  - *Self-certification note:* `[~]` N/A — *Justification:* Project is new (started 3 months ago) and no enhancement requests have been received yet.

- [x] 🔴 **report_archive** — Reports and responses are publicly archived and searchable (GitHub Issues satisfies this).
  - *Evidence URL:* [GitHub Issues](https://github.com/AOSSIE-Org/MoveYourBody/issues)

### Vulnerability Reporting

- [x] 🔴 **vulnerability_report_process** — A vulnerability reporting process is documented (e.g., `SECURITY.md`).
  - *Evidence URL:* [SECURITY.md](./SECURITY.md)

- [x] 🟡 **vulnerability_report_private** — If private vulnerability reporting is supported, the method for private submission is documented.
  - *Evidence URL:* [SECURITY.md](./SECURITY.md) (Section: *Private Submission Process*)

- [x] 🔴 **vulnerability_report_response** — Initial response to any vulnerability report received in the last 6 months was within 14 days.
  - *Self-certification note:* Documented in [SECURITY.md](./SECURITY.md) with a 48–72 hour acknowledgement and 14-day fix commitment. No vulnerability reports have been received to date.

---

## ✅ Quality

### Build System

- [x] 🔴 **build** — If the project requires building, a working build system exists that can auto-rebuild from source.
  - *Evidence URL:* Flutter SDK (`flutter build`)

- [x] 🔵 **build_common_tools** — Common build tools are used (npm, pip, cargo, make, gradle, etc.). *(SUGGESTED)*
  - *Evidence URL:* Flutter/Dart ecosystem.

- [x] 🟡 **build_floss_tools** — The project can be built using only FLOSS tools.
  - *Note:* Flutter SDK is open source.

### Automated Testing

- [x] 🔵 **test_invocation** — The test suite can be invoked in a standard way for the language (e.g., `npm test`, `pytest`, `cargo test`). *(SUGGESTED)*
  - *Evidence URL:* `flutter test`

- [x] 🔵 **test_most** — The test suite covers most code branches, input fields, and functionality. *(SUGGESTED)*
  - *Estimated coverage %:* Extensive suite of 80+ unit and widget test files across `test/core/` and `test/features/` covering domain models, repositories, viewmodels, services, and UI screens.

### New Functionality Testing Policy

- [x] 🔴 **test_policy** — The project has a general policy that new functionality must include tests in the automated test suite.
  - *Evidence:* Mentioned in `CONTRIBUTING.md` (Testing section).

- [x] 🔴 **tests_are_added** — Evidence exists that the test policy has been followed in recent major changes (e.g., PRs include tests).
  - *Evidence URL:* See recent PR: https://github.com/AOSSIE-Org/MoveYourBody/pull/19

- [x] 🔵 **tests_documented_added** — The test policy is documented in contribution instructions. *(SUGGESTED)*
  - *Evidence URL:* [CONTRIBUTING.md](./CONTRIBUTING.md) (Section: *3. Verify Your Code & Tests (CI Requirements)*)

### Linting / Warning Flags

- [x] 🔴 **warnings** — At least one linter or compiler warning flag is enabled (ESLint, Pylint, clippy, golangci-lint, Slither for Solidity, etc.).
  - *Tool used:* `flutter analyze`

- [x] 🔴 **warnings_fixed** — Warnings from the linter are addressed (not suppressed without reason).
  - *Note:* Code passes `flutter analyze` locally and warnings are actively fixed before merges.

- [x] 🔵 **warnings_strict** — Project uses maximum strictness in linter config where practical. *(SUGGESTED)*
  - *Note:* Using `flutter_lints` and Effective Dart standards.

---

## 🔐 Security

### Secure Development Knowledge

- [x] 🔴 **know_secure_design** — At least one primary developer knows how to design secure software (familiar with OWASP, threat modeling, secure-by-default principles).
  - *Self-certification note:* Primary developers apply OWASP Mobile Application Security principles, Privacy-by-Design (fully offline, zero telemetry, local on-device SQLite storage), and the Principle of Least Privilege (minimal system permissions requested).

- [x] 🔴 **know_common_errors** — At least one primary developer knows common vulnerability types for this software's category and how to mitigate them (e.g., injection, XSS, reentrancy for Solidity, prompt injection for AI).
  - *Self-certification note:* Team actively mitigates mobile risks: parameterized SQL queries prevent SQL injection in SQLite repositories, input sanitization prevents crashes in the local ONNX/tokenizer pipeline, and debug logging is barred in production via strict lint rules.

### Cryptography (mark N/A if project does not handle cryptography)

- [~] 🔴 **crypto_published** — Only publicly reviewed cryptographic protocols/algorithms are used by default.
  - *Note:* `[~]` N/A — No cryptography is implemented directly.

- [~] 🟡 **crypto_call** — Project calls an established crypto library rather than reimplementing crypto functions.
  - *Library used:* `[~]` N/A

- [~] 🔴 **crypto_working** — No broken algorithms (MD4, MD5, single DES, RC4, Dual_EC_DRBG) used unless required for interoperability (must be documented).
  - *Note:* `[~]` N/A

- [~] 🔴 **crypto_keylength** — Key lengths meet [NIST 2030 minimums](https://www.keylength.com/en/4/) by default.
  - *Note:* `[~]` N/A

- [~] 🔴 **crypto_password_storage** — Passwords for external users are stored as iterated salted hashes (Argon2id, bcrypt, scrypt, PBKDF2).
  - *Note:* `[~]` N/A — *Justification:* Project is a fully offline application and does not manage or store user passwords.

- [~] 🔴 **crypto_random** — Cryptographic keys and nonces are generated using a CSPRNG; insecure generators (Math.random, rand()) are NOT used for security purposes.
  - *Note:* `[~]` N/A

- [~] 🟡 **delivery_unsigned** — Cryptographic hashes are NOT retrieved over plain HTTP without a signature check.
  - *Note:* `[~]` N/A — No remote network fetching is required by the app.

---

## 🔬 Analysis

### Static Code Analysis

- [x] 🔴 **static_analysis_fixed** — All medium+ severity vulnerabilities found by static analysis are fixed in a timely manner after confirmation.
  - *Note:* Enforced via GitHub Actions CI ('flutter analyze' in test.yml). All static analysis warnings and linter issues must be resolved before any pull request can be merged.

- [x] 🔵 **static_analysis_common_vulnerabilities** — The static analysis tool includes checks for common vulnerabilities in the language/environment (e.g., eslint-plugin-security, bandit, Slither). *(SUGGESTED)*
  - *Tool + ruleset:* `flutter analyze` catches standard Dart vulnerabilities.

- [x] 🔵 **static_analysis_often** — Static analysis runs on every commit or at least daily (CI integration). *(SUGGESTED)*
  - *Evidence URL:* [test.yml](.github/workflows/test.yml) executes `flutter analyze` on every pull request and push to `main`.

### Dynamic Code Analysis

- [~] 🔵 **dynamic_analysis** — At least one dynamic analysis tool is applied before major releases (fuzzer, web app scanner like OWASP ZAP, etc.). *(SUGGESTED)*
  - *Tool used:* `[~]` N/A — *Justification:* Standard dynamic web scanners do not apply to fully offline Flutter apps.

- [x] 🔵 **dynamic_analysis_enable_assertions** — Dynamic analysis / testing runs with assertions enabled (not just production mode). *(SUGGESTED)*
  - *Note:* Flutter runs in debug mode with assertions enabled by default.

- [~] 🔴 **dynamic_analysis_fixed** — Medium+ severity vulnerabilities found by dynamic analysis are fixed in a timely manner.
  - *Note:* `[~]` N/A — *Justification:* As noted in `dynamic_analysis` above, external dynamic analysis tools (e.g., web/API fuzzers) do not apply to this fully offline Flutter client. Any runtime regressions or assertion failures caught during automated test runs (`flutter test`) are resolved immediately.

- [~] 🔵 **dynamic_analysis_unsafe** — If the project uses memory-unsafe languages (C/C++), memory safety tools (Valgrind, AddressSanitizer) are used. *(SUGGESTED)*
  - *Note:* `[~]` N/A — *Justification:* Project uses Dart, which is a memory-safe language.

---

## 📎 Project-Specific Notes

### Flutter / Dart Notes
- The project is fully offline. Criteria related to server-side logic, API endpoints, or Web/Network vulnerabilities are marked as N/A.
- A comprehensive [Privacy Policy](./PRIVACY_POLICY.md) is maintained to guarantee zero telemetry and strictly on-device operations.
- Code quality is strictly enforced via `flutter analyze`.

### AI / LLM Notes
- The app utilizes an on-device ONNX model (`all-MiniLM-L6-v2`) for semantic search.
- For `know_common_errors`: Ensure awareness of prompt injection or adversarial inputs if a text input field is exposed to the local model.

---

*This checklist complements [OpenSSF Scorecard](https://scorecard.dev/) (auto-detected checks) and is
inspired by the [OpenSSF Best Practices Badge](https://www.bestpractices.dev/en/criteria/0) passing criteria.*
