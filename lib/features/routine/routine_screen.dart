import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/symptom_log.dart';
import '../../providers/symptom_log_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/spacing_utils.dart';
import 'widgets/exercise_list.dart';
import 'widgets/symptom_tracker.dart';
import 'widgets/selection_buttons.dart';
import 'widgets/content_grid.dart';

class RoutineScreen extends ConsumerStatefulWidget {
  const RoutineScreen({super.key});

  @override
  ConsumerState<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends ConsumerState<RoutineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Symptom tracking state
  int _painLevel = 5;
  bool _swelling = false;
  bool _medicationTaken = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        AppBar(
          title: Text(
            'My Routine',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: TabBar(
              controller: _tabController,
              indicatorWeight: 4, // 4px height indicator
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: theme.textTheme.titleMedium?.copyWith(
                fontSize: 16, // 16px tab text
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: theme.textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              tabs: const [
                Tab(text: 'Exercises'),
                Tab(text: 'Symptoms'),
                Tab(text: 'Library'),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildExercisesTab(),
              _buildSymptomsTab(),
              _buildLibraryTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExercisesTab() {
    return const ExerciseList();
  }

  Widget _buildSymptomsTab() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: SpacingUtils.cardPadding, // Generous padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SymptomSlider(
                  label: 'Pain Level',
                  value: _painLevel,
                  onChanged: (value) {
                    setState(() => _painLevel = value);
                  },
                  min: 1,
                  max: 10,
                ),
                SpacingUtils.vertical32,
                BooleanSelectionButton(
                  label: 'Swelling',
                  value: _swelling,
                  onChanged: (value) {
                    setState(() => _swelling = value);
                  },
                  trueLabel: 'Yes',
                  trueIcon: Icons.check_circle,
                ),
                SpacingUtils.listItemGap,
                BooleanSelectionButton(
                  label: 'Medication Taken',
                  value: _medicationTaken,
                  onChanged: (value) {
                    setState(() => _medicationTaken = value);
                  },
                  trueLabel: 'Yes',
                  trueIcon: Icons.medication,
                ),
              ],
            ),
          ),
        ),
        // Prominent save button at bottom
        Container(
          padding: SpacingUtils.cardPadding,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              return FilledButton(
                onPressed: _saveSymptomLog,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16), // Large button
                  minimumSize: const Size(double.infinity, AppTheme.buttonHeightStandard),
                ),
                child: Text(
                  'Save Symptom Log',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLibraryTab() {
    final sampleContent = _getSampleContent();

    return ContentGrid(
      items: sampleContent,
      onItemTap: (item) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening: ${item.title}'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  Future<void> _saveSymptomLog() async {
    try {
      final symptomLog = SymptomLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        painLevel: _painLevel,
        swelling: _swelling,
        medicationTaken: _medicationTaken,
      );

      await ref.read(symptomLogProvider.notifier).addSymptomLog(symptomLog);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Symptom log saved successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving symptom log: ${e.toString()}'),
            duration: const Duration(seconds: 3),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  List<ContentItem> _getSampleContent() {
    return [
      ContentItem(
        id: '1',
        title: 'Proper Shoulder Flexion Technique',
        description: 'Learn the correct form for shoulder flexion exercises',
        category: 'Upper Body',
        type: ContentType.video,
      ),
      ContentItem(
        id: '2',
        title: 'Understanding Pain Management',
        description: 'A comprehensive guide to managing rehabilitation pain',
        category: 'Education',
        type: ContentType.article,
      ),
      ContentItem(
        id: '3',
        title: 'Knee Recovery Guide',
        description: 'Complete guide to knee rehabilitation exercises',
        category: 'Lower Body',
        type: ContentType.guide,
      ),
      ContentItem(
        id: '4',
        title: 'Range of Motion Basics',
        description: 'Understanding ROM measurements and their importance',
        category: 'Education',
        type: ContentType.article,
      ),
      ContentItem(
        id: '5',
        title: 'Advanced Ankle Exercises',
        description: 'Progress your ankle rehabilitation with these exercises',
        category: 'Lower Body',
        type: ContentType.video,
      ),
      ContentItem(
        id: '6',
        title: 'Stretching Best Practices',
        description: 'Essential stretching techniques for recovery',
        category: 'General',
        type: ContentType.guide,
      ),
    ];
  }
}
