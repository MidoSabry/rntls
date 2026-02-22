import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_core/src/inspector/inspector_ui/json_pretty.dart';

import '../../../inspector/inspector_model.dart';

class ResponseTab extends StatelessWidget {
  final InspectorModel inspectorModel;
  const ResponseTab({super.key, required this.inspectorModel});

  @override
  Widget build(BuildContext context) {
    final status = inspectorModel.statusCode;
    final ok = status == 200 || status == 201;
    final statusColor = ok ? Colors.green : Colors.red;

    final headers = inspectorModel.responseHeaders?.toString() ?? '';
    final body = prettyJson(inspectorModel.responseBody);

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
          Text('Received: ${inspectorModel.endTime ?? ''}'),
          const SizedBox(height: 12),
          Text(
            'Status: ${status ?? ''}',
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text('Headers', style: TextStyle(fontWeight: FontWeight.bold)),
          SelectableText(headers),
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
        ],
      ),
    );
  }
}
