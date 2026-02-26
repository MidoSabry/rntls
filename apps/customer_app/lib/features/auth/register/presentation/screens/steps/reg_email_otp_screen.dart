import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_ui/shared_ui.dart';

import '../../controller/registration_controller.dart';
import '../../controller/registration_vm.dart';
import 'widgets/otp_input.dart';

class RegEmailOtpScreen extends ConsumerStatefulWidget {
  const RegEmailOtpScreen({super.key});

  @override
  ConsumerState<RegEmailOtpScreen> createState() => _RegEmailOtpScreenState();
}

class _RegEmailOtpScreenState extends ConsumerState<RegEmailOtpScreen> {
  Timer? _t;
  int _seconds = 30;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _t?.cancel();
    setState(() => _seconds = 30);
    _t = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_seconds <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _seconds--);
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          Text(
            "We've sent a 4-digit verification code to\n${s.draft.email}",
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 18),

          OtpInput(
            value: s.emailCode,
            onChanged: c.setEmailCode,
          ),

          if (s.otpError != null) ...[
            const SizedBox(height: 10),
            Text(s.otpError!, style: const TextStyle(color: Colors.red)),
          ],

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Didn't receive the code?  "),
              TextButton(
                onPressed: _seconds > 0 || isLoading
                    ? null
                    : () {
                        _start();
                        // رجّعك لارسال الكود تاني
                        c.back();
                      },
                child: Text(
                  _seconds > 0
                      ? 'Resend in 00:${_seconds.toString().padLeft(2, '0')}'
                      : 'Resend',
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          SharedButton(
            label: 'Verify Email',
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