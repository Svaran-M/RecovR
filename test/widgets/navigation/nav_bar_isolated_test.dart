import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_tracker_pro/widgets/navigation/geometric_nav_bar.dart';
import 'package:rehab_tracker_pro/theme/app_theme.dart';

void main() {
  group('Professional NavigationBar Tests', () {
    testWidgets('should render with correct height (88px)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            bottomNavigationBar: GeometricNavBar(
              currentIndex: 0,
              onTap: (_) {},
              items: const [
                NavItem(label: 'Home', icon: Icons.home_outlined, route: '/'),
                NavItem(label: 'Routine', icon: Icons.fitness_center_outlined, route: '/routine'),
                NavItem(label: 'Measure', icon: Icons.straighten_outlined, route: '/rom'),
              ],
            ),
          ),
        ),
      );

      final navBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );

      expect(navBar.height, 88);
    });

    testWidgets('should use 28px icons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            bottomNavigationBar: GeometricNavBar(
              currentIndex: 0,
              onTap: (_) {},
              items: const [
                NavItem(label: 'Home', icon: Icons.home_outlined, route: '/'),
                NavItem(label: 'Routine', icon: Icons.fitness_center_outlined, route: '/routine'),
              ],
            ),
          ),
        ),
      );

      final icons = tester.widgetList<Icon>(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.byType(Icon),
        ),
      );

      for (final icon in icons) {
        expect(icon.size, 28);
      }
    });

    testWidgets('should always show labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            bottomNavigationBar: GeometricNavBar(
              currentIndex: 0,
              onTap: (_) {},
              items: const [
                NavItem(label: 'Home', icon: Icons.home_outlined, route: '/'),
                NavItem(label: 'Routine', icon: Icons.fitness_center_outlined, route: '/routine'),
                NavItem(label: 'Measure', icon: Icons.straighten_outlined, route: '/rom'),
              ],
            ),
          ),
        ),
      );

      // Verify all labels are visible
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Routine'), findsOneWidget);
      expect(find.text('Measure'), findsOneWidget);

      final navBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );

      expect(navBar.labelBehavior, NavigationDestinationLabelBehavior.alwaysShow);
    });

    testWidgets('should use simple, clear labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            bottomNavigationBar: GeometricNavBar(
              currentIndex: 0,
              onTap: (_) {},
              items: const [
                NavItem(label: 'Home', icon: Icons.home_outlined, route: '/'),
                NavItem(label: 'Routine', icon: Icons.fitness_center_outlined, route: '/routine'),
                NavItem(label: 'Measure', icon: Icons.straighten_outlined, route: '/rom'),
              ],
            ),
          ),
        ),
      );

      // Verify simple, clear labels (not "Dashboard", "ROM", etc.)
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Routine'), findsOneWidget);
      expect(find.text('Measure'), findsOneWidget);
    });

    testWidgets('should respond to taps', (WidgetTester tester) async {
      int tappedIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            bottomNavigationBar: GeometricNavBar(
              currentIndex: 0,
              onTap: (index) => tappedIndex = index,
              items: const [
                NavItem(label: 'Home', icon: Icons.home_outlined, route: '/'),
                NavItem(label: 'Routine', icon: Icons.fitness_center_outlined, route: '/routine'),
                NavItem(label: 'Measure', icon: Icons.straighten_outlined, route: '/rom'),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Routine'));
      await tester.pump();

      expect(tappedIndex, 1);
    });

    testWidgets('should have smooth 300ms animations', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            bottomNavigationBar: GeometricNavBar(
              currentIndex: 0,
              onTap: (_) {},
              items: const [
                NavItem(label: 'Home', icon: Icons.home_outlined, route: '/'),
                NavItem(label: 'Routine', icon: Icons.fitness_center_outlined, route: '/routine'),
              ],
            ),
          ),
        ),
      );

      final navBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );

      expect(navBar.animationDuration, const Duration(milliseconds: 300));
    });

    testWidgets('should show active state with subtle background', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            bottomNavigationBar: GeometricNavBar(
              currentIndex: 1,
              onTap: (_) {},
              items: const [
                NavItem(label: 'Home', icon: Icons.home_outlined, route: '/'),
                NavItem(label: 'Routine', icon: Icons.fitness_center_outlined, route: '/routine'),
              ],
            ),
          ),
        ),
      );

      final navBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );

      expect(navBar.selectedIndex, 1);
    });

    testWidgets('should work in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            bottomNavigationBar: GeometricNavBar(
              currentIndex: 0,
              onTap: (_) {},
              items: const [
                NavItem(label: 'Home', icon: Icons.home_outlined, route: '/'),
                NavItem(label: 'Routine', icon: Icons.fitness_center_outlined, route: '/routine'),
                NavItem(label: 'Measure', icon: Icons.straighten_outlined, route: '/rom'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Routine'), findsOneWidget);
      expect(find.text('Measure'), findsOneWidget);
    });
  });
}
