import 'package:flutter/material.dart';
import 'package:shared_core/src/inspector/inspector_ui/json_pretty.dart';
import '../../../inspector/inspector_model.dart';

class ErrorTab extends StatelessWidget {
  final InspectorModel inspectorModel;
  const ErrorTab({super.key, required this.inspectorModel});

  @override
  Widget build(BuildContext context) {
    final ok = inspectorModel.statusCode == 200 || inspectorModel.statusCode == 201;
    if (ok) {
      return const Center(child: Text('Nothing to Preview Here'));
    }

    final errorMsg = inspectorModel.error ?? '';
    final body = prettyJson(inspectorModel.responseBody);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Error', style: TextStyle(fontWeight: FontWeight.bold)),
          SelectableText(errorMsg),
          const SizedBox(height: 16),
          const Text('Response Body', style: TextStyle(fontWeight: FontWeight.bold)),
          SelectableText(body),
        ],
      ),
    );
  }
}
