import 'inspector_model.dart';

abstract class InspectorStore {
  List<InspectorModel> get items;

  void add(InspectorModel model);
  void update(String id, InspectorModel updated);
  void clear();
}

/// Default in-memory store (good for dev + tests)
class MemoryInspectorStore implements InspectorStore {
  final List<InspectorModel> _items = [];

  @override
  List<InspectorModel> get items => _items;

  @override
  void add(InspectorModel model) {
    _items.add(model);
  }

  @override
  void update(String id, InspectorModel updated) {
    final index = _items.indexWhere((e) => e.id == id);
    if (index != -1) {
      _items[index] = updated;
    }
  }

  @override
  void clear() {
    _items.clear();
  }
}

/// Use this in production to disable inspector completely.
class NoOpInspectorStore implements InspectorStore {
  @override
  List<InspectorModel> get items => const [];

  @override
  void add(InspectorModel model) {}

  @override
  void update(String id, InspectorModel updated) {}

  @override
  void clear() {}
}
