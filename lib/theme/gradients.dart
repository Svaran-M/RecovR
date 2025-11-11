import 'package:flutter/material.dart';

class AppGradients {
  // Primary gradients - using professional colors
  static const LinearGradient primary = LinearGradient(
    colors: [
      Color(0xFF0061A4), // Primary blue
      Color(0xFF00497D), // Primary container
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondary = LinearGradient(
    colors: [
      Color(0xFF535F70), // Secondary
      Color(0xFF6B5778), // Tertiary
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accent = LinearGradient(
    colors: [
      Color(0xFF6B5778), // Tertiary
      Color(0xFF0061A4), // Primary
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Radial gradients for depth effects
  static const RadialGradient radialPrimary = RadialGradient(
    colors: [
      Color(0xFF0061A4),
      Color(0xFF00497D),
    ],
    center: Alignment.center,
    radius: 1.0,
  );

  // Severity level gradients for symptom tracking
  static const LinearGradient severityLow = LinearGradient(
    colors: [
      Color(0xFF00C853), // Green
      Color(0xFF64DD17), // Light green
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient severityMedium = LinearGradient(
    colors: [
      Color(0xFFFFA726), // Orange
      Color(0xFFFF9800), // Darker orange
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient severityHigh = LinearGradient(
    colors: [
      Color(0xFFBA1A1A), // Error red
      Color(0xFFD32F2F), // Darker red
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient success = LinearGradient(
    colors: [
      Color(0xFF00C853),
      Color(0xFF00A344),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Utility methods for creating custom gradients
  
  /// Creates a linear gradient with custom colors and direction
  static LinearGradient createLinear({
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    List<double>? stops,
  }) {
    return LinearGradient(
      colors: colors,
      begin: begin,
      end: end,
      stops: stops,
    );
  }
  
  /// Creates a radial gradient with custom colors
  static RadialGradient createRadial({
    required List<Color> colors,
    AlignmentGeometry center = Alignment.center,
    double radius = 1.0,
    List<double>? stops,
  }) {
    return RadialGradient(
      colors: colors,
      center: center,
      radius: radius,
      stops: stops,
    );
  }
  
  /// Creates a sweep gradient for circular effects
  static SweepGradient createSweep({
    required List<Color> colors,
    AlignmentGeometry center = Alignment.center,
    double startAngle = 0.0,
    double endAngle = 6.283185307179586, // 2 * pi
    List<double>? stops,
  }) {
    return SweepGradient(
      colors: colors,
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
      stops: stops,
    );
  }
  
  /// Creates a gradient based on severity level (0-10)
  static LinearGradient getSeverityGradient(int level) {
    if (level <= 3) {
      return severityLow;
    } else if (level <= 6) {
      return severityMedium;
    } else {
      return severityHigh;
    }
  }
  
  /// Creates an animated gradient by interpolating between two gradients
  static LinearGradient lerpGradient(
    LinearGradient a,
    LinearGradient b,
    double t,
  ) {
    final colors = List.generate(
      a.colors.length,
      (i) => Color.lerp(
        a.colors[i],
        b.colors[i < b.colors.length ? i : b.colors.length - 1],
        t,
      )!,
    );
    
    return LinearGradient(
      colors: colors,
      begin: AlignmentGeometry.lerp(a.begin, b.begin, t)!,
      end: AlignmentGeometry.lerp(a.end, b.end, t)!,
    );
  }
}
