import 'package:flutter/material.dart';

import '../animations/toast_animations.dart';
import 'toast_position.dart';
import 'toast_type.dart';

/// Immutable description of a single toast.
///
/// [ToastConfig] is a pure data object — it holds no behavior and no
/// widget references, which keeps it trivially testable and reusable.
@immutable
class ToastConfig {
  const ToastConfig({
    required this.message,
    this.type = ToastType.info,
    this.title,
    this.position = ToastPosition.top,
    this.animation = ToastAnimation.slide,
    this.duration = const Duration(seconds: 3),
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.dismissible = true,
    this.margin,
  });

  final String message;
  final ToastType type;
  final String? title;
  final ToastPosition position;
  final ToastAnimation animation;

  /// `Duration.zero` disables the auto-dismiss timer (sticky toast).
  final Duration duration;

  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  final String? actionLabel;
  final VoidCallback? onAction;

  final bool dismissible;
  final EdgeInsetsGeometry? margin;

  ToastConfig copyWith({
    String? message,
    ToastType? type,
    String? title,
    ToastPosition? position,
    ToastAnimation? animation,
    Duration? duration,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    bool? dismissible,
    EdgeInsetsGeometry? margin,
  }) {
    return ToastConfig(
      message: message ?? this.message,
      type: type ?? this.type,
      title: title ?? this.title,
      position: position ?? this.position,
      animation: animation ?? this.animation,
      duration: duration ?? this.duration,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      icon: icon ?? this.icon,
      actionLabel: actionLabel ?? this.actionLabel,
      onAction: onAction ?? this.onAction,
      dismissible: dismissible ?? this.dismissible,
      margin: margin ?? this.margin,
    );
  }
}
