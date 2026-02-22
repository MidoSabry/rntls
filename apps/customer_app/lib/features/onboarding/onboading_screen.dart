import 'package:customer_app/features/auth/login/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import 'customer_onboarding_data.dart';

class CustomerOnboardingScreen extends StatelessWidget {
  final VoidCallback onDone;
  const CustomerOnboardingScreen({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return OnboardingFlow(
      pages: customerOnboardingPages,
    onDone: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
      onSkip: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
    );
  }
}
