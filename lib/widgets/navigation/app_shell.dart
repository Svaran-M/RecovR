import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_nav_bar.dart';

/// App shell with navigation
class AppShell extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const AppShell({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _navItems = [
    NavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      route: '/',
    ),
    NavItem(
      label: 'Routine',
      icon: Icons.fitness_center_outlined,
      route: '/routine',
    ),
    NavItem(
      label: 'Measure',
      icon: Icons.straighten_outlined,
      route: '/rom',
    ),
  ];

  int get _currentIndex {
    final route = widget.currentRoute;
    if (route == '/') return 0;
    if (route.startsWith('/routine')) return 1;
    if (route.startsWith('/rom')) return 2;
    return 0;
  }

  void _onNavTap(int index) {
    if (index != _currentIndex) {
      context.go(_navItems[index].route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: AppNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        items: _navItems,
      ),
    );
  }
}
