import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/registration_controller.dart';
import '../controller/registration_state.dart';
import '../../domain/registration_step.dart';

import 'steps/reg_basic_info_screen.dart';
import 'steps/reg_phone_otp_screen.dart';
import 'steps/reg_email_send_screen.dart';
import 'steps/reg_email_otp_screen.dart';
import 'steps/reg_email_verified_screen.dart';
import 'steps/reg_create_password_screen.dart';
import 'steps/reg_address_screen.dart';
import 'steps/reg_identity_screen.dart';
import 'steps/reg_done_screen.dart';

class RegistrationFlowScreen extends ConsumerWidget {
  const RegistrationFlowScreen({super.key});

  int _stepIndex(RegistrationStep s) {
    return switch (s) {
      RegistrationStep.basicInfo => 0,
      RegistrationStep.phoneOtp => 1,
      RegistrationStep.emailSend => 2,
      RegistrationStep.emailOtp => 3,
      RegistrationStep.emailVerified => 4,
      RegistrationStep.createPassword => 5,
      RegistrationStep.address => 6,
      RegistrationStep.identity => 7,
      RegistrationStep.submit => 8,
      RegistrationStep.done => 9,
    };
  }

  int _totalSteps() => 6; 

  int _mainProgressStep(RegistrationStep s) {
    return switch (s) {
      RegistrationStep.basicInfo => 1,
      RegistrationStep.phoneOtp => 2,
      RegistrationStep.emailSend || RegistrationStep.emailOtp || RegistrationStep.emailVerified => 3,
      RegistrationStep.createPassword => 4,
      RegistrationStep.address => 5,
      RegistrationStep.identity || RegistrationStep.submit || RegistrationStep.done => 6,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RegistrationState state = ref.watch(registrationControllerProvider);
    final ctrl = ref.read(registrationControllerProvider.notifier);

    final Widget body = switch (state.step) {
      RegistrationStep.basicInfo => const RegBasicInfoScreen(),
      RegistrationStep.phoneOtp => const RegPhoneOtpScreen(),
      RegistrationStep.emailSend => const RegEmailSendScreen(),
      RegistrationStep.emailOtp => const RegEmailOtpScreen(),
      RegistrationStep.emailVerified => const RegEmailVerifiedScreen(),
      RegistrationStep.createPassword => const RegCreatePasswordScreen(),
      RegistrationStep.address => const RegAddressScreen(),
      RegistrationStep.identity => const RegIdentityScreen(),
      RegistrationStep.submit => const SizedBox.shrink(), // loading overlay
      RegistrationStep.done => const RegDoneScreen(),
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: state.isLoading
              ? null
              : () {
                  if (state.step == RegistrationStep.basicInfo ||
                      state.step == RegistrationStep.done) {
                    Navigator.of(context).pop();
                    return;
                  }
                  ctrl.back();
                },
        ),
        title: const Text(
          'Customer Registration',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _ProgressHeader(
                totalSteps: _totalSteps(),
                currentStep: _mainProgressStep(state.step),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: KeyedSubtree(
                    key: ValueKey(_stepIndex(state.step)),
                    child: body,
                  ),
                ),
              ),
            ],
          ),

          if (state.isLoading || state.step == RegistrationStep.submit)
            const Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(
                  color: Color(0x55FFFFFF),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const _ProgressHeader({
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final done = currentStep.clamp(0, totalSteps);
    final remainingText = totalSteps - done;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Finish $remainingText steps to get your account ready.',
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(totalSteps, (i) {
              final filled = i < done;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i == totalSteps - 1 ? 0 : 6),
                  height: 4,
                  decoration: BoxDecoration(
                    color: filled ? const Color(0xFF1DBF73) : const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}