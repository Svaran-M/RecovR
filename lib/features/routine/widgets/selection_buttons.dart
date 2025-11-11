import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class SelectionButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;

  const SelectionButton({
    super.key,
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.selectedColor,
  });

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: widget.isSelected ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(SelectionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = widget.selectedColor ?? theme.colorScheme.primary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: IrregularButtonPainter(
                progress: _controller.value,
                isSelected: widget.isSelected,
                selectedColor: selectedColor,
                isDark: theme.brightness == Brightness.dark,
                surfaceColor: theme.colorScheme.surfaceContainerHighest,
                borderColor: theme.colorScheme.primary,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: widget.isSelected
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: widget.isSelected
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Custom painter for irregular button shapes with morphing animations
class IrregularButtonPainter extends CustomPainter {
  final double progress;
  final bool isSelected;
  final Color selectedColor;
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;

  IrregularButtonPainter({
    required this.progress,
    required this.isSelected,
    required this.selectedColor,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _createIrregularShape(size, progress);
    
    // Background with gradient
    if (isSelected) {
      final gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          selectedColor,
          selectedColor.withOpacity(0.7),
        ],
      );
      
      final rect = Rect.fromLTWH(0, 0, size.width, size.height);
      final bgPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill;
      
      canvas.drawPath(path, bgPaint);
      
      // Animated pattern overlay
      _drawAnimatedPattern(canvas, size, progress);
    } else {
      final bgPaint = Paint()
        ..color = surfaceColor.withOpacity(0.5)
        ..style = PaintingStyle.fill;
      
      canvas.drawPath(path, bgPaint);
    }
    
    // Border
    final borderPaint = Paint()
      ..color = isSelected
          ? selectedColor
          : borderColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawPath(path, borderPaint);
  }

  Path _createIrregularShape(Size size, double morphProgress) {
    final path = Path();
    
    // Create an irregular polygon that morphs based on selection
    final points = [
      Offset(8 + morphProgress * 4, 0),
      Offset(size.width - 4, 4 - morphProgress * 2),
      Offset(size.width, size.height / 2),
      Offset(size.width - 8, size.height - 4 + morphProgress * 2),
      Offset(4 + morphProgress * 3, size.height),
      Offset(0, size.height / 2 + morphProgress * 4),
    ];
    
    path.moveTo(points[0].dx, points[0].dy);
    
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    
    path.close();
    return path;
  }

  void _drawAnimatedPattern(Canvas canvas, Size size, double progress) {
    final patternPaint = Paint()
      ..color = Colors.white.withOpacity(0.1 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    // Draw diagonal lines pattern
    for (double x = -size.height; x < size.width; x += 10) {
      final startX = x + (progress * 20);
      final startY = 0.0;
      final endX = startX + size.height;
      final endY = size.height;
      
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        patternPaint,
      );
    }
  }

  @override
  bool shouldRepaint(IrregularButtonPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isSelected != isSelected;
  }
}

/// Selection button group with clustering layout
class SelectionButtonGroup extends StatelessWidget {
  final String label;
  final List<SelectionButtonData> buttons;

  const SelectionButtonGroup({
    super.key,
    required this.label,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: buttons.map((buttonData) {
              return SelectionButton(
                label: buttonData.label,
                icon: buttonData.icon,
                isSelected: buttonData.isSelected,
                onTap: buttonData.onTap,
                selectedColor: buttonData.color,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class SelectionButtonData {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  SelectionButtonData({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.color,
  });
}

/// Multi-select button group
class MultiSelectButtonGroup extends StatefulWidget {
  final String label;
  final List<String> options;
  final List<String> selectedOptions;
  final ValueChanged<List<String>> onChanged;
  final Map<String, IconData>? icons;
  final Map<String, Color>? colors;

  const MultiSelectButtonGroup({
    super.key,
    required this.label,
    required this.options,
    required this.selectedOptions,
    required this.onChanged,
    this.icons,
    this.colors,
  });

  @override
  State<MultiSelectButtonGroup> createState() => _MultiSelectButtonGroupState();
}

class _MultiSelectButtonGroupState extends State<MultiSelectButtonGroup> {
  @override
  Widget build(BuildContext context) {
    return SelectionButtonGroup(
      label: widget.label,
      buttons: widget.options.map((option) {
        return SelectionButtonData(
          label: option,
          icon: widget.icons?[option],
          isSelected: widget.selectedOptions.contains(option),
          onTap: () => _toggleOption(option),
          color: widget.colors?[option],
        );
      }).toList(),
    );
  }

  void _toggleOption(String option) {
    final newSelection = List<String>.from(widget.selectedOptions);
    if (newSelection.contains(option)) {
      newSelection.remove(option);
    } else {
      newSelection.add(option);
    }
    widget.onChanged(newSelection);
  }
}

/// Single-select button group
class SingleSelectButtonGroup extends StatefulWidget {
  final String label;
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String?> onChanged;
  final Map<String, IconData>? icons;
  final Map<String, Color>? colors;

  const SingleSelectButtonGroup({
    super.key,
    required this.label,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
    this.icons,
    this.colors,
  });

  @override
  State<SingleSelectButtonGroup> createState() =>
      _SingleSelectButtonGroupState();
}

class _SingleSelectButtonGroupState extends State<SingleSelectButtonGroup> {
  @override
  Widget build(BuildContext context) {
    return SelectionButtonGroup(
      label: widget.label,
      buttons: widget.options.map((option) {
        return SelectionButtonData(
          label: option,
          icon: widget.icons?[option],
          isSelected: widget.selectedOption == option,
          onTap: () => widget.onChanged(option),
          color: widget.colors?[option],
        );
      }).toList(),
    );
  }
}

/// Boolean selection button (Yes/No, True/False, etc.)
class BooleanSelectionButton extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String trueLabel;
  final String falseLabel;
  final IconData? trueIcon;
  final IconData? falseIcon;

  const BooleanSelectionButton({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.trueLabel = 'Yes',
    this.falseLabel = 'No',
    this.trueIcon,
    this.falseIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section heading (22px)
        Text(
          label,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        // Large checkbox with label
        InkWell(
          onTap: () => onChanged(!value),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Transform.scale(
                  scale: 1.5, // Makes the checkbox 32px (from default ~21px)
                  child: Checkbox(
                    value: value,
                    onChanged: (newValue) => onChanged(newValue ?? false),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                  ),
                ),
                const SizedBox(width: 16),
                if (trueIcon != null) ...[
                  Icon(trueIcon, size: 24),
                  const SizedBox(width: 8),
                ],
                Text(
                  trueLabel,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
