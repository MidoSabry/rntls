import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_ui/shared_ui.dart';

import '../../controller/registration_controller.dart';
import '../../controller/registration_vm.dart';

class RegCreatePasswordScreen extends ConsumerWidget {
  const RegCreatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ wrapper + vm
    final vs = ref.watch(registrationControllerProvider);
    final s = vs.dataOrNull ?? const RegistrationVM();
    final isLoading = vs is ViewLoading<RegistrationVM>;

    final c = ref.read(registrationControllerProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set a secure password',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create a strong password to protect your account',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 18),

          SharedTextField(
            label: 'Password',
            hint: 'Enter your Password',
            isPassword: true,
            errorText: s.passwordError,
            onChanged: c.setPassword,
          ),
          const SizedBox(height: 14),

          SharedTextField(
            label: 'Confirm Password',
            hint: 'Re-enter your password',
            isPassword: true,
            errorText: s.confirmPasswordError,
            onChanged: c.setConfirmPassword,
          ),

          const SizedBox(height: 18),

          const Text(
            'Password must contain:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          const _Bullet(text: 'Must be at least 8 characters long.'),
          const _Bullet(text: 'Use a mix of uppercase and lowercase letters.'),
          const _Bullet(text: 'Include numbers and special characters.'),

          const SizedBox(height: 22),

          SharedButton(
            label: 'Create Password',
            onPressed: isLoading ? null : () => c.next(),
            isLoading: isLoading,
            variant: SharedButtonVariant.filled,
            rounded: false,
            radius: 14,
            height: 52,
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD5D5D5)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}