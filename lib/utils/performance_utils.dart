import 'package:flutter/material.dart';

/// Utility class for performance optimizations
class PerformanceUtils {
  /// Wraps a widget with RepaintBoundary for expensive repaints isolation
  static Widget withRepaintBoundary(Widget child, {Key? key}) {
    return RepaintBoundary(
      key: key,
      child: child,
    );
  }

  /// Checks if reduced motion is preferred by the user
  static bool shouldReduceMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Returns animation duration based on user preferences
  static Duration getAnimationDuration(
    BuildContext context, {
    Duration normal = const Duration(milliseconds: 300),
    Duration reduced = const Duration(milliseconds: 100),
  }) {
    return shouldReduceMotion(context) ? reduced : normal;
  }

  /// Returns curve based on user preferences
  static Curve getAnimationCurve(
    BuildContext context, {
    Curve normal = Curves.easeInOut,
    Curve reduced = Curves.linear,
  }) {
    return shouldReduceMotion(context) ? reduced : normal;
  }
}

/// Mixin for widgets that need performance monitoring
mixin PerformanceMonitoring {
  /// Logs performance metrics (can be extended with custom metrics)
  void logPerformanceMetric(String name, Duration duration) {
    // In production, this could send to analytics
    debugPrint('Performance: $name took ${duration.inMilliseconds}ms');
  }

  /// Measures execution time of a function
  Future<T> measurePerformance<T>(
    String name,
    Future<T> Function() function,
  ) async {
    final stopwatch = Stopwatch()..start();
    try {
      return await function();
    } finally {
      stopwatch.stop();
      logPerformanceMetric(name, stopwatch.elapsed);
    }
  }
}

/// Widget that adds RepaintBoundary automatically
class OptimizedWidget extends StatelessWidget {
  final Widget child;
  final bool addRepaintBoundary;

  const OptimizedWidget({
    super.key,
    required this.child,
    this.addRepaintBoundary = true,
  });

  @override
  Widget build(BuildContext context) {
    if (addRepaintBoundary) {
      return RepaintBoundary(child: child);
    }
    return child;
  }
}

/// Performance mode manager for graceful degradation
class PerformanceModeManager {
  static bool _performanceModeEnabled = false;
  static int _jankFrameCount = 0;
  static const int _jankThreshold = 10;

  /// Check if performance mode is active
  static bool get isPerformanceModeActive => _performanceModeEnabled;

  /// Enable performance mode (reduces animations and effects)
  static void enablePerformanceMode() {
    _performanceModeEnabled = true;
    debugPrint('Performance mode enabled - reducing animations');
  }

  /// Disable performance mode
  static void disablePerformanceMode() {
    _performanceModeEnabled = false;
    _jankFrameCount = 0;
    debugPrint('Performance mode disabled');
  }

  /// Record a jank frame and potentially enable performance mode
  static void recordJankFrame() {
    _jankFrameCount++;
    if (_jankFrameCount > _jankThreshold && !_performanceModeEnabled) {
      enablePerformanceMode();
    }
  }

  /// Reset jank frame counter
  static void resetJankCounter() {
    _jankFrameCount = 0;
  }

  /// Get animation duration based on performance mode
  static Duration getAdaptiveDuration({
    Duration normal = const Duration(milliseconds: 300),
    Duration performance = const Duration(milliseconds: 150),
  }) {
    return _performanceModeEnabled ? performance : normal;
  }

  /// Get curve based on performance mode
  static Curve getAdaptiveCurve({
    Curve normal = Curves.easeInOut,
    Curve performance = Curves.linear,
  }) {
    return _performanceModeEnabled ? performance : normal;
  }
}
