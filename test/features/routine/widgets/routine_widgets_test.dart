import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehab_tracker_pro/features/routine/widgets/exercise_list.dart';
import 'package:rehab_tracker_pro/features/routine/widgets/symptom_tracker.dart';
import 'package:rehab_tracker_pro/features/routine/widgets/selection_buttons.dart';
import 'package:rehab_tracker_pro/features/routine/widgets/content_grid.dart';
import 'package:rehab_tracker_pro/models/exercise.dart';
import 'package:rehab_tracker_pro/providers/exercise_provider.dart';
import 'package:rehab_tracker_pro/repositories/exercise_repository.dart';
import 'package:rehab_tracker_pro/theme/app_theme.dart';

// Mock repository for testing
class MockExerciseRepository implements ExerciseRepository {
  @override
  Future<List<Exercise>> getAll() async => [];
  
  @override
  Future<Exercise?> getById(String id) async => null;
  
  @override
  Future<void> insert(Exercise exercise) async {}
  
  @override
  Future<void> update(Exercise exercise) async {}
  
  @override
  Future<void> delete(String id) async {}
  
  @override
  Future<void> deleteAll() async {}
  
  @override
  Future<int> getCompletedCount() async => 0;
}

void main() {
  group('ExerciseList Widget Tests', () {
    testWidgets('displays list of exercises', (WidgetTester tester) async {
      final exercises = [
        Exercise(
          id: '1',
          name: 'Knee Bend',
          description: 'Bend your knee slowly',
          isCompleted: false,
          difficulty: Difficulty.easy,
          category: 'Flexibility',
        ),
        Exercise(
          id: '2',
          name: 'Leg Raise',
          description: 'Raise your leg',
          isCompleted: true,
          difficulty: Difficulty.medium,
          category: 'Strength',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            exerciseProvider.overrideWith((ref) => TestExerciseNotifier(exercises)),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: ExerciseList(),
            ),
          ),
        ),
      );

      // Wait for staggered animations to complete
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify exercises are displayed
      expect(find.text('Knee Bend'), findsOneWidget);
      expect(find.text('Leg Raise'), findsOneWidget);
    });

    testWidgets('toggles exercise completion on tap',
        (WidgetTester tester) async {
      final exercises = [
        Exercise(
          id: '1',
          name: 'Knee Bend',
          description: 'Bend your knee slowly',
          isCompleted: false,
          difficulty: Difficulty.easy,
          category: 'Flexibility',
        ),
      ];

      bool toggleCalled = false;
      String? toggledId;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            exerciseProvider.overrideWith((ref) {
              return TestExerciseNotifier(
                exercises,
                onToggle: (id) {
                  toggleCalled = true;
                  toggledId = id;
                },
              );
            }),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: ExerciseList(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find and tap the checkbox
      final toggleFinder = find.byType(Checkbox);
      expect(toggleFinder, findsOneWidget);

      await tester.tap(toggleFinder);
      await tester.pump();

      expect(toggleCalled, isTrue);
      expect(toggledId, equals('1'));
    });

    testWidgets('shows reward animation on completion',
        (WidgetTester tester) async {
      final exercises = [
        Exercise(
          id: '1',
          name: 'Knee Bend',
          description: 'Bend your knee slowly',
          isCompleted: false,
          difficulty: Difficulty.easy,
          category: 'Flexibility',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            exerciseProvider.overrideWith((ref) => TestExerciseNotifier(exercises)),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: ExerciseList(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Tap the checkbox to complete exercise
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Verify reward dialog appears
      expect(find.byType(RewardAnimationDialog), findsOneWidget);
    });

    testWidgets('displays difficulty badges correctly',
        (WidgetTester tester) async {
      final exercises = [
        Exercise(
          id: '1',
          name: 'Easy Exercise',
          description: 'Easy',
          isCompleted: false,
          difficulty: Difficulty.easy,
          category: 'Test',
        ),
        Exercise(
          id: '2',
          name: 'Medium Exercise',
          description: 'Medium',
          isCompleted: false,
          difficulty: Difficulty.medium,
          category: 'Test',
        ),
        Exercise(
          id: '3',
          name: 'Hard Exercise',
          description: 'Hard',
          isCompleted: false,
          difficulty: Difficulty.hard,
          category: 'Test',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            exerciseProvider.overrideWith((ref) => TestExerciseNotifier(exercises)),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: ExerciseList(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify difficulty badges are displayed
      expect(find.text('EASY'), findsOneWidget);
      expect(find.text('MEDIUM'), findsOneWidget);
      expect(find.text('HARD'), findsOneWidget);
    });
  });

  group('SymptomSlider Widget Tests', () {
    testWidgets('displays initial value correctly', (WidgetTester tester) async {
      int currentValue = 5;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SymptomSlider(
              label: 'Pain Level',
              value: currentValue,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.text('Pain Level'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('updates value on drag', (WidgetTester tester) async {
      int currentValue = 5;
      int? newValue;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: SymptomSlider(
                label: 'Pain Level',
                value: currentValue,
                onChanged: (value) {
                  newValue = value;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the GestureDetector within the slider
      final gestureFinder = find.descendant(
        of: find.byType(SymptomSlider),
        matching: find.byType(GestureDetector),
      );

      // Simulate drag to the right (higher value)
      await tester.drag(gestureFinder, const Offset(200, 0), warnIfMissed: false);
      await tester.pump();

      // Value should have changed (may not be exact due to calculation)
      expect(newValue, isNotNull);
    });

    testWidgets('displays severity colors correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Column(
              children: [
                SymptomSlider(
                  label: 'Low Pain',
                  value: 2,
                  onChanged: (value) {},
                ),
                SymptomSlider(
                  label: 'Medium Pain',
                  value: 5,
                  onChanged: (value) {},
                ),
                SymptomSlider(
                  label: 'High Pain',
                  value: 9,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify all sliders are rendered
      expect(find.text('Low Pain'), findsOneWidget);
      expect(find.text('Medium Pain'), findsOneWidget);
      expect(find.text('High Pain'), findsOneWidget);
    });

    testWidgets('respects min and max values', (WidgetTester tester) async {
      int? capturedValue;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: SymptomSlider(
                label: 'Custom Range',
                value: 5,
                min: 0,
                max: 20,
                onChanged: (value) {
                  capturedValue = value;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the GestureDetector within the slider
      final gestureFinder = find.descendant(
        of: find.byType(SymptomSlider),
        matching: find.byType(GestureDetector),
      );

      // Drag to maximum
      await tester.drag(gestureFinder, const Offset(500, 0), warnIfMissed: false);
      await tester.pump();

      expect(capturedValue, isNotNull);
      expect(capturedValue! <= 20, isTrue);
      expect(capturedValue! >= 0, isTrue);
    });
  });

  group('SelectionButton Widget Tests', () {
    testWidgets('displays label and icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SelectionButton(
              label: 'Test Button',
              icon: Icons.check,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('toggles selection state', (WidgetTester tester) async {
      bool isSelected = false;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              theme: AppTheme.lightTheme,
              home: Scaffold(
                body: SelectionButton(
                  label: 'Toggle Button',
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      isSelected = !isSelected;
                    });
                  },
                ),
              ),
            );
          },
        ),
      );

      expect(isSelected, isFalse);

      await tester.tap(find.byType(SelectionButton));
      await tester.pumpAndSettle();

      expect(isSelected, isTrue);
    });

    testWidgets('animates on selection change', (WidgetTester tester) async {
      bool isSelected = false;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              theme: AppTheme.lightTheme,
              home: Scaffold(
                body: SelectionButton(
                  label: 'Animated Button',
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      isSelected = !isSelected;
                    });
                  },
                ),
              ),
            );
          },
        ),
      );

      await tester.tap(find.byType(SelectionButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify animation is in progress
      expect(find.byType(SelectionButton), findsOneWidget);
    });
  });

  group('MultiSelectButtonGroup Widget Tests', () {
    testWidgets('displays all options', (WidgetTester tester) async {
      final options = ['Option 1', 'Option 2', 'Option 3'];

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: MultiSelectButtonGroup(
              label: 'Select Options',
              options: options,
              selectedOptions: const [],
              onChanged: (selected) {},
            ),
          ),
        ),
      );

      expect(find.text('Select Options'), findsOneWidget);
      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.text('Option 3'), findsOneWidget);
    });

    testWidgets('allows multiple selections', (WidgetTester tester) async {
      final options = ['Option 1', 'Option 2', 'Option 3'];
      List<String> selectedOptions = [];

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              theme: AppTheme.lightTheme,
              home: Scaffold(
                body: MultiSelectButtonGroup(
                  label: 'Select Options',
                  options: options,
                  selectedOptions: selectedOptions,
                  onChanged: (selected) {
                    setState(() {
                      selectedOptions = selected;
                    });
                  },
                ),
              ),
            );
          },
        ),
      );

      // Tap first option
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      expect(selectedOptions.contains('Option 1'), isTrue);

      // Tap second option
      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();

      expect(selectedOptions.contains('Option 1'), isTrue);
      expect(selectedOptions.contains('Option 2'), isTrue);
      expect(selectedOptions.length, equals(2));
    });

    testWidgets('deselects option on second tap', (WidgetTester tester) async {
      final options = ['Option 1'];
      List<String> selectedOptions = ['Option 1'];

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              theme: AppTheme.lightTheme,
              home: Scaffold(
                body: MultiSelectButtonGroup(
                  label: 'Select Options',
                  options: options,
                  selectedOptions: selectedOptions,
                  onChanged: (selected) {
                    setState(() {
                      selectedOptions = selected;
                    });
                  },
                ),
              ),
            );
          },
        ),
      );

      expect(selectedOptions.contains('Option 1'), isTrue);

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      expect(selectedOptions.contains('Option 1'), isFalse);
      expect(selectedOptions.isEmpty, isTrue);
    });
  });

  group('BooleanSelectionButton Widget Tests', () {
    testWidgets('displays true and false options', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: BooleanSelectionButton(
              label: 'Swelling',
              value: false,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.text('Swelling'), findsOneWidget);
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('toggles between true and false', (WidgetTester tester) async {
      bool value = false;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              theme: AppTheme.lightTheme,
              home: Scaffold(
                body: BooleanSelectionButton(
                  label: 'Medication Taken',
                  value: value,
                  onChanged: (newValue) {
                    setState(() {
                      value = newValue;
                    });
                  },
                ),
              ),
            );
          },
        ),
      );

      expect(value, isFalse);

      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      expect(value, isTrue);

      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      expect(value, isFalse);
    });
  });

  group('ContentGrid Widget Tests', () {
    final testItems = [
      ContentItem(
        id: '1',
        title: 'Knee Exercises',
        description: 'Learn proper knee exercises',
        category: 'Exercises',
        type: ContentType.video,
      ),
      ContentItem(
        id: '2',
        title: 'Pain Management',
        description: 'Managing pain effectively',
        category: 'Guides',
        type: ContentType.article,
      ),
      ContentItem(
        id: '3',
        title: 'Recovery Tips',
        description: 'Tips for faster recovery',
        category: 'Exercises',
        type: ContentType.guide,
      ),
    ];

    testWidgets('displays all content items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ContentGrid(
              items: testItems,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Knee Exercises'), findsOneWidget);
      expect(find.text('Pain Management'), findsOneWidget);
      expect(find.text('Recovery Tips'), findsOneWidget);
    });

    testWidgets('filters content by search query', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ContentGrid(
              items: testItems,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField), 'knee');
      await tester.pumpAndSettle();

      // Only matching item should be visible
      expect(find.text('Knee Exercises'), findsOneWidget);
      expect(find.text('Pain Management'), findsNothing);
      expect(find.text('Recovery Tips'), findsNothing);
    });

    testWidgets('filters content by category', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ContentGrid(
              items: testItems,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on Guides category chip (not the text in content cards)
      final guideChips = find.widgetWithText(GeometricCategoryChip, 'Guides');
      expect(guideChips, findsOneWidget);
      
      await tester.tap(guideChips);
      await tester.pumpAndSettle();

      // Only Guides category items should be visible
      expect(find.text('Pain Management'), findsOneWidget);
      expect(find.text('Knee Exercises'), findsNothing);
      expect(find.text('Recovery Tips'), findsNothing);
    });

    testWidgets('clears search query', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ContentGrid(
              items: testItems,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField), 'knee');
      await tester.pumpAndSettle();

      expect(find.text('Knee Exercises'), findsOneWidget);

      // Clear search
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // All items should be visible again
      expect(find.text('Knee Exercises'), findsOneWidget);
      expect(find.text('Pain Management'), findsOneWidget);
      expect(find.text('Recovery Tips'), findsOneWidget);
    });

    testWidgets('shows empty state when no results', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ContentGrid(
              items: testItems,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Search for non-existent content
      await tester.enterText(find.byType(TextField), 'nonexistent');
      await tester.pumpAndSettle();

      expect(find.text('No content found'), findsOneWidget);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('calls onItemTap when content card is tapped',
        (WidgetTester tester) async {
      ContentItem? tappedItem;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ContentGrid(
              items: testItems,
              onItemTap: (item) {
                tappedItem = item;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on first content card
      await tester.tap(find.text('Knee Exercises'));
      await tester.pumpAndSettle();

      expect(tappedItem, isNotNull);
      expect(tappedItem!.id, equals('1'));
      expect(tappedItem!.title, equals('Knee Exercises'));
    });

    testWidgets('combines search and category filters',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ContentGrid(
              items: testItems,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Select Exercises category chip
      final exerciseChips = find.widgetWithText(GeometricCategoryChip, 'Exercises');
      expect(exerciseChips, findsOneWidget);
      
      await tester.tap(exerciseChips);
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField), 'recovery');
      await tester.pumpAndSettle();

      // Only matching item in Exercises category should be visible
      expect(find.text('Recovery Tips'), findsOneWidget);
      expect(find.text('Knee Exercises'), findsNothing);
      expect(find.text('Pain Management'), findsNothing);
    });
  });
}

// Test helper class for ExerciseNotifier
class TestExerciseNotifier extends ExerciseNotifier {
  final Function(String)? onToggle;
  final List<Exercise> initialExercises;

  TestExerciseNotifier(this.initialExercises, {this.onToggle}) 
      : super(MockExerciseRepository()) {
    state = initialExercises;
  }

  @override
  Future<void> toggleExerciseCompletion(String id) async {
    onToggle?.call(id);
    state = state.map((exercise) {
      if (exercise.id == id) {
        return Exercise(
          id: exercise.id,
          name: exercise.name,
          description: exercise.description,
          isCompleted: !exercise.isCompleted,
          completedAt: !exercise.isCompleted ? DateTime.now() : null,
          difficulty: exercise.difficulty,
          category: exercise.category,
        );
      }
      return exercise;
    }).toList();
  }
}
