import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snap_toast/snap_toast.dart';

Widget _host(VoidCallback onTap) => MaterialApp(
  home: Scaffold(
    body: Builder(
      builder: (context) =>
          ElevatedButton(onPressed: onTap, child: const Text('Go')),
    ),
  ),
);

void main() {
  testWidgets('shows a success toast', (tester) async {
    await tester.pumpWidget(_host(() {}));
    final context = tester.element(find.text('Go'));

    SnapToast.success(context, 'Saved!');
    await tester.pump(); // build overlay
    await tester.pump(const Duration(milliseconds: 400)); // finish entry anim

    expect(find.text('Saved!'), findsOneWidget);
  });

  testWidgets('auto dismisses after duration', (tester) async {
    await tester.pumpWidget(_host(() {}));
    final context = tester.element(find.text('Go'));

    SnapToast.show(
      context,
      const ToastConfig(message: 'Bye', duration: Duration(milliseconds: 1000)),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Toast should still be visible.
    expect(find.text('Bye'), findsOneWidget);

    // Advance past its dismissal duration.
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pumpAndSettle();

    expect(find.text('Bye'), findsNothing);
  });

  testWidgets('rapid calls replace previous toast', (tester) async {
    await tester.pumpWidget(_host(() {}));
    final context = tester.element(find.text('Go'));

    SnapToast.success(context, 'First');
    SnapToast.info(context, 'Second');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('First'), findsNothing);
    expect(find.text('Second'), findsOneWidget);
  });
}
