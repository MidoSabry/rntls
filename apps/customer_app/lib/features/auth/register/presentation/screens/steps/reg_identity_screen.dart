import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_ui/shared_ui.dart';

import '../../controller/registration_controller.dart';

class RegIdentityScreen extends ConsumerWidget {
  const RegIdentityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.read(registrationControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('We need to verify your identity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          Container(
            height: 260,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(Icons.badge_outlined, size: 90, color: Colors.black38),
            ),
          ),

          const SizedBox(height: 12),
          const Text(
            "To complete your registration, please verify your identity by capturing your ID, driver's license, and a live selfie.",
            style: TextStyle(color: Colors.black54, height: 1.3),
          ),

          const Spacer(),

          SharedButton(
            label: 'Start verifying',
            onPressed: () {
              // دلوقتي: placeholder
              // بعدين هتفتح SDK/Camera flow
              c.next();
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