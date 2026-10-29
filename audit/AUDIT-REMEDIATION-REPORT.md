# Audit Remediation Report: MoveYourBody

**Auditee:** Vaibhav Aryan  
**Auditor:** Aneesa Fatima  
**Repo:** https://github.com/AOSSIE-Org/MoveYourBody  
**Original Audit:** [AUDIT_REPORT.md](AUDIT_REPORT.md)

---

## Remediation Summary

All 3 findings identified during the audit review have been fully addressed and resolved. Below are the details of the remediation actions taken for each finding.

---

## Detailed Remediation

### 1. Text not vertically centered on the Add screen (UI, Low)
- **Status:** Resolved
- **Location:** `lib/ui/home/widgets/screens/add_workout_screen.dart`
- **Resolution:**
  - Added `crossAxisAlignment: CrossAxisAlignment.center` to the parent `Row` layout inside the custom workout plan item card.
  - The plan name text and adjacent icons are now properly aligned and vertically centered within the card layout.

### 2. Hardcoded `List<QuickPlanDefinition>` in the repository (Code quality, Low)
- **Status:** Resolved
- **Location:**
  - `lib/data/repositories/quick_plan_repository.dart`
  - `lib/utils/constants/app_constants.dart`
- **Resolution:**
  - Extracted all preset quick plan assets and definitions out of `quick_plan_repository.dart`.
  - Added asset paths in `AppAssets` and defined a dedicated `QuickPlanConstants` class inside `app_constants.dart` containing `exercisesPerPlan` and `presetPlans`.
  - Updated `QuickPlanRepository` to reference `QuickPlanConstants.presetPlans` and `QuickPlanConstants.exercisesPerPlan`, significantly improving repository readability and modularity.

### 3. No mandatory validation in onboarding (Logic, Medium)
- **Status:** Resolved
- **Location:** Onboarding screens (`lib/ui/onboarding/`)
- **Resolution:**
  - Already addressed and resolved in Pull Request: https://github.com/AOSSIE-Org/MoveYourBody/pull/41
  - Validation was implemented across onboarding screens so that the "Next" button is disabled until all mandatory required fields are properly filled.

---

## Conclusion
All findings (2 Low, 1 Medium) from the audit report have been successfully remediated.
