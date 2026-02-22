import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'inspector_item.dart';
import 'inspector_store_notifier.dart';

class InspectorScreen extends ConsumerWidget {
  const InspectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(inspectorStoreProvider);
    final reversed = list.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Http Calls'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(inspectorStoreProvider.notifier).clear();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear & Close',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: reversed.length,
        itemBuilder: (_, index) => InspectorItem(item: reversed[index]),
      ),
    );
  }
}
