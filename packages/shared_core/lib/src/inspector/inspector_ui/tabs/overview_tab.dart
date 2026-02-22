import 'package:flutter/material.dart';

import '../../../inspector/inspector_model.dart';
import '../text_kv.dart';

class OverviewTab extends StatelessWidget {
  final InspectorModel inspectorModel;
  const OverviewTab({super.key, required this.inspectorModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextKV(k: 'Method', v: inspectorModel.method ?? ''),
          TextKV(k: 'Server', v: inspectorModel.baseUrl ?? ''),
          TextKV(k: 'Endpoint', v: inspectorModel.uri?.path ?? ''),
          TextKV(k: 'Status', v: (inspectorModel.statusCode?.toString() ?? '')),
          TextKV(k: 'Started', v: inspectorModel.startTime ?? ''),
          TextKV(k: 'Finished', v: inspectorModel.endTime ?? ''),
          TextKV(k: 'Duration', v: inspectorModel.callingTime ?? ''),
          TextKV(k: 'Content-Type', v: inspectorModel.contentType ?? ''),
        ],
      ),
    );
  }
}
