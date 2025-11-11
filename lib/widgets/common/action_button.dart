import 'package:flutter/material.dart';

/// Professional action button with large touch targets and smooth animations
/// Optimized for older users with 64-72px height and clear labels
class ActionButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;

  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isPrimary = true,
  });

  const ActionButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : isPrimary = true;

  const ActionButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : isPrimary = false;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = widget.onPressed != null;

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 72,
          maxWidth: 320,
        ),
        child: widget.isPrimary
            ? FilledButton(
                onPressed: widget.onPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: isEnabled
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceVariant,
                  foregroundColor: isEnabled
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: isEnabled ? 2 : 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                ),
                onLongPress: isEnabled
                    ? () {
                        setState(() => _isPressed = true);
                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (mounted) {
                            setState(() => _isPressed = false);
                          }
                        });
                      }
                    : null,
                child: _buildButtonContent(theme),
              )
            : OutlinedButton(
                onPressed: widget.onPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: isEnabled
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  side: BorderSide(
                    color: isEnabled
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceVariant,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                ),
                onLongPress: isEnabled
                    ? () {
                        setState(() => _isPressed = true);
                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (mounted) {
                            setState(() => _isPressed = false);
                          }
                        });
                      }
                    : null,
                child: _buildButtonContent(theme),
              ),
      ),
    );
  }

  Widget _buildButtonContent(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(
            widget.icon,
            size: 24,
          ),
          const SizedBox(width: 12),
        ],
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
