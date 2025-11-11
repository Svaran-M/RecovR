import 'package:flutter/animation.dart';
import 'dart:math' as math;

class AppCurves {
  // Spring-like elastic curves
  static const Curve elasticEntry = Curves.elasticOut;
  static const Curve elasticExit = Curves.elasticIn;
  
  // Smooth geometric morphing
  static const Curve geometricMorph = Curves.easeInOutCubic;
  
  // Quick attention-grabbing animations
  static const Curve pulse = Curves.easeInOutQuad;
  
  // Smooth transitions
  static const Curve smoothTransition = Curves.easeInOutCubicEmphasized;
  
  // Custom spring curve for particle effects
  static const Curve particleFloat = Curves.easeOutQuart;
  
  // Custom spring-like curve with configurable parameters
  static const Curve customSpring = SpringCurve();
  
  // Bouncy entrance for geometric shapes
  static const Curve geometricBounce = GeometricBounceCurve();
}

/// Custom spring curve for smooth, natural animations
class SpringCurve extends Curve {
  final double damping;
  final double stiffness;
  
  const SpringCurve({
    this.damping = 0.7,
    this.stiffness = 180.0,
  });
  
  @override
  double transformInternal(double t) {
    final omega = math.sqrt(stiffness);
    final zeta = damping / (2.0 * math.sqrt(stiffness));
    
    if (zeta < 1.0) {
      // Underdamped spring
      final omegaD = omega * math.sqrt(1.0 - zeta * zeta);
      final envelope = math.exp(-zeta * omega * t);
      final phase = math.cos(omegaD * t) + (zeta * omega / omegaD) * math.sin(omegaD * t);
      return 1.0 - envelope * phase;
    } else {
      // Critically damped or overdamped
      return 1.0 - math.exp(-omega * t) * (1.0 + omega * t);
    }
  }
}

/// Custom bounce curve for geometric shape entrances
class GeometricBounceCurve extends Curve {
  const GeometricBounceCurve();
  
  @override
  double transformInternal(double t) {
    if (t < 0.5) {
      return 2.0 * t * t;
    } else {
      final f = t - 0.5;
      return 1.0 - 2.0 * f * f;
    }
  }
}
