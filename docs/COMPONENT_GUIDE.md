# Component Usage Guide

## Overview

This guide provides examples and best practices for using RehabTracker Pro's UI components. All components follow Material Design 3 principles with a focus on accessibility and professional aesthetics.

## Common Components

### Professional Input Components

#### ProfessionalTextField

Large, accessible text input with clear focus states.

```dart
import 'package:rehab_tracker_pro/widgets/common/professional_text_field.dart';

ProfessionalTextField(
  label: 'Exercise Name',
  hint: 'Enter exercise name',
  controller: controller,
  onChanged: (value) {
    // Handle change
  },
)
```

**Features:**
- 64px height for easy tapping
- 18px font for readability
- Clear focus indicators
- Supports validation

#### ProfessionalSlider

Large slider with clear value display.

```dart
import 'package:rehab_tracker_pro/widgets/common/professional_slider.dart';

ProfessionalSlider(
  label: 'Pain Level',
  value: painLevel,
  min: 0,
  max: 10,
  divisions: 10,
  onChanged: (value) {
    setState(() => painLevel = value);
  },
)
```

**Features:**
- 8px track thickness
- 28px thumb size
- Large value labels
- Smooth animations

#### ProfessionalCheckbox

Large checkbox for easy tapping.

```dart
import 'package:rehab_tracker_pro/widgets/common/professional_checkbox.dart';

ProfessionalCheckbox(
  label: 'Completed',
  value: isCompleted,
  onChanged: (value) {
    setState(() => isCompleted = value ?? false);
  },
)
```

**Features:**
- 32px size
- Clear visual feedback
- Smooth toggle animations

#### ProfessionalSwitch

Large switch with clear on/off states.

```dart
import 'package:rehab_tracker_pro/widgets/common/professional_switch.dart';

ProfessionalSwitch(
  label: 'Enable Notifications',
  value: notificationsEnabled,
  onChanged: (value) {
    setState(() => notificationsEnabled = value);
  },
)
```

**Features:**
- Large touch target
- Clear on/off states
- Smooth animations

### Action Buttons

#### ActionButton

Professional button with multiple variants.

```dart
import 'package:rehab_tracker_pro/widgets/common/action_button.dart';

// Primary action
ActionButton(
  label: 'Start Session',
  onPressed: () {
    // Handle action
  },
  variant: ActionButtonVariant.primary,
)

// Secondary action
ActionButton(
  label: 'Cancel',
  onPressed: () {
    // Handle action
  },
  variant: ActionButtonVariant.secondary,
)

// With icon
ActionButton(
  label: 'Save',
  icon: Icons.save,
  onPressed: () {
    // Handle action
  },
)
```

**Variants:**
- `primary`: Filled button for main actions
- `secondary`: Outlined button for secondary actions
- `tertiary`: Text button for less important actions

**Features:**
- 64-72px height
- 18px font for labels
- Smooth press animations
- Optional icons

### Navigation Components

#### AppNavBar

Bottom navigation bar with large, clear elements.

```dart
import 'package:rehab_tracker_pro/widgets/navigation/app_nav_bar.dart';

AppNavBar(
  currentIndex: currentIndex,
  onDestinationSelected: (index) {
    setState(() => currentIndex = index);
  },
)
```

**Features:**
- 88px height
- 28px icons
- 16px labels (always visible)
- Clear active state
- Smooth transitions

#### AppShell

Main app shell with navigation.

```dart
import 'package:rehab_tracker_pro/widgets/navigation/app_shell.dart';

AppShell(
  currentIndex: currentIndex,
  onNavigate: (index) {
    setState(() => currentIndex = index);
  },
  child: currentScreen,
)
```

### Dashboard Components

#### StatusHeader

Displays user stats with elegant typography.

```dart
import 'package:rehab_tracker_pro/features/dashboard/widgets/status_header.dart';

StatusHeader(
  recoveryPoints: 150,
  currentLevel: 3,
)
```

**Features:**
- Large, elegant numbers
- Subtle inline level badge
- Generous padding
- Clear hierarchy

#### ProgressRing

Elegant circular progress indicator.

```dart
import 'package:rehab_tracker_pro/features/dashboard/widgets/progress_ring.dart';

ProgressRing(
  progress: 0.75,
  size: 140,
)
```

**Features:**
- Refined gradient
- Smooth animations
- Customizable size

#### TrendChart

Clean, borderless chart for data visualization.

```dart
import 'package:rehab_tracker_pro/features/dashboard/widgets/trend_chart.dart';

TrendChart(
  title: 'ROM Progress',
  dataPoints: [45, 50, 55, 60, 65],
  labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
)
```

**Features:**
- Professional styling
- Subtle dividers
- Clear data visualization

### ROM Measurement Components

#### AngleGauge

Displays angle measurement with large, readable text.

```dart
import 'package:rehab_tracker_pro/features/rom_measurement/widgets/angle_gauge.dart';

AngleGauge(
  angle: 45.0,
  maxAngle: 180.0,
)
```

**Features:**
- 120px font for angle
- 24px font for unit
- Minimal containers
- Clear visual hierarchy

#### InstructionDisplay

Shows measurement instructions clearly.

```dart
import 'package:rehab_tracker_pro/features/rom_measurement/widgets/instruction_display.dart';

InstructionDisplay(
  step: 1,
  totalSteps: 3,
  instruction: 'Position your arm at your side',
)
```

**Features:**
- 22px font for instructions
- Simple step indicator
- Clear hierarchy

### Routine Components

#### ExerciseList

Clean list of exercises with large checkboxes.

```dart
import 'package:rehab_tracker_pro/features/routine/widgets/exercise_list.dart';

ExerciseList(
  exercises: exercises,
  onExerciseToggle: (exercise) {
    // Handle toggle
  },
)
```

**Features:**
- 88px item height
- 32px checkboxes
- 20px bold font for names
- 24px spacing between items

#### SymptomTracker

Open form layout for symptom tracking.

```dart
import 'package:rehab_tracker_pro/features/routine/widgets/symptom_tracker.dart';

SymptomTracker(
  onSave: (data) {
    // Handle save
  },
)
```

**Features:**
- Large sliders
- Clear section headings (22px)
- Large checkboxes (32px)
- Prominent save button

## Utility Components

### ResponsiveText

Text that scales appropriately for different screen sizes.

```dart
import 'package:rehab_tracker_pro/widgets/common/responsive_text.dart';

ResponsiveText(
  'Welcome',
  style: theme.textTheme.headlineLarge,
)
```

### ConnectionStatusIndicator

Shows network connection status.

```dart
import 'package:rehab_tracker_pro/widgets/connection_status_indicator.dart';

ConnectionStatusIndicator()
```

### SyncIndicator

Shows sync status with animation.

```dart
import 'package:rehab_tracker_pro/widgets/sync_indicator.dart';

SyncIndicator(
  isSyncing: isSyncing,
)
```

## Layout Patterns

### Open Layout (Preferred)

Minimize card usage, use generous whitespace:

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: EdgeInsets.all(Spacing.lg),
      child: Text(
        'Section Title',
        style: theme.textTheme.headlineMedium,
      ),
    ),
    Divider(height: 1),
    Padding(
      padding: EdgeInsets.all(Spacing.md),
      child: content,
    ),
  ],
)
```

### Card Layout (When Needed)

Use minimal elevation:

```dart
Card(
  elevation: 1,
  child: Padding(
    padding: EdgeInsets.all(Spacing.md),
    child: content,
  ),
)
```

### List Layout

Clean lists with dividers:

```dart
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (context, index) => Divider(height: 1),
  itemBuilder: (context, index) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      title: Text(items[index].title),
    );
  },
)
```

## Accessibility Guidelines

### Touch Targets

All interactive elements should have minimum 48x48dp touch targets (prefer 56x56dp):

```dart
InkWell(
  onTap: () {},
  child: Container(
    height: 56,
    width: 56,
    alignment: Alignment.center,
    child: Icon(Icons.add),
  ),
)
```

### Semantic Labels

Provide semantic labels for screen readers:

```dart
Semantics(
  label: 'Start exercise session',
  button: true,
  child: ActionButton(
    label: 'Start',
    onPressed: () {},
  ),
)
```

### Focus Management

Ensure proper focus order:

```dart
Focus(
  autofocus: true,
  child: TextField(),
)
```

## Animation Guidelines

### Duration

- **Quick**: 100-200ms for micro-interactions
- **Standard**: 200-300ms for most transitions
- **Slow**: 300-500ms for complex animations

### Curves

```dart
import 'package:rehab_tracker_pro/theme/animation_curves.dart';

// Smooth transitions
AnimatedContainer(
  curve: AppCurves.smoothTransition,
  duration: Duration(milliseconds: 300),
)

// Particle effects
AnimatedOpacity(
  curve: AppCurves.particleFloat,
  duration: Duration(milliseconds: 400),
)
```

### Reduced Motion

Always respect reduced motion preferences:

```dart
import 'package:rehab_tracker_pro/utils/performance_utils.dart';

final duration = PerformanceUtils.getAnimationDuration(
  context,
  normal: Duration(milliseconds: 300),
  reduced: Duration(milliseconds: 100),
);
```

## Best Practices

1. **Use professional input components** for all form inputs
2. **Minimize card usage** - prefer open layouts
3. **Use generous spacing** - follow the 8px grid
4. **Ensure large touch targets** - minimum 48x48dp
5. **Test in both themes** - light and dark modes
6. **Verify accessibility** - contrast, screen readers, font scaling
7. **Use smooth animations** - 200-300ms with appropriate curves
8. **Follow typography hierarchy** - use theme text styles
9. **Respect reduced motion** - provide alternatives
10. **Test on multiple screen sizes** - ensure responsive design

## Common Patterns

### Form Layout

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    ProfessionalTextField(
      label: 'Name',
      controller: nameController,
    ),
    SizedBox(height: Spacing.md),
    ProfessionalSlider(
      label: 'Difficulty',
      value: difficulty,
      onChanged: (value) => setState(() => difficulty = value),
    ),
    SizedBox(height: Spacing.md),
    ProfessionalCheckbox(
      label: 'Completed',
      value: completed,
      onChanged: (value) => setState(() => completed = value ?? false),
    ),
    SizedBox(height: Spacing.lg),
    ActionButton(
      label: 'Save',
      onPressed: handleSave,
    ),
  ],
)
```

### Loading State

```dart
if (isLoading)
  Center(
    child: CircularProgressIndicator(),
  )
else
  content
```

### Empty State

```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.inbox_outlined,
        size: 64,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      SizedBox(height: Spacing.md),
      Text(
        'No items yet',
        style: theme.textTheme.titleLarge,
      ),
      SizedBox(height: Spacing.sm),
      Text(
        'Add your first item to get started',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    ],
  ),
)
```

### Error State

```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.error_outline,
        size: 64,
        color: theme.colorScheme.error,
      ),
      SizedBox(height: Spacing.md),
      Text(
        'Something went wrong',
        style: theme.textTheme.titleLarge,
      ),
      SizedBox(height: Spacing.sm),
      ActionButton(
        label: 'Try Again',
        onPressed: retry,
      ),
    ],
  ),
)
```
