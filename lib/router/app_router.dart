import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/routine/routine_screen.dart';
import '../features/rom_measurement/rom_screen.dart';
import '../widgets/navigation/app_shell.dart';
import '../utils/animation_constants.dart';

// Smooth page transitions
class SmoothPageTransition extends CustomTransitionPage<void> {
  SmoothPageTransition({
    required super.child,
    super.key,
  }) : super(
          transitionDuration: AnimationConstants.pageTransition,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fadeAnimation = Tween<double>(
              begin: AnimationConstants.fadeFrom,
              end: AnimationConstants.fadeTo,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: AnimationConstants.defaultCurve,
              ),
            );

            final scaleAnimation = Tween<double>(
              begin: AnimationConstants.scaleFrom,
              end: AnimationConstants.scaleTo,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: AnimationConstants.defaultCurve,
              ),
            );

            return FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            );
          },
        );
}

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(
          currentRoute: state.uri.toString(),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'dashboard',
          pageBuilder: (context, state) => SmoothPageTransition(
            key: state.pageKey,
            child: const DashboardScreen(),
          ),
        ),
        GoRoute(
          path: '/routine',
          name: 'routine',
          pageBuilder: (context, state) => SmoothPageTransition(
            key: state.pageKey,
            child: const RoutineScreen(),
          ),
        ),
        GoRoute(
          path: '/rom',
          name: 'rom',
          pageBuilder: (context, state) => SmoothPageTransition(
            key: state.pageKey,
            child: const ROMScreen(),
          ),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);
