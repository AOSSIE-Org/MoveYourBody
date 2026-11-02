# Audit Report: MoveYourBody

**Auditor:** Aneesa Fatima
**Auditee:** Vaibhav Aryan
**Repo:** https://github.com/AOSSIE-Org/MoveYourBody

## Method
Manually tested the app's features and did a code review.

## Findings

### 1. Text not vertically centered on the Add screen (UI, Low)
- **Where:** Add screen
- **Issue:** The text is not vertically centered.
- **Suggested fix:** Wrap it in `Center`, or set `alignment: Alignment.center` / `crossAxisAlignment: CrossAxisAlignment.center` on the parent layout.

### 2. Hardcoded `List<QuickPlanDefinition>` in the repository (Code quality, Low)
- **Where:** `lib/features/home/repositories/quick_plan_repository.dart`
- **Issue:** The list is defined inside the repository file, which hurts readability.
- **Suggested fix:** Move it to a separate constants file and import it.

### 3. No mandatory validation in onboarding (Logic, Medium)
- **Where:** Onboarding screens
- **Issue:** Empty fields are accepted, so users can skip required info.
- **Suggested fix:** Add validation and disable "Next" until required fields are filled.

## Summary
The app works well overall. There are 3 findings (1 medium, 2 low), and all are quick fixes.
