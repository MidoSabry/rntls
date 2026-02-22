import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../inspector/inspector_model.dart';
import '../../inspector/inspector_store.dart';

class InspectorStoreNotifier extends Notifier<List<InspectorModel>>
    implements InspectorStore {
  @override
  List<InspectorModel> build() => const [];

  @override
  List<InspectorModel> get items => state;

  @override
  void add(InspectorModel model) {
    state = [...state, model];
  }

  @override
  void update(String id, InspectorModel updated) {
    final idx = state.indexWhere((e) => e.id == id);
    if (idx == -1) return;

    final copy = [...state];
    copy[idx] = updated;
    state = copy;
  }

  @override
  void clear() {
    state = const [];
  }
}

/// UI watches this list
final inspectorStoreProvider =
    NotifierProvider<InspectorStoreNotifier, List<InspectorModel>>(
  InspectorStoreNotifier.new,
);

/// Interceptor needs InspectorStore (not the list)
final inspectorStoreAsCoreProvider = Provider<InspectorStore>((ref) {
  return ref.read(inspectorStoreProvider.notifier);
});
