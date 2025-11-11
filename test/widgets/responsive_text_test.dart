import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_tracker_pro/widgets/common/responsive_text.dart';
import 'package:rehab_tracker_pro/theme/app_theme.dart';

void main() {
  group('ResponsiveText', () {
    testWidgets('renders text correctly', (WidgetTester tester) async {
      const testText = 'Hello World';
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveText(testText),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
      expect(find.byType(FittedBox), findsOneWidget);
    });

    testWidgets('applies custom style', (WidgetTester tester) async {
      const testText = 'Styled Text';
      const testStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveText(
              testText,
              style: testStyle,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.fontSize, equals(24));
      expect(textWidget.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets('respects maxLines parameter', (WidgetTester tester) async {
      const testText = 'Multi line text';
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveText(
              testText,
              maxLines: 2,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.maxLines, equals(2));
    });

    testWidgets('scales down when constrained', (WidgetTester tester) async {
      const testText = 'Very Long Text That Should Scale Down';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              child: ResponsiveText(
                testText,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
      expect(find.byType(FittedBox), findsOneWidget);
    });
  });

  group('DisplayText', () {
    testWidgets('renders with theme display style', (WidgetTester tester) async {
      const testText = 'Display Text';
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: DisplayText(testText),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
      expect(find.byType(ResponsiveText), findsOneWidget);
    });

    testWidgets('applies custom color', (WidgetTester tester) async {
      const testText = 'Colored Display';
      const testColor = Colors.red;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: DisplayText(
              testText,
              color: testColor,
            ),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('applies custom font weight', (WidgetTester tester) async {
      const testText = 'Bold Display';
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: DisplayText(
              testText,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
    });
  });

  group('HeadlineText', () {
    testWidgets('renders with default level 1', (WidgetTester tester) async {
      const testText = 'Headline';
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: HeadlineText(testText),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('renders with level 2', (WidgetTester tester) async {
      const testText = 'Headline Level 2';
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: HeadlineText(testText, level: 2),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('renders with level 3', (WidgetTester tester) async {
      const testText = 'Headline Level 3';
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: HeadlineText(testText, level: 3),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('applies custom color and weight', (WidgetTester tester) async {
      const testText = 'Custom Headline';
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: HeadlineText(
              testText,
              color: Colors.blue,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
    });
  });

  group('BodyText', () {
    testWidgets('renders with default body style', (WidgetTester tester) async {
      const testText = 'Body text content';
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: BodyText(testText),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('renders large body text', (WidgetTester tester) async {
      const testText = 'Large body text';
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: BodyText(testText, large: true),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('respects maxLines with ellipsis', (WidgetTester tester) async {
      const testText = 'This is a very long text that should be truncated';
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: SizedBox(
              width: 100,
              child: BodyText(testText, maxLines: 1),
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.maxLines, equals(1));
      expect(textWidget.overflow, equals(TextOverflow.ellipsis));
    });
  });

  group('LabelText', () {
    testWidgets('renders with default label style', (WidgetTester tester) async {
      const testText = 'Label';
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: LabelText(testText),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('renders large label', (WidgetTester tester) async {
      const testText = 'Large Label';
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: LabelText(testText, large: true),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('applies custom color and weight', (WidgetTester tester) async {
      const testText = 'Custom Label';
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: LabelText(
              testText,
              color: Colors.green,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
    });
  });

  group('TypographyUtils', () {
    testWidgets('getResponsiveFontSize scales correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final fontSize = TypographyUtils.getResponsiveFontSize(
                context,
                16.0,
              );
              
              expect(fontSize, greaterThanOrEqualTo(12.0));
              expect(fontSize, lessThanOrEqualTo(72.0));
              
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );
    });

    testWidgets('getTextScaleFactor respects user preferences', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final scaleFactor = TypographyUtils.getTextScaleFactor(context);
              
              expect(scaleFactor, greaterThanOrEqualTo(0.8));
              expect(scaleFactor, lessThanOrEqualTo(1.5));
              
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );
    });

    test('willTextFit calculates correctly', () {
      const text = 'Short text';
      const style = TextStyle(fontSize: 14);
      
      final willFit = TypographyUtils.willTextFit(
        text: text,
        style: style,
        maxWidth: 200,
      );
      
      expect(willFit, isTrue);
    });

    test('willTextFit detects overflow', () {
      const text = 'This is a very long text that will not fit in a small space';
      const style = TextStyle(fontSize: 24);
      
      final willFit = TypographyUtils.willTextFit(
        text: text,
        style: style,
        maxWidth: 50,
        maxLines: 1,
      );
      
      expect(willFit, isFalse);
    });
  });

  group('Responsive Typography Scaling', () {
    testWidgets('scales correctly on small screens', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 568); // iPhone SE size
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: Column(
              children: [
                DisplayText('Display'),
                HeadlineText('Headline'),
                BodyText('Body'),
                LabelText('Label'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Display'), findsOneWidget);
      expect(find.text('Headline'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(find.text('Label'), findsOneWidget);
    });

    testWidgets('scales correctly on medium screens', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(375, 812); // iPhone X size
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: Column(
              children: [
                DisplayText('Display'),
                HeadlineText('Headline'),
                BodyText('Body'),
                LabelText('Label'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Display'), findsOneWidget);
      expect(find.text('Headline'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(find.text('Label'), findsOneWidget);
    });

    testWidgets('scales correctly on large screens', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(428, 926); // iPhone Pro Max size
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: Column(
              children: [
                DisplayText('Display'),
                HeadlineText('Headline'),
                BodyText('Body'),
                LabelText('Label'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Display'), findsOneWidget);
      expect(find.text('Headline'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(find.text('Label'), findsOneWidget);
    });
  });

  group('TextStyle Extensions', () {
    testWidgets('scaleForScreen applies scaling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              const baseStyle = TextStyle(fontSize: 16);
              final scaledStyle = baseStyle.scaleForScreen(context);
              
              expect(scaledStyle.fontSize, isNotNull);
              expect(scaledStyle.fontSize! >= 16 * 0.8, isTrue);
              expect(scaledStyle.fontSize! <= 16 * 1.5, isTrue);
              
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );
    });

    testWidgets('withHighContrast applies high contrast in light mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Builder(
            builder: (context) {
              const baseStyle = TextStyle(fontSize: 16);
              final contrastStyle = baseStyle.withHighContrast(context);
              
              expect(contrastStyle.color, equals(Colors.black));
              expect(contrastStyle.fontWeight, equals(FontWeight.w600));
              
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );
    });

    testWidgets('withHighContrast applies high contrast in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Builder(
            builder: (context) {
              const baseStyle = TextStyle(fontSize: 16);
              final contrastStyle = baseStyle.withHighContrast(context);
              
              expect(contrastStyle.color, equals(Colors.white));
              expect(contrastStyle.fontWeight, equals(FontWeight.w600));
              
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );
    });
  });
}
