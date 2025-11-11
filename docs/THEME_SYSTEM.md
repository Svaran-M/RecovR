# Theme System Documentation

## Overview

RehabTracker Pro uses a professional Material Design 3 theme system with carefully crafted light and dark modes. The theme prioritizes readability, accessibility, and a sophisticated healthcare-appropriate aesthetic.

## Theme Structure

### Color Schemes

The app uses Material 3 color roles for consistent theming:

**Light Mode:**
- Primary: Deep professional blue (#0061A4)
- Secondary: Refined gray-blue (#535F70)
- Tertiary: Subtle purple accent (#6B5778)
- Surface: Clean white (#FDFCFF)
- Background: Clean white (#FDFCFF)

**Dark Mode:**
- Primary: Light blue (#9ECAFF)
- Secondary: Light gray-blue (#BBC7DB)
- Tertiary: Light purple (#DDBCE0)
- Surface: Dark gray (#1A1C1E)
- Background: Dark gray (#1A1C1E)

### Typography

The typography system uses a clear hierarchy optimized for readability:

- **Display Large**: 57px - Hero numbers, key statistics
- **Display Medium**: 45px - Large headings
- **Display Small**: 36px - Section headings
- **Headline Large**: 32px - Major section titles
- **Headline Medium**: 28px - Subsection titles
- **Headline Small**: 24px - Card titles
- **Title Large**: 22px - List headers
- **Body Large**: 16px - Primary body text
- **Body Medium**: 14px - Secondary body text
- **Label Large**: 14px - Button labels, form labels

All text uses appropriate line heights (1.5-1.6) for optimal readability.

### Spacing System

The app uses an 8px grid system for consistent spacing:

- **xs**: 8px - Tight spacing
- **sm**: 16px - Compact spacing
- **md**: 24px - Standard spacing
- **lg**: 32px - Generous spacing
- **xl**: 48px - Extra generous spacing

### Elevation

Minimal elevation is used for a clean, modern look:

- **Level 0**: 0dp - Flat surfaces
- **Level 1**: 1dp - Subtle elevation for cards
- **Level 2**: 3dp - Floating action buttons
- **Level 3**: 6dp - Dialogs
- **Level 4**: 8dp - Navigation drawer
- **Level 5**: 12dp - Modal bottom sheets

## Using the Theme

### Accessing Theme Colors

```dart
final theme = Theme.of(context);
final primaryColor = theme.colorScheme.primary;
final surfaceColor = theme.colorScheme.surface;
```

### Accessing Typography

```dart
final theme = Theme.of(context);
final headlineStyle = theme.textTheme.headlineMedium;
final bodyStyle = theme.textTheme.bodyLarge;
```

### Using Spacing

```dart
import 'package:rehab_tracker_pro/utils/spacing_utils.dart';

// Use predefined spacing
Padding(
  padding: EdgeInsets.all(Spacing.md),
  child: child,
)

// Use spacing scale
SizedBox(height: Spacing.lg)
```

### Gradients

The app provides pre-defined gradients for visual interest:

```dart
import 'package:rehab_tracker_pro/theme/gradients.dart';

Container(
  decoration: BoxDecoration(
    gradient: AppGradients.primary,
  ),
)

// Severity-based gradients
Container(
  decoration: BoxDecoration(
    gradient: AppGradients.getSeverityGradient(painLevel),
  ),
)
```

### Animation Curves

Custom animation curves are available for smooth, professional animations:

```dart
import 'package:rehab_tracker_pro/theme/animation_curves.dart';

AnimatedContainer(
  duration: Duration(milliseconds: 300),
  curve: AppCurves.smoothTransition,
  // ...
)
```

## Theme Switching

The app automatically respects system theme preferences. Users can also manually switch themes in settings.

```dart
// Theme is managed by the app's root widget
// It automatically updates when system theme changes
```

## Accessibility

The theme system ensures:

- **WCAG AA contrast ratios** for all text
- **Large touch targets** (minimum 48x48dp, prefer 56x56dp)
- **Clear focus indicators** for keyboard navigation
- **Respects system font scaling**
- **Works perfectly in both light and dark modes**

## Best Practices

1. **Always use theme colors** instead of hardcoded colors
2. **Use the spacing system** for consistent layouts
3. **Follow the typography hierarchy** for clear information architecture
4. **Minimize elevation** - use only when necessary for depth
5. **Test in both light and dark modes**
6. **Verify accessibility** with contrast checkers and screen readers

## Component Theming

### Buttons

```dart
// Primary action
FilledButton(
  onPressed: () {},
  child: Text('Primary Action'),
)

// Secondary action
OutlinedButton(
  onPressed: () {},
  child: Text('Secondary Action'),
)

// Tertiary action
TextButton(
  onPressed: () {},
  child: Text('Tertiary Action'),
)
```

### Cards

```dart
Card(
  elevation: 1,
  child: Padding(
    padding: EdgeInsets.all(Spacing.md),
    child: content,
  ),
)
```

### Input Fields

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Label',
    hintText: 'Hint text',
    border: OutlineInputBorder(),
  ),
)
```

## Migration Notes

The UI redesign replaced geometric shapes with standard Material components:

- **GeometricToggle** → `Checkbox` / `Switch`
- **GeometricActionButton** → `FilledButton` / `OutlinedButton`
- **GeometricNavBar** → `NavigationBar`
- Custom geometric shapes → `Card` with proper elevation

All existing functionality remains unchanged - only the visual presentation was updated.
