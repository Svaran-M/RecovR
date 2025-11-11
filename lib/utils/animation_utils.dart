import 'package:flutter/material.dart';
import '../theme/animation_curves.dart';

/// Utility class for common animation patterns
class AnimationUtils {
  /// Creates a spring animation controller
  static AnimationController createSpringController({
    required TickerProvider vsync,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    return AnimationController(
      vsync: vsync,
      duration: duration,
    );
  }
  
  /// Creates a pulsing animation that repeats
  static Animation<double> createPulseAnimation(
    AnimationController controller, {
    double minValue = 0.95,
    double maxValue = 1.05,
  }) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: maxValue)
            .chain(CurveTween(curve: AppCurves.pulse)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: maxValue, end: minValue)
            .chain(CurveTween(curve: AppCurves.pulse)),
        weight: 50,
      ),
    ]).animate(controller);
  }
  
  /// Creates a morphing animation for geometric shapes
  static Animation<double> createMorphAnimation(
    AnimationController controller, {
    Curve curve = AppCurves.geometricMorph,
  }) {
    return CurvedAnimation(
      parent: controller,
      curve: curve,
    );
  }
  
  /// Creates a staggered animation for multiple items
  static List<Animation<double>> createStaggeredAnimations({
    required AnimationController controller,
    required int itemCount,
    double staggerDelay = 0.1,
    Curve curve = AppCurves.elasticEntry,
  }) {
    final animations = <Animation<double>>[];
    
    for (int i = 0; i < itemCount; i++) {
      final start = (i * staggerDelay).clamp(0.0, 1.0);
      final end = ((i * staggerDelay) + (1.0 - staggerDelay)).clamp(0.0, 1.0);
      
      animations.add(
        CurvedAnimation(
          parent: controller,
          curve: Interval(start, end, curve: curve),
        ),
      );
    }
    
    return animations;
  }
  
  /// Creates a particle float animation
  static Animation<Offset> createParticleAnimation(
    AnimationController controller, {
    required Offset startOffset,
    required Offset endOffset,
  }) {
    return Tween<Offset>(
      begin: startOffset,
      end: endOffset,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: AppCurves.particleFloat,
      ),
    );
  }
  
  /// Creates a color transition animation
  static Animation<Color?> createColorAnimation(
    AnimationController controller, {
    required Color startColor,
    required Color endColor,
    Curve curve = Curves.easeInOut,
  }) {
    return ColorTween(
      begin: startColor,
      end: endColor,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );
  }
  
  /// Creates a rotation animation
  static Animation<double> createRotationAnimation(
    AnimationController controller, {
    double turns = 1.0,
    Curve curve = Curves.easeInOut,
  }) {
    return Tween<double>(
      begin: 0.0,
      end: turns,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );
  }
}

/// Mixin for widgets that need spring animations
mixin SpringAnimationMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late AnimationController springController;
  late Animation<double> springAnimation;
  
  void initSpringAnimation({
    Duration duration = const Duration(milliseconds: 800),
    double begin = 0.0,
    double end = 1.0,
  }) {
    springController = AnimationController(
      vsync: this,
      duration: duration,
    );
    
    springAnimation = Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: springController,
        curve: AppCurves.customSpring,
      ),
    );
  }
  
  void disposeSpringAnimation() {
    springController.dispose();
  }
  
  void playSpringAnimation() {
    springController.forward(from: 0.0);
  }
  
  void reverseSpringAnimation() {
    springController.reverse(from: 1.0);
  }
}

/// Mixin for widgets that need pulse animations
mixin PulseAnimationMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late AnimationController pulseController;
  late Animation<double> pulseAnimation;
  
  void initPulseAnimation({
    Duration duration = const Duration(milliseconds: 1500),
    double minValue = 0.95,
    double maxValue = 1.05,
  }) {
    pulseController = AnimationController(
      vsync: this,
      duration: duration,
    );
    
    pulseAnimation = AnimationUtils.createPulseAnimation(
      pulseController,
      minValue: minValue,
      maxValue: maxValue,
    );
  }
  
  void disposePulseAnimation() {
    pulseController.dispose();
  }
  
  void startPulse() {
    pulseController.repeat();
  }
  
  void stopPulse() {
    pulseController.stop();
  }
}
