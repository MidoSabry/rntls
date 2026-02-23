import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_ui/shared_ui.dart';

import '../../controller/registration_controller.dart';

class RegEmailVerifiedScreen extends ConsumerWidget {
  const RegEmailVerifiedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.read(registrationControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 26, 18, 18),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1DBF73).withOpacity(0.15),
            ),
            child: const Center(
              child: Icon(Icons.check, color: Color(0xFF1DBF73), size: 42),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Email Verified!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          const Text(
            'Your email has been successfully verified.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          const Spacer(),
          SharedButton(
            label: 'Continue',
            onPressed: () => c.next(),
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