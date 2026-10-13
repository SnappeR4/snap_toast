import 'package:flutter/material.dart';

import '../models/toast_config.dart';

/// Pure presentation widget for the toast card. No timers, no overlay,
/// no animation state — easy to preview and test in isolation.
class SnapToastContent extends StatelessWidget {
  const SnapToastContent({
    super.key,
    required this.config,
    required this.onDismiss,
  });

  final ToastConfig config;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final background = config.backgroundColor ?? config.type.color;
    final foreground = config.textColor ?? Colors.white;
    final icon = config.icon ?? config.type.icon;

    final card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: foreground, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: _Body(config: config, foreground: foreground),
          ),
          if (config.actionLabel != null) ...[
            const SizedBox(width: 8),
            _ActionButton(
              label: config.actionLabel!,
              color: foreground,
              onTap: () {
                config.onAction?.call();
                onDismiss();
              },
            ),
          ],
        ],
      ),
    );

    if (!config.dismissible) return card;

    return GestureDetector(
      onTap: onDismiss,
      behavior: HitTestBehavior.opaque,
      child: card,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.config, required this.foreground});

  final ToastConfig config;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final title = config.title;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Text(
            title,
            style: TextStyle(
              color: foreground,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
        ],
        Text(
          config.message,
          style: TextStyle(
            color: title == null
                ? foreground
                : foreground.withValues(alpha: 0.9),
            fontSize: title == null ? 14 : 13,
            fontWeight: title == null ? FontWeight.w500 : FontWeight.w400,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: color,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
