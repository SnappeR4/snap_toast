import 'package:flutter/material.dart';
import 'package:snap_toast/snap_toast.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapToast Demo',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SnapToast')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Tile('Success', () => SnapToast.success(context, 'Saved!')),
          _Tile('Error', () => SnapToast.error(context, 'Upload failed')),
          _Tile('Warning', () => SnapToast.warning(context, 'Low storage')),
          _Tile('Info', () => SnapToast.info(context, 'Heads up!')),
          const Divider(),
          _Tile(
            'Bottom + Action',
            () => SnapToast.show(
              context,
              ToastConfig(
                type: ToastType.info,
                message: 'Item moved to trash',
                position: ToastPosition.bottom,
                animation: ToastAnimation.scale,
                actionLabel: 'UNDO',
                onAction: () => debugPrint('undo'),
              ),
            ),
          ),
          _Tile(
            'Title + Body',
            () => SnapToast.show(
              context,
              const ToastConfig(
                type: ToastType.success,
                title: 'Payment received',
                message: '\$42.00 from Acme Inc.',
                animation: ToastAnimation.fade,
              ),
            ),
          ),
          _Tile('Rapid calls (safe)', () {
            SnapToast.success(context, 'One');
            SnapToast.info(context, 'Two');
            SnapToast.warning(context, 'Three');
          }),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      );
}
