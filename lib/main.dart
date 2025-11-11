import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'widgets/app_error_widget.dart';

void main() {
  // custom error widget
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return AppErrorWidget(errorDetails: details);
  };

  runApp(
    const ProviderScope(
      child: RehabTrackerProApp(),
    ),
  );
}

class RehabTrackerProApp extends ConsumerWidget {
  const RehabTrackerProApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'RehabTracker Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
