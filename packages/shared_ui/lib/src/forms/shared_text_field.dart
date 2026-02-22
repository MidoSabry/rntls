import 'package:flutter/material.dart';

class SharedTextField extends StatefulWidget {
  final String label;
  final String? hint;

  final TextEditingController? controller;
  final String? initialValue; // لو مش عايز controller
  final ValueChanged<String>? onChanged;

  final String? errorText;

  final bool enabled;
  final bool readOnly;

  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;

  final bool isPassword;
  final bool obscureText;

  final Widget? prefix;
  final Widget? suffix;

  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final void Function(String)? onSubmitted;

  const SharedTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.isPassword = false,
    this.obscureText = false,
    this.prefix,
    this.suffix,
    this.onTap,
    this.focusNode,
    this.onSubmitted,
  });

  @override
  State<SharedTextField> createState() => _SharedTextFieldState();
}

class _SharedTextFieldState extends State<SharedTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword ? true : widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant SharedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPassword != widget.isPassword ||
        oldWidget.obscureText != widget.obscureText) {
      _obscure = widget.isPassword ? true : widget.obscureText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFD93D3D)),
    );

    Widget? suffixWidget = widget.suffix;

    if (widget.isPassword && widget.suffix == null) {
      suffixWidget = IconButton(
        onPressed: widget.enabled
            ? () => setState(() => _obscure = !_obscure)
            : null,
        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          initialValue: widget.controller == null ? widget.initialValue : null,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          obscureText: widget.isPassword ? _obscure : widget.obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          onTap: widget.onTap,
          onFieldSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            prefixIcon: widget.prefix,
            suffixIcon: suffixWidget,
            filled: true,
            fillColor: widget.enabled ? Colors.white : const Color(0xFFF3F3F3),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(color: Colors.black, width: 1.2),
            ),
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
          ),
        ),
      ],
    );
  }
}