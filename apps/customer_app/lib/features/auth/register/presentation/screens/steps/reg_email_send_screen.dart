import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_ui/shared_ui.dart';

import '../../controller/registration_controller.dart';
import '../../controller/registration_vm.dart';

class RegEmailSendScreen extends ConsumerWidget {
  const RegEmailSendScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ wrapper + vm + loading
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
            'Verify your email',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            "We'll send a verification code to confirm your email address.",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 18),

          SharedTextField(
            label: 'Email',
            hint: 'rntls@gmail.com',
            prefix: const Icon(Icons.email_outlined),
            errorText: s.emailError,
            initialValue: s.draft.email,
            onChanged: c.setEmail,
          ),

          const SizedBox(height: 18),

          SharedButton(
            label: 'Send Verification Code',
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