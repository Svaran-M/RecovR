import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../../../models/exercise.dart';
import '../../../providers/exercise_provider.dart';
import '../../../providers/user_progress_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/animation_curves.dart';

class ExerciseList extends ConsumerStatefulWidget {
  const ExerciseList({super.key});

  @override
  ConsumerState<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends ConsumerState<ExerciseList>
    with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<Exercise> _displayedExercises;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _displayedExercises = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      // Trigger staggered entrance animations
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final exercises = ref.read(exerciseProvider);
        _animateInitialList(exercises);
      });
    }
  }

  void _animateInitialList(List<Exercise> exercises) {
    for (int i = 0; i < exercises.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          setState(() {
            _displayedExercises.add(exercises[i]);
          });
          _listKey.currentState?.insertItem(
            i,
            duration: const Duration(milliseconds: 600),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercises = ref.watch(exerciseProvider);

    // Update displayed exercises if list changes
    if (_isInitialized && exercises.length != _displayedExercises.length) {
      _displayedExercises = exercises;
    }

    return AnimatedList(
      key: _listKey,
      initialItemCount: 0,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index, animation) {
        if (index >= _displayedExercises.length) {
          return const SizedBox.shrink();
        }
        return _buildExerciseCard(
          _displayedExercises[index],
          animation,
          index,
        );
      },
    );
  }

  Widget _buildExerciseCard(
    Exercise exercise,
    Animation<double> animation,
    int index,
  ) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(0.3, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: AppCurves.elasticEntry)),
      ),
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24), // Increased spacing
          child: ExerciseCard(
            exercise: exercise,
            onToggle: () => _handleToggle(exercise),
          ),
        ),
      ),
    );
  }

  void _handleToggle(Exercise exercise) {
    ref.read(exerciseProvider.notifier).toggleExerciseCompletion(exercise.id);
    
    if (!exercise.isCompleted) {
      // Award points for completing exercise
      final points = _getPointsForDifficulty(exercise.difficulty);
      ref.read(userProgressProvider.notifier).addRecoveryPoints(points);
      
      // Update completion percentage
      final completionPercentage = ref.read(exerciseProvider.notifier).completionPercentage;
      ref.read(userProgressProvider.notifier).updateCompletionPercentage(completionPercentage);
      
      // Increment streak if applicable
      ref.read(userProgressProvider.notifier).incrementStreak();
      
      // Show reward animation
      _showRewardAnimation(points);
    }
  }
  
  int _getPointsForDifficulty(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 10;
      case Difficulty.medium:
        return 20;
      case Difficulty.hard:
        return 30;
    }
  }

  void _showRewardAnimation(int points) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black26,
      builder: (context) => RewardAnimationDialog(points: points),
    );
  }
}

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final VoidCallback onToggle;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onToggle,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: widget.onToggle,
      child: Container(
        constraints: const BoxConstraints(minHeight: 88), // Minimum 88px height
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Large checkbox (32px)
            Transform.scale(
              scale: 1.5, // Makes the checkbox 32px (from default ~21px)
              child: Checkbox(
                value: widget.exercise.isCompleted,
                onChanged: (_) => widget.onToggle(),
                materialTapTargetSize: MaterialTapTargetSize.padded,
              ),
            ),
            const SizedBox(width: 16),
            // Exercise details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.exercise.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20, // 20px bold font for exercise names
                      decoration: widget.exercise.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.exercise.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 16, // Readable font size
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _buildDifficultyBadge(context, theme),
                ],
              ),
            ),
            // Points indicator
            if (!widget.exercise.isCompleted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+${_getPointsForDifficulty(widget.exercise.difficulty)}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(BuildContext context, ThemeData theme) {
    Color badgeColor;
    switch (widget.exercise.difficulty) {
      case Difficulty.easy:
        badgeColor = AppTheme.success(context);
        break;
      case Difficulty.medium:
        badgeColor = AppTheme.warning(context);
        break;
      case Difficulty.hard:
        badgeColor = AppTheme.error(context);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        widget.exercise.difficulty.name.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  int _getPointsForDifficulty(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 10;
      case Difficulty.medium:
        return 20;
      case Difficulty.hard:
        return 30;
    }
  }
}

/// Reward animation dialog with particle system
class RewardAnimationDialog extends StatefulWidget {
  final int points;
  
  const RewardAnimationDialog({super.key, required this.points});

  @override
  State<RewardAnimationDialog> createState() => _RewardAnimationDialogState();
}

class _RewardAnimationDialogState extends State<RewardAnimationDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _particles = List.generate(
      20,
      (index) => Particle(
        angle: (index / 20) * 2 * 3.14159,
        speed: 100 + (index % 5) * 20,
        size: 8 + (index % 3) * 4,
        color: [
          const Color(0xFF0061A4),
          const Color(0xFF535F70),
          const Color(0xFF6B5778),
          AppTheme.successLight,
        ][index % 4],
      ),
    );

    _controller.forward().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(300, 300),
                painter: ParticleSystemPainter(
                  particles: _particles,
                  progress: _controller.value,
                ),
                child: Center(
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
                      ),
                    ),
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.5, end: 1.2).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
                        ),
                      ),
                      child: Text(
                        '+${widget.points}',
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: AppTheme.success(context),
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: AppTheme.success(context).withOpacity(0.5),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Particle {
  final double angle;
  final double speed;
  final double size;
  final Color color;

  Particle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
  });
}

class ParticleSystemPainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  ParticleSystemPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final particle in particles) {
      final distance = particle.speed * progress;
      final x = center.dx + distance * math.cos(particle.angle);
      final y = center.dy + distance * math.sin(particle.angle);

      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = particle.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x, y),
        particle.size * (1.0 - progress * 0.5),
        paint,
      );
    }

    // Center burst
    if (progress < 0.3) {
      final burstProgress = progress / 0.3;
      final burstPaint = Paint()
        ..color = AppTheme.successLight.withOpacity(1.0 - burstProgress)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        center,
        50 * burstProgress,
        burstPaint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticleSystemPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
