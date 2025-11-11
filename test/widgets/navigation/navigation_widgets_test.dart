import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_tracker_pro/widgets/navigation/geometric_nav_bar.dart';
import 'package:rehab_tracker_pro/widgets/navigation/geometric_breadcrumb.dart';
import 'package:rehab_tracker_pro/router/app_router.dart';

void main() {
  group('GeometricNavBar Tests', () {
    testWidgets('should render navigation items', (WidgetTester tester) async {
      int tappedIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: GeometricNavBar(
              currentIndex: 0,
              onTap: (index) => tappedIndex = index,
              items: const [
                NavItem(label: 'Home', icon: Icons.home, route: '/'),
                NavItem(label: 'Settings', icon: Icons.settings, route: '/settings'),
                NavItem(label: 'Profile', icon: Icons.person, route: '/profile'),
              ],
            ),
          ),
        ),
      );

      // Verify NavigationBar is rendered
      expect(find.byType(NavigationBar), findsOneWidget);
      
      // Verify all labels are rendered
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('should respond to tap gestures', (WidgetTester tester) async {
      int tappedIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: GeometricNavBar(
              currentIndex: 0,
              onTap: (index) => tappedIndex = index,
              items: const [
                NavItem(label: 'Home', icon: Icons.home, route: '/'),
                NavItem(label: 'Settings', icon: Icons.settings, route: '/settings'),
              ],
            ),
          ),
        ),
      );

      // Tap settings destination
      await tester.tap(find.text('Settings'));
      await tester.pump();

      expect(tappedIndex, 1);
    });

    testWidgets('should show active state for current index',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: GeometricNavBar(
              currentIndex: 1,
              onTap: (_) {},
              items: const [
                NavItem(label: 'Home', icon: Icons.home, route: '/'),
                NavItem(label: 'Settings', icon: Icons.settings, route: '/settings'),
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

    testWidgets('should have 88px height for easy tapping',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: GeometricNavBar(
              currentIndex: 0,
              onTap: (_) {},
              items: const [
                NavItem(label: 'Home', icon: Icons.home, route: '/'),
                NavItem(label: 'Settings', icon: Icons.settings, route: '/settings'),
              ],
            ),
          ),
        ),
      );

      final navBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );

      // Verify height is 88px as specified in requirements
      expect(navBar.height, 88);
    });

    testWidgets('should use 28px icons for clarity',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: GeometricNavBar(
              currentIndex: 0,
              onTap: (_) {},
              items: const [
                NavItem(label: 'Home', icon: Icons.home, route: '/'),
              ],
            ),
          ),
        ),
      );

      // Find icon widgets
      final icons = tester.widgetList<Icon>(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.byType(Icon),
        ),
      );

      // Verify icons have 28px size
      for (final icon in icons) {
        expect(icon.size, 28);
      }
    });

    testWidgets('should always show labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: GeometricNavBar(
              currentIndex: 0,
              onTap: (_) {},
              items: const [
                NavItem(label: 'Home', icon: Icons.home, route: '/'),
                NavItem(label: 'Settings', icon: Icons.settings, route: '/settings'),
              ],
            ),
          ),
        ),
      );

      final navBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );

      // Verify labels are always shown
      expect(navBar.labelBehavior, NavigationDestinationLabelBehavior.alwaysShow);
    });

    testWidgets('should have smooth transition animations', (WidgetTester tester) async {
      int currentIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: GeometricNavBar(
                  currentIndex: currentIndex,
                  onTap: (index) {
                    setState(() => currentIndex = index);
                  },
                  items: const [
                    NavItem(label: 'Home', icon: Icons.home, route: '/'),
                    NavItem(label: 'Settings', icon: Icons.settings, route: '/settings'),
                  ],
                ),
              );
            },
          ),
        ),
      );

      final navBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );

      // Verify animation duration is 300ms
      expect(navBar.animationDuration, const Duration(milliseconds: 300));

      // Tap to change state
      await tester.tap(find.text('Settings'));
      await tester.pump();

      // Pump animation frames
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(const Duration(milliseconds: 150));
    });
  });

  group('GeometricBreadcrumb Tests', () {
    testWidgets('should render breadcrumb items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GeometricBreadcrumb(
              items: const [
                BreadcrumbItem(label: 'Home', route: '/'),
                BreadcrumbItem(label: 'Settings', route: '/settings'),
                BreadcrumbItem(label: 'Profile'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('should render separators between items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GeometricBreadcrumb(
              items: const [
                BreadcrumbItem(label: 'Home', route: '/'),
                BreadcrumbItem(label: 'Settings'),
              ],
            ),
          ),
        ),
      );

      // Verify CustomPaint is used for separators
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('should handle tap on clickable items',
        (WidgetTester tester) async {
      String? tappedRoute;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GeometricBreadcrumb(
              items: const [
                BreadcrumbItem(label: 'Home', route: '/'),
                BreadcrumbItem(label: 'Settings', route: '/settings'),
                BreadcrumbItem(label: 'Profile'),
              ],
              onTap: (route) => tappedRoute = route,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Home'));
      await tester.pump();

      expect(tappedRoute, '/');
    });

    testWidgets('should not trigger tap on last item',
        (WidgetTester tester) async {
      String? tappedRoute;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GeometricBreadcrumb(
              items: const [
                BreadcrumbItem(label: 'Home', route: '/'),
                BreadcrumbItem(label: 'Profile'),
              ],
              onTap: (route) => tappedRoute = route,
            ),
          ),
        ),
      );

      // Tap last item (should not trigger)
      await tester.tap(find.text('Profile'));
      await tester.pump();

      expect(tappedRoute, isNull);
    });

    testWidgets('should show visual feedback for active item',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GeometricBreadcrumb(
              items: const [
                BreadcrumbItem(label: 'Home', route: '/'),
                BreadcrumbItem(label: 'Profile'),
              ],
            ),
          ),
        ),
      );

      // Verify AnimatedContainer is used for visual feedback
      expect(find.byType(AnimatedContainer), findsWidgets);
    });

    testWidgets('should not trigger tap on items without route',
        (WidgetTester tester) async {
      String? tappedRoute;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GeometricBreadcrumb(
              items: const [
                BreadcrumbItem(label: 'Home'),
              ],
              onTap: (route) => tappedRoute = route,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Home'));
      await tester.pump();

      expect(tappedRoute, isNull);
    });
  });

  group('Navigation Accessibility Tests', () {
    testWidgets('GeometricNavBar should have accessible labels and icons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
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

      // Verify all labels are accessible and always visible
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Routine'), findsOneWidget);
      expect(find.text('Measure'), findsOneWidget);
      
      // Verify NavigationBar is used (Material 3 accessible component)
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('Breadcrumb should have accessible text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GeometricBreadcrumb(
              items: const [
                BreadcrumbItem(label: 'Home', route: '/'),
                BreadcrumbItem(label: 'Settings'),
              ],
            ),
          ),
        ),
      );

      // Verify text is accessible
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });
  });

  group('Navigation Responsiveness Tests', () {
    testWidgets('GeometricNavBar should render on small screens',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(375, 667); // iPhone SE size
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: GeometricNavBar(
              currentIndex: 0,
              onTap: (_) {},
              items: const [
                NavItem(label: 'Home', icon: Icons.home, route: '/'),
                NavItem(label: 'Settings', icon: Icons.settings, route: '/settings'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(GeometricNavBar), findsOneWidget);
    });

    testWidgets('GeometricNavBar should render on large screens',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080); // Desktop size
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: GeometricNavBar(
              currentIndex: 0,
              onTap: (_) {},
              items: const [
                NavItem(label: 'Home', icon: Icons.home, route: '/'),
                NavItem(label: 'Settings', icon: Icons.settings, route: '/settings'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(GeometricNavBar), findsOneWidget);
    });

    testWidgets('Breadcrumb should adapt to screen size',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GeometricBreadcrumb(
              items: const [
                BreadcrumbItem(label: 'Home', route: '/'),
                BreadcrumbItem(label: 'Settings'),
              ],
            ),
          ),
        ),
      );

      // Verify Wrap widget is used for responsive layout
      expect(find.byType(Wrap), findsOneWidget);
    });
  });

  group('Router Integration Tests', () {
    test('should verify router configuration exists', () {
      // Verify the router is properly configured
      expect(appRouter, isNotNull);
      expect(appRouter.configuration.routes, isNotEmpty);
    });
  });
}
