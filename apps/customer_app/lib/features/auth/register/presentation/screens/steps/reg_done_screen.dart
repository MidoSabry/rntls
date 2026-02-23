import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_ui/shared_ui.dart';

import '../../controller/registration_controller.dart';

class RegDoneScreen extends ConsumerWidget {
  const RegDoneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(registrationControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 26, 18, 18),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1DBF73).withOpacity(0.15),
            ),
            child: const Center(
              child: Icon(Icons.check, color: Color(0xFF1DBF73), size: 48),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Registration Complete!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          const Text(
            'Welcome to RNTLS. You can now start receive rental requests.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          const Spacer(),
          SharedButton(
            label: 'Move to home',
            onPressed: () {
              // TODO: navigate to home
              Navigator.of(context).pop();
            },
            variant: SharedButtonVariant.filled,
            rounded: false,
            radius: 14,
            height: 52,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}