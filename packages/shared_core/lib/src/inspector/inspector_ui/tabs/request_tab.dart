import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_core/src/inspector/inspector_ui/json_pretty.dart';

import '../../../inspector/inspector_model.dart';

class RequestTab extends StatelessWidget {
  final InspectorModel inspectorModel;
  const RequestTab({super.key, required this.inspectorModel});

  @override
  Widget build(BuildContext context) {
    final headers = inspectorModel.requestHeaders?.toString() ?? '';
    final query = inspectorModel.queryParameters?.toString() ?? '';
    final body = prettyJson(inspectorModel.data);

    Future<void> copy(String text) async {
      await Clipboard.setData(ClipboardData(text: text));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied to clipboard')),
        );
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Started: ${inspectorModel.startTime ?? ''}'),
          const SizedBox(height: 12),
          const Text('Headers', style: TextStyle(fontWeight: FontWeight.bold)),
          SelectableText(headers),
          const SizedBox(height: 12),
          const Text('Query', style: TextStyle(fontWeight: FontWeight.bold)),
          SelectableText(query),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Text('Body', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () => copy(body),
                child: const Text('Copy'),
              )
            ],
          ),
          SelectableText(body),
          const SizedBox(height: 12),
          const Text('Authorization', style: TextStyle(fontWeight: FontWeight.bold)),
          SelectableText(inspectorModel.authorization ?? ''),
        ],
      ),
    );
  }
}
