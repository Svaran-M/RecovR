import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Clean, borderless trend chart with professional styling
/// Uses subtle dividers instead of boxes
class TrendChart extends StatefulWidget {
  final List<double> dataPoints;
  final List<String> labels;
  final String title;
  final double height;

  const TrendChart({
    super.key,
    required this.dataPoints,
    required this.labels,
    required this.title,
    this.height = 220,
  });

  @override
  State<TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends State<TrendChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subtle divider above
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Divider(
            color: colorScheme.outlineVariant.withOpacity(0.3),
            thickness: 1,
          ),
        ),
        const SizedBox(height: 24),
        
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            widget.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Chart
        SizedBox(
          height: widget.height,
          child: RepaintBoundary(
            child: GestureDetector(
              onTapDown: (details) {
                _handleTap(details.localPosition);
              },
              onTapUp: (_) {
                setState(() {
                  _selectedIndex = null;
                });
              },
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _TrendChartPainter(
                      dataPoints: widget.dataPoints,
                      labels: widget.labels,
                      animationProgress: _animationController.value,
                      selectedIndex: _selectedIndex,
                      primaryColor: colorScheme.primary,
                      secondaryColor: colorScheme.secondary,
                      surfaceColor: colorScheme.surface,
                      onSurfaceColor: colorScheme.onSurface,
                      outlineColor: colorScheme.outlineVariant,
                    ),
                    size: Size(double.infinity, widget.height),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleTap(Offset position) {
    if (widget.dataPoints.isEmpty) return;

    final chartWidth = context.size?.width ?? 0;
    final padding = 40.0;
    final availableWidth = chartWidth - padding * 2;
    final segmentWidth = widget.dataPoints.length > 1
        ? availableWidth / (widget.dataPoints.length - 1)
        : 0;

    for (int i = 0; i < widget.dataPoints.length; i++) {
      final x = widget.dataPoints.length > 1
          ? padding + i * segmentWidth
          : padding + availableWidth / 2;
      if ((position.dx - x).abs() < 30) {
        setState(() {
          _selectedIndex = i;
        });
        break;
      }
    }
  }
}

class _TrendChartPainter extends CustomPainter {
  final List<double> dataPoints;
  final List<String> labels;
  final double animationProgress;
  final int? selectedIndex;
  final Color primaryColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color onSurfaceColor;
  final Color outlineColor;

  _TrendChartPainter({
    required this.dataPoints,
    required this.labels,
    required this.animationProgress,
    this.selectedIndex,
    required this.primaryColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.onSurfaceColor,
    required this.outlineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final padding = 40.0;
    final chartHeight = size.height - padding * 2;
    final chartWidth = size.width - padding * 2;

    // Draw subtle grid lines
    _drawGrid(canvas, size, padding);

    // Calculate data point positions
    final maxValue = dataPoints.reduce(math.max);
    final minValue = dataPoints.reduce(math.min);
    final valueRange = maxValue - minValue;

    final points = <Offset>[];
    for (int i = 0; i < dataPoints.length; i++) {
      final x = dataPoints.length > 1
          ? padding + (i / (dataPoints.length - 1)) * chartWidth
          : padding + chartWidth / 2;
      final normalizedValue = valueRange > 0
          ? (dataPoints[i] - minValue) / valueRange
          : 0.5;
      final y = size.height - padding - (normalizedValue * chartHeight);
      points.add(Offset(x, y));
    }

    // Draw animated path
    _drawAnimatedPath(canvas, points, animationProgress);

    // Draw data points
    _drawDataPoints(canvas, points, animationProgress);

    // Draw labels
    _drawLabels(canvas, size, points, padding);

    // Draw tooltip if point is selected
    if (selectedIndex != null && selectedIndex! < points.length) {
      _drawTooltip(
        canvas,
        points[selectedIndex!],
        dataPoints[selectedIndex!],
        labels[selectedIndex!],
      );
    }
  }

  void _drawGrid(Canvas canvas, Size size, double padding) {
    final paint = Paint()
      ..color = outlineColor.withOpacity(0.2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw horizontal grid lines
    for (int i = 0; i < 4; i++) {
      final y = padding + (i / 3) * (size.height - padding * 2);
      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width - padding, y),
        paint,
      );
    }
  }

  void _drawAnimatedPath(Canvas canvas, List<Offset> points, double progress) {
    if (points.length < 2) return;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    final visiblePoints = (points.length * progress).ceil();
    for (int i = 1; i < visiblePoints && i < points.length; i++) {
      final t = ((progress * points.length) - i + 1).clamp(0.0, 1.0);
      final easedT = Curves.easeOutCubic.transform(t);

      final currentPoint = points[i];
      final prevPoint = points[i - 1];

      final animatedPoint = Offset(
        prevPoint.dx + (currentPoint.dx - prevPoint.dx) * easedT,
        prevPoint.dy + (currentPoint.dy - prevPoint.dy) * easedT,
      );

      final controlPoint = Offset(
        (prevPoint.dx + animatedPoint.dx) / 2,
        (prevPoint.dy + animatedPoint.dy) / 2,
      );

      path.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        animatedPoint.dx,
        animatedPoint.dy,
      );
    }

    // Draw path with gradient
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [primaryColor, secondaryColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(path.getBounds())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  }

  void _drawDataPoints(Canvas canvas, List<Offset> points, double progress) {
    for (int i = 0; i < points.length; i++) {
      final pointProgress = ((progress * points.length) - i).clamp(0.0, 1.0);
      if (pointProgress <= 0) continue;

      final point = points[i];
      final isSelected = selectedIndex == i;
      final radius = (isSelected ? 6.0 : 4.0) * pointProgress;

      // Draw circle
      final fillPaint = Paint()
        ..color = isSelected ? secondaryColor : primaryColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(point, radius, fillPaint);

      // Draw border
      final borderPaint = Paint()
        ..color = surfaceColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(point, radius, borderPaint);
    }
  }

  void _drawLabels(Canvas canvas, Size size, List<Offset> points, double padding) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < labels.length && i < points.length; i++) {
      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          color: onSurfaceColor.withOpacity(0.6),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          points[i].dx - textPainter.width / 2,
          size.height - padding + 10,
        ),
      );
    }
  }

  void _drawTooltip(Canvas canvas, Offset position, double value, String label) {
    final tooltipWidth = 80.0;
    final tooltipHeight = 56.0;
    final left = position.dx - tooltipWidth / 2;
    final top = position.dy - tooltipHeight - 16;

    // Draw rounded rectangle tooltip
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, tooltipWidth, tooltipHeight),
      const Radius.circular(8),
    );

    // Background
    final bgPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rect, bgPaint);

    // Border
    final borderPaint = Paint()
      ..color = surfaceColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(rect, borderPaint);

    // Draw pointer
    final pointerPath = Path()
      ..moveTo(position.dx, position.dy - 8)
      ..lineTo(position.dx - 6, top + tooltipHeight)
      ..lineTo(position.dx + 6, top + tooltipHeight)
      ..close();
    canvas.drawPath(pointerPath, bgPaint);

    // Draw text
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.text = TextSpan(
      children: [
        TextSpan(
          text: '${value.toStringAsFixed(1)}°\n',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextSpan(
          text: label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        top + (tooltipHeight - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(_TrendChartPainter oldDelegate) {
    if (oldDelegate.animationProgress != animationProgress) return true;
    if (oldDelegate.selectedIndex != selectedIndex) return true;
    if (oldDelegate.dataPoints.length != dataPoints.length) return true;
    
    for (int i = 0; i < dataPoints.length; i++) {
      if (oldDelegate.dataPoints[i] != dataPoints[i]) return true;
    }
    
    return false;
  }
}
