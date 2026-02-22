import 'package:flutter/material.dart';

import '../../inspector/inspector_model.dart';
import 'inspector_details_screen.dart';

class InspectorItem extends StatelessWidget {
  final InspectorModel item;

  const InspectorItem({super.key, required this.item});

  bool get _ok => item.statusCode == 200 || item.statusCode == 201;

  @override
  Widget build(BuildContext context) {
    final statusColor = _ok ? Colors.green : Colors.red;
    final statusText = _ok ? 'OK ${item.statusCode}' : 'FAIL ${item.statusCode ?? ''}';

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => InspectorDetailsScreen(inspectorModel: item),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      item.uri?.toString() ?? '',
                      style: TextStyle(color: statusColor),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.callingTime ?? '', style: const TextStyle(fontWeight: FontWeight.w300)),
                Text(item.startTime ?? '', style: const TextStyle(fontWeight: FontWeight.w300)),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
