import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'inspector_screen.dart';
import 'inspector_store_notifier.dart';

class InspectorFloatingButton extends ConsumerWidget {
  const InspectorFloatingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(inspectorStoreProvider);

    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const InspectorScreen()),
        );
      },
      child: Text(
        'Api\nLog\n(${items.length})',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }
}
