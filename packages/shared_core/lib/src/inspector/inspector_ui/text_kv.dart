import 'package:flutter/material.dart';

class TextKV extends StatelessWidget {
  final String k;
  final String v;

  const TextKV({super.key, required this.k, required this.v});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text('$k:', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }
}
