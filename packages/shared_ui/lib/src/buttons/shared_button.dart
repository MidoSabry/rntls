import 'package:flutter/material.dart';

enum SharedButtonVariant { filled, outlined, text }

class SharedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  // styles
  final SharedButtonVariant variant;
  final bool rounded; // true => radius كبير
  final double radius;
  final double height;
  final EdgeInsetsGeometry padding;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  final double borderWidth;

  // layout
  final bool fullWidth;
  final double? width;

  // content
  final Widget? leading;
  final Widget? trailing;
  final double gap;

  // states
  final bool isLoading;
  final bool enabled;

  // typography
  final double fontSize;
  final FontWeight fontWeight;

  const SharedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = SharedButtonVariant.filled,
    this.rounded = true,
    this.radius = 14,
    this.height = 52,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.fullWidth = true,
    this.width,
    this.leading,
    this.trailing,
    this.gap = 10,
    this.isLoading = false,
    this.enabled = true,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    final canTap = enabled && !isLoading && onPressed != null;

    final r = rounded ? 999.0 : radius;

    final Color defaultBg = switch (variant) {
      SharedButtonVariant.filled => Colors.black,
      SharedButtonVariant.outlined => Colors.transparent,
      SharedButtonVariant.text => Colors.transparent,
    };

    final Color defaultFg = switch (variant) {
      SharedButtonVariant.filled => Colors.white,
      SharedButtonVariant.outlined => Colors.black,
      SharedButtonVariant.text => Colors.black,
    };

    final Color bg = backgroundColor ?? defaultBg;
    final Color fg = foregroundColor ?? defaultFg;

    final Color br = borderColor ??
        (variant == SharedButtonVariant.outlined
            ? const Color(0xFFE6E6E6)
            : Colors.transparent);

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(r),
      side: BorderSide(color: br, width: borderWidth),
    );

    Widget child;
    if (isLoading) {
      child = SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(fg),
        ),
      );
    } else {
      child = Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[
            IconTheme(data: IconThemeData(color: fg), child: leading!),
            SizedBox(width: gap),
          ],
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: fg,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: gap),
            IconTheme(data: IconThemeData(color: fg), child: trailing!),
          ],
        ],
      );
    }

    final button = switch (variant) {
      SharedButtonVariant.filled || SharedButtonVariant.outlined =>
        ElevatedButton(
          onPressed: canTap ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: fg,
            elevation: 0,
            shape: shape,
            padding: padding,
            minimumSize: Size(fullWidth ? double.infinity : 0, height),
          ).copyWith(
            // disable color
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return variant == SharedButtonVariant.filled
                    ? const Color(0xFFBDBDBD)
                    : Colors.transparent;
              }
              return bg;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return variant == SharedButtonVariant.filled
                    ? Colors.white
                    : const Color(0xFF9E9E9E);
              }
              return fg;
            }),
          ),
          child: child,
        ),
      SharedButtonVariant.text => TextButton(
          onPressed: canTap ? onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor: fg,
            padding: padding,
            minimumSize: Size(fullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r),
            ),
          ),
          child: child,
        ),
    };

    if (width != null && fullWidth == false) {
      return SizedBox(width: width, height: height, child: button);
    }

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: button,
    );
  }
}