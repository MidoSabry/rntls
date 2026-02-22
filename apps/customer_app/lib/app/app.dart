import 'package:customer_app/features/onboarding/onboading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_ui/shared_ui.dart';

class CustomerApp extends ConsumerWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RNTLS Customer',
      home:   SplashScreen(
        next: (_) =>  CustomerOnboardingScreen(
          onDone: () =>(){}
        ),
      ),
    );
  }
}
