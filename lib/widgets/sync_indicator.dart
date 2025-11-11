import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sync_service.dart';

class SyncIndicator extends ConsumerStatefulWidget {
  final bool showLabel;

  const SyncIndicator({
    super.key,
    this.showLabel = true,
  });

  @override
  ConsumerState<SyncIndicator> createState() => _SyncIndicatorState();
}

class _SyncIndicatorState extends ConsumerState<SyncIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final syncState = ref.watch(syncStateProvider);

    return syncState.when(
      data: (state) {
        if (state.status == SyncStatus.idle && state.pendingChanges == 0) {
          return const SizedBox.shrink();
        }

        return _buildIndicator(context, state);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildIndicator(BuildContext context, SyncState state) {
    final theme = Theme.of(context);

    Color color;
    IconData icon;
    String label;

    switch (state.status) {
      case SyncStatus.syncing:
        color = theme.colorScheme.primary;
        icon = Icons.sync;
        label = 'Syncing...';
        break;
      case SyncStatus.success:
        color = Colors.green;
        icon = Icons.check_circle;
        label = 'Synced';
        break;
      case SyncStatus.error:
        color = Colors.red;
        icon = Icons.error;
        label = 'Sync failed';
        break;
      case SyncStatus.idle:
        color = Colors.orange;
        icon = Icons.cloud_upload;
        label = '${state.pendingChanges} pending';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: state.status == SyncStatus.syncing
                    ? _controller.value * 2 * math.pi
                    : 0,
                child: Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
              );
            },
          ),
          if (widget.showLabel) ...[
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class GeometricSyncIndicator extends ConsumerStatefulWidget {
  const GeometricSyncIndicator({super.key});

  @override
  ConsumerState<GeometricSyncIndicator> createState() =>
      _GeometricSyncIndicatorState();
}

class _GeometricSyncIndicatorState
    extends ConsumerState<GeometricSyncIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final syncState = ref.watch(syncStateProvider);

    return syncState.when(
      data: (state) {
        if (state.status != SyncStatus.syncing) {
          return const SizedBox.shrink();
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(40, 40),
              painter: _GeometricSyncPainter(
                progress: _controller.value,
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _GeometricSyncPainter extends CustomPainter {
  final double progress;
  final Color color;

  _GeometricSyncPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Draw three rotating triangles
    for (int i = 0; i < 3; i++) {
      final angle = (progress * 2 * math.pi) + (i * 2 * math.pi / 3);
      final path = Path();

      for (int j = 0; j < 3; j++) {
        final pointAngle = angle + (j * 2 * math.pi / 3);
        final x = center.dx + radius * math.cos(pointAngle);
        final y = center.dy + radius * math.sin(pointAngle);

        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();

      paint.color = color.withOpacity(0.3 + (i * 0.2));
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_GeometricSyncPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
