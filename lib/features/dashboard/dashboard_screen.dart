import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_progress_provider.dart';
import '../../providers/rom_measurement_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/spacing_utils.dart';
import '../../utils/animation_constants.dart';
import 'widgets/dashboard_widgets.dart';

// Dashboard with open layout and generous whitespace
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProgress = ref.watch(userProgressProvider);
    final romMeasurements = ref.watch(romMeasurementProvider);

    // last 7 days of ROM data
    final now = DateTime.now();
    final last7Days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));
    
    final dataPoints = <double>[];
    final labels = <String>[];
    
    for (final day in last7Days) {
      labels.add(_getDayLabel(day));
      
      final dayMeasurements = romMeasurements.where((m) {
        return m.date.year == day.year &&
               m.date.month == day.month &&
               m.date.day == day.day;
      }).toList();
      
      if (dayMeasurements.isNotEmpty) {
        // average all measurements for the day
        final avgAngle = dayMeasurements.fold<double>(
          0.0, 
          (sum, m) => sum + m.maxAngle
        ) / dayMeasurements.length;
        dataPoints.add(avgAngle);
      } else {
        dataPoints.add(0);
      }
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimationBuilders.slideAndFadeIn(
              duration: AnimationConstants.normal,
              child: RepaintBoundary(
                child: StatusHeader(
                  recoveryPoints: userProgress.recoveryPoints,
                  currentLevel: userProgress.currentLevel,
                ),
              ),
            ),
            SpacingUtils.vertical32,

            Padding(
              padding: SpacingUtils.screenPaddingH,
              child: AnimationBuilders.slideAndFadeIn(
                duration: const Duration(milliseconds: 300),
                child: RepaintBoundary(
                  child: DailyActionCard(
                    title: "Start Today's Session",
                    subtitle: 'Complete your exercises and earn points',
                    onTap: () {
                      context.go('/routine');
                    },
                  ),
                ),
              ),
            ),
            SpacingUtils.sectionGap,

            Padding(
              padding: SpacingUtils.screenPaddingH,
              child: AnimationBuilders.slideAndFadeIn(
                duration: const Duration(milliseconds: 350),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: RepaintBoundary(
                        child: ProgressRing(
                          progress: userProgress.completionPercentage,
                          size: 140,
                        ),
                      ),
                    ),
                    SpacingUtils.horizontal24,
                    Expanded(
                      child: RepaintBoundary(
                        child: StreakCounter(
                          streakCount: userProgress.streakCount,
                          size: 140,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SpacingUtils.sectionGap,

            AnimationBuilders.slideAndFadeIn(
              duration: const Duration(milliseconds: 400),
              child: RepaintBoundary(
                child: TrendChart(
                  title: 'ROM Progress (Last 7 Days)',
                  dataPoints: dataPoints.isEmpty ? [0] : dataPoints,
                  labels: labels,
                  height: 220,
                ),
              ),
            ),
            SpacingUtils.vertical32,
          ],
        ),
      ),
    );
  }
  
  String _getDayLabel(DateTime date) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.weekday % 7];
  }
}
