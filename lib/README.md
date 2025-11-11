# RehabTracker Pro - Project Structure

## Overview
RehabTracker Pro is a Flutter application for physical therapy tracking with gamification, routine management, and ROM measurement capabilities.

## Folder Structure

```
lib/
├── main.dart                    # App entry point with Riverpod setup
├── theme/                       # Theme and design system
│   ├── app_theme.dart          # Material Design 3 theme configuration
│   ├── gradients.dart          # Custom gradient definitions
│   └── animation_curves.dart   # Custom animation curves
├── features/                    # Feature modules
│   ├── dashboard/              # Gamified dashboard and progress tracking
│   ├── routine/                # Routine and logging management
│   └── rom_measurement/        # Range of motion measurement interface
├── models/                      # Data models
├── providers/                   # Riverpod state management providers
├── widgets/                     # Reusable widgets
│   └── common/                 # Common/shared widgets
└── utils/                       # Utility functions and helpers
```

## Core Dependencies

- **flutter_riverpod** (^2.6.1) - State management
- **go_router** (^14.6.2) - Routing and navigation
- **fl_chart** (^0.70.1) - Charts and data visualization
- **shared_preferences** (^2.3.3) - Local data persistence
- **google_fonts** (^6.2.1) - Typography

## Design System

### Color Palette
- Primary: Cyan (#00D9FF)
- Secondary: Magenta (#FF006E)
- Accent: Yellow (#FBFF00)
- Background Dark: #0A0E27
- Background Light: #F8F9FA

### Typography
Using Google Fonts (Inter) with custom weight scales for hierarchy.

### Animation
Custom curves for spring-like animations and geometric morphing effects.

## Getting Started

1. Ensure Flutter is installed
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Next Steps

Implement features according to the task list in `.kiro/specs/rehab-tracker-pro/tasks.md`
