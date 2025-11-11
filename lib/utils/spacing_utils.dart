import 'package:flutter/material.dart';
import 'package:rehab_tracker_pro/theme/app_theme.dart';

/// Utility class for consistent spacing throughout the app
/// Ensures all spacing aligns to 8px grid system
class SpacingUtils {
  SpacingUtils._();
  
  /// Vertical spacing widgets for consistent gaps
  static const Widget vertical4 = SizedBox(height: AppTheme.spacing4);
  static const Widget vertical8 = SizedBox(height: AppTheme.spacing8);
  static const Widget vertical12 = SizedBox(height: AppTheme.spacing12);
  static const Widget vertical16 = SizedBox(height: AppTheme.spacing16);
  static const Widget vertical24 = SizedBox(height: AppTheme.spacing24);
  static const Widget vertical32 = SizedBox(height: AppTheme.spacing32);
  static const Widget vertical48 = SizedBox(height: AppTheme.spacing48);
  static const Widget vertical64 = SizedBox(height: AppTheme.spacing64);
  
  /// Horizontal spacing widgets for consistent gaps
  static const Widget horizontal4 = SizedBox(width: AppTheme.spacing4);
  static const Widget horizontal8 = SizedBox(width: AppTheme.spacing8);
  static const Widget horizontal12 = SizedBox(width: AppTheme.spacing12);
  static const Widget horizontal16 = SizedBox(width: AppTheme.spacing16);
  static const Widget horizontal24 = SizedBox(width: AppTheme.spacing24);
  static const Widget horizontal32 = SizedBox(width: AppTheme.spacing32);
  static const Widget horizontal48 = SizedBox(width: AppTheme.spacing48);
  
  /// Standard padding presets for consistent layouts
  static const EdgeInsets paddingAll4 = EdgeInsets.all(AppTheme.spacing4);
  static const EdgeInsets paddingAll8 = EdgeInsets.all(AppTheme.spacing8);
  static const EdgeInsets paddingAll12 = EdgeInsets.all(AppTheme.spacing12);
  static const EdgeInsets paddingAll16 = EdgeInsets.all(AppTheme.spacing16);
  static const EdgeInsets paddingAll24 = EdgeInsets.all(AppTheme.spacing24);
  static const EdgeInsets paddingAll32 = EdgeInsets.all(AppTheme.spacing32);
  
  /// Horizontal padding presets
  static const EdgeInsets paddingH8 = EdgeInsets.symmetric(horizontal: AppTheme.spacing8);
  static const EdgeInsets paddingH16 = EdgeInsets.symmetric(horizontal: AppTheme.spacing16);
  static const EdgeInsets paddingH24 = EdgeInsets.symmetric(horizontal: AppTheme.spacing24);
  static const EdgeInsets paddingH32 = EdgeInsets.symmetric(horizontal: AppTheme.spacing32);
  
  /// Vertical padding presets
  static const EdgeInsets paddingV8 = EdgeInsets.symmetric(vertical: AppTheme.spacing8);
  static const EdgeInsets paddingV12 = EdgeInsets.symmetric(vertical: AppTheme.spacing12);
  static const EdgeInsets paddingV16 = EdgeInsets.symmetric(vertical: AppTheme.spacing16);
  static const EdgeInsets paddingV24 = EdgeInsets.symmetric(vertical: AppTheme.spacing24);
  static const EdgeInsets paddingV32 = EdgeInsets.symmetric(vertical: AppTheme.spacing32);
  
  /// Screen edge padding - generous whitespace
  static const EdgeInsets screenPadding = EdgeInsets.all(AppTheme.spacing32);
  static const EdgeInsets screenPaddingH = EdgeInsets.symmetric(horizontal: AppTheme.spacing32);
  static const EdgeInsets screenPaddingV = EdgeInsets.symmetric(vertical: AppTheme.spacing24);
  
  /// Section spacing - generous whitespace between major sections
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(vertical: AppTheme.spacing32);
  static const Widget sectionGap = SizedBox(height: AppTheme.spacing48);
  
  /// List item spacing
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: AppTheme.spacing16,
    vertical: AppTheme.spacing16,
  );
  static const Widget listItemGap = SizedBox(height: AppTheme.spacing24);
  
  /// Card padding - when cards are used
  static const EdgeInsets cardPadding = EdgeInsets.all(AppTheme.spacing24);
  static const EdgeInsets cardPaddingLarge = EdgeInsets.all(AppTheme.spacing32);
  
  /// Button padding
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: AppTheme.spacing32,
    vertical: AppTheme.spacing16,
  );
  
  /// Validates that a value aligns to 8px grid
  static bool isAlignedToGrid(double value) {
    return value % 8 == 0;
  }
  
  /// Rounds a value to nearest 8px grid point
  static double roundToGrid(double value) {
    return (value / 8).round() * 8.0;
  }
  
  /// Creates a SizedBox with height aligned to grid
  static Widget verticalSpace(double height) {
    assert(isAlignedToGrid(height), 'Height must align to 8px grid');
    return SizedBox(height: height);
  }
  
  /// Creates a SizedBox with width aligned to grid
  static Widget horizontalSpace(double width) {
    assert(isAlignedToGrid(width), 'Width must align to 8px grid');
    return SizedBox(width: width);
  }
}
