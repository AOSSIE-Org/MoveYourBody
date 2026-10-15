# MoveYourBody Brand & Design Guidelines

Welcome to the **MoveYourBody** brand and design guidelines. This document serves as the single source of truth for the project's visual identity, ensuring consistency across all screens, components, and pull requests.

## 1. Design Principles
*   **Consistency First:** Always use predefined theme values and semantic colors over hardcoded styles.
*   **Dark Theme Optimization:** The app relies on a high-contrast dark theme. Ensure text readability against dark surfaces.
*   **Clear Hierarchy:** Use our structured typography scale to guide the user's attention.
*   **Spacing Matters:** Maintain breathable layouts using our standardized padding and margins.

## 2. Color Palette
Our color system is centrally managed in [`lib/core/theme/app_colors.dart`](./lib/core/theme/app_colors.dart). **Never hardcode hex values in UI files.**

### Core & Surface Colors
*   **Background:** `#0A1A0A` (Deep dark green, almost black) - `AppColors.background`
*   **Surface:** `#122412` - `AppColors.surface`
*   **Card:** `#1A2E1A` - `AppColors.card`
*   **Card Selected:** `#254025` - `AppColors.cardSelected`

### Brand Colors
*   **Primary:** `#4CAF50` (Vibrant green) - `AppColors.primary`
*   **Primary Light:** `#81C784` - `AppColors.primaryLight`

### Text Colors
*   **Text Primary:** `#FFFFFF` (White) - `AppColors.textPrimary`
*   **Text Secondary:** `#B0BEC5` (Cool grey) - `AppColors.textSecondary`

### Structural Colors
*   **Border:** `#2E7D32` - `AppColors.border`
*   **Border Selected:** `#66BB6A` - `AppColors.borderSelected`
*   **Divider:** `#1B3A1B` - `AppColors.divider`

## 3. Typography
Our primary font stack uses **Figtree** via `GoogleFonts.figtree()`. The typography hierarchy is managed in [`lib/core/theme/app_themes.dart`](./lib/core/theme/app_themes.dart). 

Always use `Theme.of(context).textTheme` rather than hardcoding `TextStyle`.

| Role | Font Size | Weight | Line Height | Flutter TextTheme |
| :--- | :--- | :--- | :--- | :--- |
| **Headline Large** | 28px | Bold | 1.3 | `textTheme.headlineLarge` |
| **Headline Medium** | 22px | 700 (w700) | - | `textTheme.headlineMedium` |
| **Title Medium** | 16px | 600 (w600) | - | `textTheme.titleMedium` |
| **Body Large** | 16px | Normal | 1.5 | `textTheme.bodyLarge` |
| **Label Large** | 15px | 500 (w500) | - | `textTheme.labelLarge` |
| **Body Medium** | 14px | Normal | 1.5 | `textTheme.bodyMedium` |

*Note: The AppBar title uses a specific style (18px, w600).*

## 4. Layout & Shapes

### Responsiveness (Flex Layout)
The application relies heavily on Flutter's Flex layout model to ensure fluid responsiveness across various screen sizes.
*   **Dynamic Distribution:** Always prefer using `Row`, `Column`, `Expanded`, and `Flexible` widgets to distribute available space dynamically.
*   **Avoid Fixed Sizes:** Refrain from using hardcoded `height` and `width` values for major structural elements and let the flex model handle scaling.

### Border Radius
*   **Buttons:** Standard border radius is `14px`.
*   **Cards/Containers:** Always use standardized border radiuses, commonly between `10px` and `20px` depending on the widget scale, avoid sharp edges unless fully taking up screen width.

### Spacing System
We utilize a 4-point/8-point spacing grid. Common padding and margin values found in the codebase:
*   `4.0` / `8.0` - Micro spacing (between icons and text)
*   `10.0` / `12.0` - Inner component spacing
*   `16.0` - Default screen horizontal padding
*   `20.0` - Large card inner padding
*   `32.0` - Section breaks

Always prefer `EdgeInsets.symmetric` or `EdgeInsets.all` using these specific steps.

## 5. Theme Support
Currently, the app primarily runs on a robust **Dark Theme**.
*   **Configuration Location:** [`lib/core/theme/app_themes.dart`](./lib/core/theme/app_themes.dart)
*   **Implementation:** Utilizes Flutter's standard `ThemeData` with a dark `ColorScheme`. 
*   **Usage:** Prefer using semantic theme lookups (e.g., `Theme.of(context).colorScheme.primary`) to ensure future compatibility if a Light theme is introduced.

## 6. Before Opening a UI Pull Request
- Supports both light and dark themes.
- Uses existing theme variables (`AppColors` and `ThemeData`).
- Uses the project's typography.
- Maintains consistent spacing.
- Does not introduce unnecessary colors.
- Works across common screen sizes.
