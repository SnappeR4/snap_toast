import 'package:flutter/material.dart';

import '../models/toast_config.dart';
import '../widgets/snaptoast_widget.dart';

/// Owns the single overlay slot that a SnapToast lives in.
///
/// Responsibilities (SRP):
///   * reserve/release an overlay entry
///   * guarantee at most one active toast
///   * expose a stable dismiss() handle
///
/// The controller never touches animation or layout — those belong to
/// [SnapToastHost].
class SnapToastController {
  SnapToastController._();
  static final SnapToastController instance = SnapToastController._();

  OverlayEntry? _entry;
  SnapToastHandle? _handle;

  /// Show [config]. Any currently visible toast is replaced immediately.
  void show(BuildContext context, ToastConfig config) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    assert(
      overlay != null,
      'SnapToast requires an Overlay ancestor (wrap your app in MaterialApp).',
    );
    if (overlay == null) return;

    _tearDown();

    final handle = SnapToastHandle();
    _handle = handle;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => SnapToastHost(
        config: config,
        handle: handle,
        onDismissed: () {
          if (identical(_entry, entry)) {
            _entry = null;
            _handle = null;
          }
          if (entry.mounted) entry.remove();
        },
      ),
    );

    _entry = entry;
    overlay.insert(entry);
  }

  /// Dismiss the current toast with its exit animation.
  void dismiss() => _handle?.dismiss();

  /// Hard-remove without animation (used when replacing).
  void _tearDown() {
    _entry?.remove();
    _entry = null;
    _handle = null;
  }
}
