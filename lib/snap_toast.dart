/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

export 'src/snap_toast_base.dart';

export 'src/animations/toast_animations.dart';
export 'src/models/toast_config.dart';
export 'src/models/toast_position.dart';
export 'src/models/toast_type.dart';
import 'package:flutter/widgets.dart';
import 'package:snap_toast/snap_toast.dart';
import 'package:snap_toast/src/controller/snaptoast_controller.dart';

/// Public API for SnapToast.
///
/// Two flavors, one implementation:
///   * `SnapToast.success(context, 'Saved!')` — the 90% case.
///   * `SnapToast.show(context, ToastConfig(...))` — full control.
class SnapToast {
  SnapToast._();

  // ---- Sugar API ---------------------------------------------------------

  static void success(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    ToastPosition position = ToastPosition.top,
  }) => _preset(
    context,
    ToastType.success,
    message,
    title: title,
    duration: duration,
    position: position,
  );

  static void error(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    ToastPosition position = ToastPosition.top,
  }) => _preset(
    context,
    ToastType.error,
    message,
    title: title,
    duration: duration,
    position: position,
  );

  static void warning(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    ToastPosition position = ToastPosition.top,
  }) => _preset(
    context,
    ToastType.warning,
    message,
    title: title,
    duration: duration,
    position: position,
  );

  static void info(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    ToastPosition position = ToastPosition.top,
  }) => _preset(
    context,
    ToastType.info,
    message,
    title: title,
    duration: duration,
    position: position,
  );

  // ---- Full-control API --------------------------------------------------

  static void show(BuildContext context, ToastConfig config) {
    SnapToastController.instance.show(context, config);
  }

  /// Dismiss the currently visible toast.
  static void dismiss() => SnapToastController.instance.dismiss();

  // ---- Internal ----------------------------------------------------------

  static void _preset(
    BuildContext context,
    ToastType type,
    String message, {
    String? title,
    required Duration duration,
    required ToastPosition position,
  }) {
    show(
      context,
      ToastConfig(
        type: type,
        message: message,
        title: title,
        duration: duration,
        position: position,
        animation: ToastAnimation.slide,
      ),
    );
  }
}
