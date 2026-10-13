import 'dart:async';

import 'package:flutter/material.dart';

import '../animations/toast_animations.dart';
import '../models/toast_config.dart';
import '../models/toast_position.dart';
import 'toast_content.dart';

/// Small indirection so the controller can trigger dismissal without
/// importing widget internals (DIP).
class SnapToastHandle {
  VoidCallback? _dismiss;
  void dismiss() => _dismiss?.call();
  void _bind(VoidCallback fn) => _dismiss = fn;
  void _unbind() => _dismiss = null;
}

/// Renders the animated toast inside the overlay.
class SnapToastHost extends StatefulWidget {
  const SnapToastHost({
    super.key,
    required this.config,
    required this.handle,
    required this.onDismissed,
  });

  final ToastConfig config;
  final SnapToastHandle handle;
  final VoidCallback onDismissed;

  @override
  State<SnapToastHost> createState() => _SnapToastHostState();
}

class _SnapToastHostState extends State<SnapToastHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  Timer? _timer;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    widget.handle._bind(_dismiss);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      reverseDuration: const Duration(milliseconds: 200),
    );

    final isTop = widget.config.position == ToastPosition.top;
    final startOffset = Offset(0, isTop ? -1.2 : 1.2);

    _offset = _controller.drive(
      Tween<Offset>(
        begin: startOffset,
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic)),
    );
    _fade = _controller.drive(CurveTween(curve: Curves.easeOut));
    _scale = _controller.drive(
      Tween<double>(
        begin: 0.86,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOutBack)),
    );

    _controller.forward();
    _startTimer();
  }

  void _startTimer() {
    if (widget.config.duration <= Duration.zero) return;
    _timer = Timer(widget.config.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_dismissing || !mounted) return;
    _dismissing = true;
    _timer?.cancel();
    _timer = null;
    await _controller.reverse();
    if (mounted) widget.onDismissed();
  }

  @override
  void dispose() {
    widget.handle._unbind();
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Widget _applyTransition(Widget child) {
    switch (widget.config.animation) {
      case ToastAnimation.slide:
        return SlideTransition(
          position: _offset,
          child: FadeTransition(opacity: _fade, child: child),
        );
      case ToastAnimation.fade:
        return FadeTransition(opacity: _fade, child: child);
      case ToastAnimation.scale:
        return FadeTransition(
          opacity: _fade,
          child: ScaleTransition(scale: _scale, child: child),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTop = widget.config.position == ToastPosition.top;
    final padding = MediaQuery.paddingOf(context);

    return Positioned(
      top: isTop ? padding.top + 12 : null,
      bottom: isTop ? null : padding.bottom + 12,
      left: 16,
      right: 16,
      child: _applyTransition(
        Material(
          color: Colors.transparent,
          child: SnapToastContent(config: widget.config, onDismiss: _dismiss),
        ),
      ),
    );
  }
}
