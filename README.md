# RehabTracker Pro

A professional, accessible rehabilitation tracking application built with Flutter. RehabTracker Pro helps users track their recovery progress, complete exercises, log symptoms, and measure range of motion with a beautiful, healthcare-appropriate interface.

## Features

- **Dashboard**: Track recovery progress with elegant visualizations
- **Exercise Routines**: Complete daily exercises with clear, accessible interfaces
- **ROM Measurement**: Measure and track range of motion progress
- **Symptom Logging**: Track pain levels, swelling, and medication
- **Offline Support**: Full offline functionality with automatic sync
- **Accessibility**: WCAG AA compliant with large touch targets and clear typography
- **Professional Design**: Sleek Material Design 3 interface with light and dark themes

## Design Principles

RehabTracker Pro follows these core design principles:

1. **Professional First**: Healthcare-appropriate aesthetic that inspires trust
2. **Clarity Over Decoration**: Focus on content and usability, especially for post-surgery patients and older adults
3. **Subtle Elegance**: Refined shadows, spacing, and transitions instead of bold geometric shapes
4. **Accessibility Maintained**: Proper contrast ratios and large touch targets (minimum 48x48dp, prefer 56x56dp)
5. **Consistency**: Uniform design system across all screens and components
6. **Breathable Layouts**: Minimal card usage, generous whitespace, subtle dividers
7. **Simple Navigation**: Clear, obvious navigation patterns for older adults
8. **Consumer-Grade Polish**: Every detail refined for a premium experience

## UI/UX Highlights

### Typography
- **Large, readable fonts**: 18px minimum for body text
- **Clear hierarchy**: Display, headline, title, and body styles
- **Optimal line heights**: 1.5-1.6 for readability

### Spacing
- **8px grid system**: Consistent spacing throughout
- **Generous whitespace**: 32px screen edges, 24px between sections
- **Minimal containers**: Open layouts with subtle dividers

### Accessibility
- **Large touch targets**: 56x56dp preferred, 48x48dp minimum
- **WCAG AA contrast**: All text meets accessibility standards
- **Screen reader support**: Semantic labels and proper focus management
- **Font scaling**: Respects system font size preferences
- **Reduced motion**: Respects accessibility preferences

### Components
- **Professional inputs**: Large text fields (64px), sliders (8px track, 28px thumb), checkboxes (32px)
- **Clear buttons**: 64-72px height with 18px labels
- **Elegant navigation**: 88px bottom bar with 28px icons and 16px labels
- **Smooth animations**: 200-300ms transitions with professional curves

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- iOS development: Xcode 14+
- Android development: Android Studio with SDK 21+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/rehab_tracker_pro.git
cd rehab_tracker_pro
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/dashboard/widgets/dashboard_widgets_test.dart

# Run integration tests
flutter test integration_test/app_flow_test.dart
```

## Project Structure

```
lib/
├── features/           # Feature modules
│   ├── dashboard/     # Dashboard screen and widgets
│   ├── routine/       # Exercise routines and symptom tracking
│   ├── rom_measurement/ # Range of motion measurement
│   └── settings/      # App settings
├── models/            # Data models
├── providers/         # State management (Riverpod)
├── repositories/      # Data access layer
├── services/          # Business logic services
├── theme/             # Theme configuration
├── utils/             # Utility functions
├── widgets/           # Reusable widgets
│   ├── common/       # Common UI components
│   └── navigation/   # Navigation components
└── main.dart         # App entry point
```

## Documentation

- [Theme System](docs/THEME_SYSTEM.md) - Complete theme documentation
- [Component Guide](docs/COMPONENT_GUIDE.md) - UI component usage guide
- [Project Setup](PROJECT_SETUP.md) - Development setup guide
- [Offline Sync](docs/OFFLINE_SYNC.md) - Offline functionality documentation

## Architecture

RehabTracker Pro uses a clean architecture approach:

- **Presentation Layer**: Flutter widgets and screens
- **State Management**: Riverpod for reactive state management
- **Business Logic**: Service classes for core functionality
- **Data Layer**: Repository pattern with local SQLite storage
- **Offline Support**: Automatic sync with conflict resolution

## Key Technologies

- **Flutter**: Cross-platform UI framework
- **Riverpod**: State management
- **SQLite**: Local data storage
- **Material Design 3**: UI design system
- **Connectivity Plus**: Network status monitoring

## Contributing

Contributions are welcome! Please follow these guidelines:

1. Follow the existing code style and architecture
2. Use the professional input components from `lib/widgets/common/`
3. Ensure all new features are accessible (WCAG AA)
4. Test in both light and dark modes
5. Verify large touch targets (minimum 48x48dp)
6. Write tests for new features
7. Update documentation as needed

## Testing

The project includes comprehensive tests:

- **Unit Tests**: Model and service logic
- **Widget Tests**: UI component behavior
- **Integration Tests**: End-to-end user flows
- **Accessibility Tests**: WCAG compliance
- **Performance Tests**: Animation and rendering performance

## Accessibility

RehabTracker Pro is designed with accessibility as a priority:

- WCAG AA compliant contrast ratios
- Large touch targets for easy interaction
- Screen reader support with semantic labels
- Respects system font scaling
- Reduced motion support
- Clear focus indicators
- Works perfectly in both light and dark modes

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Material Design 3 guidelines
- Flutter accessibility best practices
- Healthcare UX research for older adults and post-surgery patients
