import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

// Text field with 64px height and 18px font
class ProfessionalTextField extends StatelessWidget {
  const ProfessionalTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.inputFormatters,
    this.validator,
    this.autovalidateMode,
    this.initialValue,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: AppTheme.inputHeightStandard,
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        initialValue: initialValue,
        decoration: decoration,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        obscureText: obscureText,
        autocorrect: autocorrect,
        enableSuggestions: enableSuggestions,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        onTap: onTap,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: autofocus,
        inputFormatters: inputFormatters,
        validator: validator,
        autovalidateMode: autovalidateMode,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15,
        ),
        cursorWidth: 2.0,
        cursorRadius: const Radius.circular(2.0),
      ),
    );
  }
}
