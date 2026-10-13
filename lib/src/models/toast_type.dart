import 'package:flutter/material.dart';

/// Semantic notification type. Each type carries its own default
/// color and icon, so callers can stay terse.
enum ToastType {
  success(color: Color(0xFF16A34A), icon: Icons.check_circle_rounded),
  error(color: Color(0xFFDC2626), icon: Icons.cancel_rounded),
  warning(color: Color(0xFFF59E0B), icon: Icons.warning_rounded),
  info(color: Color(0xFF2563EB), icon: Icons.info_rounded);

  const ToastType({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}
