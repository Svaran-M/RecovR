import 'package:flutter/material.dart';

/// Animation constants for consistent micro-interactions throughout the app
/// All animations are subtle and professional (200-300ms duration)
class AnimationConstants {
  AnimationConstants._();
  
  // Duration constants
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  
  // Standard durations for specific interactions
  static const Duration buttonPress = Duration(milliseconds: 200);
  static const Duration cardExpand = Duration(milliseconds: 300);
  static const Duration pageTransition = Duration(milliseconds: 250);
  static const Duration fadeIn = Duration(milliseconds: 200);
  static const Duration slideIn = Duration(milliseconds: 250);
  static const Duration scaleIn = Duration(milliseconds: 200);
  
  // Curves for professional feel
  static const Curve defaultCurve = Curves.easeInOutCubic;
  static const Curve entranceCurve = Curves.easeOut;
  static const Curve exitCurve = Curves.easeIn;
  static const Curve bounceCurve = Curves.easeOutBack;
  static const Curve smoothCurve = Curves.easeInOutCubic;
  
  // Offset values for slide animations
  static const Offset slideFromBottom = Offset(0, 0.3);
  static const Offset slideFromTop = Offset(0, -0.3);
  static const Offset slideFromLeft = Offset(-0.3, 0);
  static const Offset slideFromRight = Offset(0.3, 0);
  
  // Scale values
  static const double scaleFrom = 0.95;
  static const double scaleTo = 1.0;
  
  // Opacity values
  static const double fadeFrom = 0.0;
  static const double fadeTo = 1.0;
}

/// Reusable animation builders for consistent micro-interactions
class AnimationBuilders {
  AnimationBuilders._();
  
  /// Fade in animation
  static Widget fadeIn({
    required Widget child,
    Duration duration = AnimationConstants.fadeIn,
    Curve curve = AnimationConstants.entranceCurve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: AnimationConstants.fadeFrom, end: AnimationConstants.fadeTo),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }
  
  /// Slide and fade in animation
  static Widget slideAndFadeIn({
    required Widget child,
    Duration duration = AnimationConstants.slideIn,
    Curve curve = AnimationConstants.entranceCurve,
    Offset offset = AnimationConstants.slideFromBottom,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            offset.dx * (1 - value) * 50,
            offset.dy * (1 - value) * 50,
          ),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
  
  /// Scale and fade in animation
  static Widget scaleAndFadeIn({
    required Widget child,
    Duration duration = AnimationConstants.scaleIn,
    Curve curve = AnimationConstants.entranceCurve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        final scale = AnimationConstants.scaleFrom + 
                     (AnimationConstants.scaleTo - AnimationConstants.scaleFrom) * value;
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
  
  /// Animated counter for numbers
  static Widget animatedCounter({
    required int value,
    required TextStyle? style,
    Duration duration = AnimationConstants.normal,
    Curve curve = AnimationConstants.smoothCurve,
  }) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Text(
          value.toString(),
          style: style,
        );
      },
    );
  }
  
  /// Animated progress indicator
  static Widget animatedProgress({
    required double value,
    required Widget child,
    Duration duration = AnimationConstants.normal,
    Curve curve = AnimationConstants.smoothCurve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: value),
      duration: duration,
      curve: curve,
      builder: (context, animatedValue, child) {
        return child!;
      },
      child: child,
    );
  }
}

/// Page transition builders for smooth navigation
class PageTransitions {
  PageTransitions._();
  
  /// Fade transition
  static Widget fade(BuildContext context, Animation<double> animation, 
                     Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
  
  /// Slide from right transition
  static Widget slideFromRight(BuildContext context, Animation<double> animation,
                               Animation<double> secondaryAnimation, Widget child) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: AnimationConstants.defaultCurve),
    );
    final offsetAnimation = animation.drive(tween);
    
    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
  
  /// Slide from bottom transition
  static Widget slideFromBottom(BuildContext context, Animation<double> animation,
                                Animation<double> secondaryAnimation, Widget child) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: AnimationConstants.defaultCurve),
    );
    final offsetAnimation = animation.drive(tween);
    
    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
  
  /// Scale and fade transition
  static Widget scaleAndFade(BuildContext context, Animation<double> animation,
                            Animation<double> secondaryAnimation, Widget child) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: AnimationConstants.scaleFrom,
        end: AnimationConstants.scaleTo,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: AnimationConstants.defaultCurve,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

/// Loading state widgets with skeleton screens
class LoadingStates {
  LoadingStates._();
  
  /// Skeleton box with shimmer effect
  static Widget skeletonBox({
    required double width,
    required double height,
    BorderRadius? borderRadius,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(value),
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
        );
      },
    );
  }
  
  /// Skeleton text line
  static Widget skeletonText({
    required double width,
    double height = 16,
  }) {
    return skeletonBox(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(4),
    );
  }
  
  /// Skeleton circle (for avatars, icons)
  static Widget skeletonCircle({
    required double size,
  }) {
    return skeletonBox(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }
}

/// Success animation widgets
class SuccessAnimations {
  SuccessAnimations._();
  
  /// Checkmark animation
  static Widget checkmark({
    required bool show,
    Color? color,
    double size = 48,
  }) {
    return AnimatedScale(
      scale: show ? 1.0 : 0.0,
      duration: AnimationConstants.normal,
      curve: AnimationConstants.bounceCurve,
      child: AnimatedOpacity(
        opacity: show ? 1.0 : 0.0,
        duration: AnimationConstants.fadeIn,
        child: Icon(
          Icons.check_circle,
          size: size,
          color: color,
        ),
      ),
    );
  }
  
  /// Success banner
  static Widget banner({
    required bool show,
    required String message,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return AnimatedSlide(
      offset: show ? Offset.zero : const Offset(0, -1),
      duration: AnimationConstants.slideIn,
      curve: AnimationConstants.entranceCurve,
      child: AnimatedOpacity(
        opacity: show ? 1.0 : 0.0,
        duration: AnimationConstants.fadeIn,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
