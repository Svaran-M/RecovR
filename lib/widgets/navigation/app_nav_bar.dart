import 'package:flutter/material.dart';

// Nav item data
class NavItem {
  final String label;
  final IconData icon;
  final String route;

  const NavItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}

// Navigation bar with 88px height, 28px icons, 16px labels
class AppNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavItem> items;

  const AppNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 88,
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      animationDuration: const Duration(milliseconds: 300),
      destinations: items.map((item) {
        return NavigationDestination(
          icon: Icon(item.icon, size: 28),
          selectedIcon: Icon(item.icon, size: 28),
          label: item.label,
        );
      }).toList(),
    );
  }
}
