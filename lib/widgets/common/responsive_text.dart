import 'package:flutter/material.dart';

/// A responsive text widget that scales based on available space
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final BoxFit fit;
  final double minFontSize;
  final double maxFontSize;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.fit = BoxFit.scaleDown,
    this.minFontSize = 12,
    this.maxFontSize = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: fit,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
      ),
    );
  }
}

/// A display text widget with automatic scaling for large headings
class DisplayText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Color? color;
  final FontWeight? fontWeight;

  const DisplayText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = theme.textTheme.displayLarge?.copyWith(
      color: color,
      fontWeight: fontWeight,
    );

    return ResponsiveText(
      text,
      style: style ?? defaultStyle,
      textAlign: textAlign,
      fit: BoxFit.scaleDown,
    );
  }
}

/// A headline text widget with automatic scaling
class HeadlineText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Color? color;
  final FontWeight? fontWeight;
  final int level;

  const HeadlineText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.color,
    this.fontWeight,
    this.level = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TextStyle? defaultStyle;

    switch (level) {
      case 1:
        defaultStyle = theme.textTheme.headlineLarge;
        break;
      case 2:
        defaultStyle = theme.textTheme.headlineMedium;
        break;
      case 3:
        defaultStyle = theme.textTheme.headlineSmall;
        break;
      default:
        defaultStyle = theme.textTheme.headlineMedium;
    }

    defaultStyle = defaultStyle?.copyWith(
      color: color,
      fontWeight: fontWeight,
    );

    return ResponsiveText(
      text,
      style: style ?? defaultStyle,
      textAlign: textAlign,
      fit: BoxFit.scaleDown,
    );
  }
}

/// A body text widget with responsive sizing
class BodyText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Color? color;
  final int? maxLines;
  final bool large;

  const BodyText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.color,
    this.maxLines,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = (large
            ? theme.textTheme.bodyLarge
            : theme.textTheme.bodyMedium)
        ?.copyWith(color: color);

    return Text(
      text,
      style: style ?? defaultStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }
}

/// A label text widget for UI elements
class LabelText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Color? color;
  final FontWeight? fontWeight;
  final bool large;

  const LabelText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.color,
    this.fontWeight,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = (large
            ? theme.textTheme.labelLarge
            : theme.textTheme.labelMedium)
        ?.copyWith(
      color: color,
      fontWeight: fontWeight,
    );

    return Text(
      text,
      style: style ?? defaultStyle,
      textAlign: textAlign,
    );
  }
}

/// Extension on TextStyle for dynamic scaling
extension ResponsiveTextStyle on TextStyle {
  /// Scale the font size based on screen width
  TextStyle scaleForScreen(BuildContext context, {double factor = 1.0}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = (screenWidth / 375.0) * factor; // 375 is base width (iPhone)
    
    return copyWith(
      fontSize: (fontSize ?? 14) * scaleFactor.clamp(0.8, 1.5),
    );
  }
  
  /// Apply high contrast for accessibility
  TextStyle withHighContrast(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return copyWith(
      color: brightness == Brightness.light ? Colors.black : Colors.white,
      fontWeight: FontWeight.w600,
    );
  }
}

/// Utility class for responsive typography calculations
class TypographyUtils {
  /// Calculate responsive font size based on screen width
  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize, {
    double minSize = 12,
    double maxSize = 72,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 375.0; // Base width
    final fontSize = baseFontSize * scaleFactor;
    return fontSize.clamp(minSize, maxSize);
  }
  
  /// Get text scale factor respecting user preferences
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.5);
  }
  
  /// Check if text will fit in given constraints
  static bool willTextFit({
    required String text,
    required TextStyle style,
    required double maxWidth,
    int? maxLines,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout(maxWidth: maxWidth);
    return !textPainter.didExceedMaxLines;
  }
}
