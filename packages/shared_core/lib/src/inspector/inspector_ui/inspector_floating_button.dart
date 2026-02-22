import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'inspector_screen.dart';
import 'inspector_store_notifier.dart';

class InspectorOverlayButton extends ConsumerWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const InspectorOverlayButton({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(inspectorStoreProvider);

    return GestureDetector(
      onTap: () {
        final nav = navigatorKey.currentState;
        if (nav == null) return;
        Navigator.of(nav.context).push(
          MaterialPageRoute(builder: (_) => const InspectorScreen()),
        );
      },
      child: Container(
        width: 62,
        height: 62,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 164, 109, 0),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            'Api\nLog\n(${items.length})',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
      ),
    );
  }
}