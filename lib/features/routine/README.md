# Routine and Logging Management Interface

This module implements the routine and logging management interface for RehabTracker Pro, featuring unique geometric designs and engaging animations.

## Components

### 1. ExerciseList Widget (`exercise_list.dart`)
**Requirements: 2.1, 2.2, 2.3, 4.1, 4.3**

Features:
- ✅ Cards with diagonal cuts using `ClipPath` and asymmetric layouts
- ✅ Completion toggles as morphing geometric switches using `AnimatedSwitcher`
- ✅ Reward animations using `AnimatedPositioned` particle systems
- ✅ Staggered entrance animations using `AnimatedList` with custom intervals

Key Components:
- `ExerciseList`: Main list widget with staggered animations
- `ExerciseCard`: Individual exercise card with diagonal cuts
- `DiagonalCardClipper`: Custom clipper for diagonal card edges
- `GeometricToggle`: Morphing hexagon-to-circle toggle switch
- `GeometricTogglePainter`: Custom painter for toggle animations
- `RewardAnimationDialog`: Particle system for completion rewards
- `ParticleSystemPainter`: Custom painter for particle effects

### 2. SymptomTracker Widgets (`symptom_tracker.dart`)
**Requirements: 2.4, 2.5, 4.1, 4.2**

Features:
- ✅ Non-linear slider tracks with curved paths using `CustomPaint`
- ✅ Handles designed as floating geometric shapes with `GestureDetector`
- ✅ Color gradients indicating severity levels using `LinearGradient`
- ✅ Haptic feedback on interaction using `HapticFeedback` class

Key Components:
- `SymptomSlider`: Main slider widget with curved track
- `CurvedSliderPainter`: Custom painter for wavy slider track
- `SymptomTrackerWidget`: Container widget for multiple symptom inputs

### 3. SelectionButtons (`selection_buttons.dart`)
**Requirements: 2.4, 2.5, 4.1, 4.3**

Features:
- ✅ Irregular button shapes with `CustomPaint` and dynamic borders
- ✅ Morphing animations between states using `AnimatedContainer`
- ✅ Gradient backgrounds with animated patterns using `AnimatedBuilder`
- ✅ `Wrap` widget for clustering layouts breaking grid conventions

Key Components:
- `SelectionButton`: Individual selection button with morphing shape
- `IrregularButtonPainter`: Custom painter for irregular polygon shapes
- `SelectionButtonGroup`: Container for multiple selection buttons
- `MultiSelectButtonGroup`: Multiple selection support
- `SingleSelectButtonGroup`: Single selection support
- `BooleanSelectionButton`: Yes/No toggle buttons

### 4. ContentGrid (`content_grid.dart`)
**Requirements: 2.6, 2.7, 4.1, 4.2**

Features:
- ✅ Masonry-style layout using `flutter_staggered_grid_view` package
- ✅ Content cards with angled corners using `ClipPath` and depth layers with `Transform`
- ✅ Search interface with morphing `TextField` using `AnimatedContainer`
- ✅ Category filters as floating geometric `Chip` widgets with custom styling

Key Components:
- `ContentGrid`: Main grid widget with search and filters
- `ContentItem`: Data model for content items
- `GeometricCategoryChip`: Custom chip with geometric styling
- `ChipPainter`: Custom painter for chip shapes
- `ContentCard`: Individual content card with 3D effects
- `AngledCardClipper`: Custom clipper for angled corners

### 5. RoutineScreen (`routine_screen.dart`)

Main screen that integrates all routine widgets with a tabbed interface:
- Exercises tab: Shows exercise list
- Symptoms tab: Symptom tracking interface
- Library tab: Educational content grid

## Usage

```dart
import 'package:rehab_tracker_pro/features/routine/routine_screen.dart';

// Navigate to routine screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const RoutineScreen()),
);
```

Or import individual widgets:

```dart
import 'package:rehab_tracker_pro/features/routine/widgets/routine_widgets.dart';

// Use individual widgets
ExerciseList()
SymptomSlider(...)
SelectionButton(...)
ContentGrid(...)
```

## Design Principles

All widgets follow the app's unique geometric design language:
- Irregular shapes and asymmetric layouts
- High-contrast colors with gradients
- Smooth, purposeful animations
- Haptic feedback for interactions
- Accessibility-compliant touch targets (48x48 logical pixels)

## Dependencies

- `flutter_riverpod`: State management
- `flutter_staggered_grid_view`: Masonry grid layout
- Built-in Flutter animation framework
- Custom painters for geometric shapes

## Testing

Widget tests should cover:
- Exercise completion tracking
- Symptom logging data validation
- Search and filtering functionality
- Animation performance
- Accessibility compliance
