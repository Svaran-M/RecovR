import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 8px grid spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;
  static const double spacing88 = 88.0;
  
  // border radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  
  // elevation
  static const double elevationNone = 0.0;
  static const double elevationSubtle = 1.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  
  // touch targets
  static const double touchTargetMinimum = 48.0;
  static const double touchTargetPreferred = 56.0;
  static const double touchTargetLarge = 64.0;
  static const double touchTargetXLarge = 72.0;
  
  // component sizes
  static const double checkboxSize = 32.0;
  static const double iconSizeSmall = 20.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 28.0;
  static const double iconSizeXLarge = 32.0;
  
  // input heights
  static const double inputHeightStandard = 64.0;
  static const double buttonHeightStandard = 64.0;
  static const double buttonHeightLarge = 72.0;
  
  static const double navBarHeight = 88.0;
  static const double listItemHeightStandard = 88.0;
  
  static ColorScheme get lightColorScheme => const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0061A4),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD1E4FF),
    onPrimaryContainer: Color(0xFF001D36),
    secondary: Color(0xFF535F70),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD7E3F7),
    onSecondaryContainer: Color(0xFF101C2B),
    tertiary: Color(0xFF6B5778),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFF2DAFF),
    onTertiaryContainer: Color(0xFF251431),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFFDFCFF),
    onSurface: Color(0xFF1A1C1E),
    surfaceContainerHighest: Color(0xFFE2E2E6),
    onSurfaceVariant: Color(0xFF44474E),
    outline: Color(0xFF74777F),
    outlineVariant: Color(0xFFC4C6D0),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF2F3033),
    onInverseSurface: Color(0xFFF1F0F4),
    inversePrimary: Color(0xFF9ECAFF),
    background: Color(0xFFFDFCFF),
    onBackground: Color(0xFF1A1C1E),
  );
  
  static ColorScheme get darkColorScheme => const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF9ECAFF),
    onPrimary: Color(0xFF003258),
    primaryContainer: Color(0xFF00497D),
    onPrimaryContainer: Color(0xFFD1E4FF),
    secondary: Color(0xFFBBC7DB),
    onSecondary: Color(0xFF253140),
    secondaryContainer: Color(0xFF3B4858),
    onSecondaryContainer: Color(0xFFD7E3F7),
    tertiary: Color(0xFFDDBCE0),
    onTertiary: Color(0xFF3B2948),
    tertiaryContainer: Color(0xFF523F5F),
    onTertiaryContainer: Color(0xFFF2DAFF),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF1A1C1E),
    onSurface: Color(0xFFE2E2E6),
    surfaceContainerHighest: Color(0xFF44474E),
    onSurfaceVariant: Color(0xFFC4C6D0),
    outline: Color(0xFF8E9099),
    outlineVariant: Color(0xFF44474E),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE2E2E6),
    onInverseSurface: Color(0xFF2F3033),
    inversePrimary: Color(0xFF0061A4),
    background: Color(0xFF1A1C1E),
    onBackground: Color(0xFFE2E2E6),
  );
  
  static const Color successLight = Color(0xFF006E26);
  static const Color successDark = Color(0xFF6FDD8B);
  static const Color warningLight = Color(0xFF8B5000);
  static const Color warningDark = Color(0xFFFFB951);
  
  static Color success(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? successLight 
        : successDark;
  }
  
  static Color warning(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? warningLight 
        : warningDark;
  }
  
  static Color error(BuildContext context) {
    return Theme.of(context).colorScheme.error;
  }

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: lightColorScheme,
    textTheme: _buildTextTheme(Brightness.light),
    scaffoldBackgroundColor: lightColorScheme.surface,
    
    cardTheme: CardThemeData(
      elevation: elevationSubtle,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
      ),
      color: lightColorScheme.surface,
      margin: const EdgeInsets.all(spacing8),
    ),
    
    appBarTheme: AppBarTheme(
      elevation: elevationNone,
      centerTitle: false,
      backgroundColor: lightColorScheme.surface,
      foregroundColor: lightColorScheme.onSurface,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: lightColorScheme.onSurface,
        letterSpacing: -0.5,
      ),
    ),
    
    // button themes
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, buttonHeightStandard),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, buttonHeightStandard),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        side: BorderSide(
          color: lightColorScheme.outline,
          width: 2,
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(touchTargetMinimum, touchTargetMinimum),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightColorScheme.surfaceContainerHighest.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: lightColorScheme.outline, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: lightColorScheme.outline, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: lightColorScheme.primary, width: 3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: lightColorScheme.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: lightColorScheme.error, width: 3),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing16,
        vertical: spacing16,
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      floatingLabelStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      ),
      helperStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    
    // checkbox theme
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      side: BorderSide(
        color: lightColorScheme.outline,
        width: 2,
      ),
    ),
    
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightColorScheme.primary;
        }
        return lightColorScheme.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightColorScheme.primaryContainer;
        }
        return lightColorScheme.surfaceContainerHighest;
      }),
    ),
    
    // slider
    sliderTheme: SliderThemeData(
      trackHeight: 8.0,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14.0),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
      activeTrackColor: lightColorScheme.primary,
      inactiveTrackColor: lightColorScheme.surfaceContainerHighest,
      thumbColor: lightColorScheme.primary,
      overlayColor: lightColorScheme.primary.withOpacity(0.12),
      valueIndicatorColor: lightColorScheme.primary,
      valueIndicatorTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: lightColorScheme.onPrimary,
      ),
    ),
    
    navigationBarTheme: NavigationBarThemeData(
      height: navBarHeight,
      elevation: elevationLow,
      backgroundColor: lightColorScheme.surface,
      indicatorColor: lightColorScheme.primaryContainer,
      labelTextStyle: WidgetStateProperty.all(
        GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        return IconThemeData(
          size: iconSizeLarge,
          color: states.contains(WidgetState.selected)
              ? lightColorScheme.onPrimaryContainer
              : lightColorScheme.onSurfaceVariant,
        );
      }),
    ),
    
    dividerTheme: DividerThemeData(
      color: lightColorScheme.outlineVariant,
      thickness: 1,
      space: spacing16,
    ),
    
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing16,
        vertical: spacing12,
      ),
      minVerticalPadding: spacing12,
      minLeadingWidth: touchTargetMinimum,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: darkColorScheme,
    textTheme: _buildTextTheme(Brightness.dark),
    scaffoldBackgroundColor: darkColorScheme.surface,
    
    // card theme
    cardTheme: CardThemeData(
      elevation: elevationSubtle,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
      ),
      color: darkColorScheme.surface,
      margin: const EdgeInsets.all(spacing8),
    ),
    
    // appbar
    appBarTheme: AppBarTheme(
      elevation: elevationNone,
      centerTitle: false,
      backgroundColor: darkColorScheme.surface,
      foregroundColor: darkColorScheme.onSurface,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: darkColorScheme.onSurface,
        letterSpacing: -0.5,
      ),
    ),
    
    // button themes
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, buttonHeightStandard),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, buttonHeightStandard),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        side: BorderSide(
          color: darkColorScheme.outline,
          width: 2,
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(touchTargetMinimum, touchTargetMinimum),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),
    
    // input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkColorScheme.surfaceContainerHighest.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: darkColorScheme.outline, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: darkColorScheme.outline, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: darkColorScheme.primary, width: 3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: darkColorScheme.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: darkColorScheme.error, width: 3),
      ),
      // Padding to achieve 64px height with 18px text
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing16,
        vertical: spacing16,
      ),
      // 18px font for input text
      labelStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      floatingLabelStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      ),
      helperStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    
    // checkbox theme
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      side: BorderSide(
        color: darkColorScheme.outline,
        width: 2,
      ),
    ),
    
    // switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return darkColorScheme.primary;
        }
        return darkColorScheme.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return darkColorScheme.primaryContainer;
        }
        return darkColorScheme.surfaceContainerHighest;
      }),
    ),
    
    // slider
    sliderTheme: SliderThemeData(
      trackHeight: 8.0,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14.0),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
      activeTrackColor: darkColorScheme.primary,
      inactiveTrackColor: darkColorScheme.surfaceContainerHighest,
      thumbColor: darkColorScheme.primary,
      overlayColor: darkColorScheme.primary.withOpacity(0.12),
      valueIndicatorColor: darkColorScheme.primary,
      valueIndicatorTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: darkColorScheme.onPrimary,
      ),
    ),
    
    // nav bar
    navigationBarTheme: NavigationBarThemeData(
      height: navBarHeight,
      elevation: elevationLow,
      backgroundColor: darkColorScheme.surface,
      indicatorColor: darkColorScheme.primaryContainer,
      labelTextStyle: WidgetStateProperty.all(
        GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        return IconThemeData(
          size: iconSizeLarge,
          color: states.contains(WidgetState.selected)
              ? darkColorScheme.onPrimaryContainer
              : darkColorScheme.onSurfaceVariant,
        );
      }),
    ),
    
    // divider
    dividerTheme: DividerThemeData(
      color: darkColorScheme.outlineVariant,
      thickness: 1,
      space: spacing16,
    ),
    
    // list tiles
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing16,
        vertical: spacing12,
      ),
      minVerticalPadding: spacing12,
      minLeadingWidth: touchTargetMinimum,
    ),
  );

  // Typography with 18px min body text
  static TextTheme _buildTextTheme(Brightness brightness) {
    final Color textColor = brightness == Brightness.light 
        ? lightColorScheme.onSurface 
        : darkColorScheme.onSurface;
    
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 120,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.0,
        letterSpacing: -2.0,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 64,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.1,
        letterSpacing: -1.0,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      
      headlineLarge: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
        letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
        letterSpacing: -0.25,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.4,
        letterSpacing: 0,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.5,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.5,
        letterSpacing: 0.1,
      ),
      
      bodyLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.6,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.6,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.5,
        letterSpacing: 0.4,
      ),
      
      labelLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.4,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.4,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.4,
        letterSpacing: 0.5,
      ),
    );
  }
}
