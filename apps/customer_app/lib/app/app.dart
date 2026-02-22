import 'package:customer_app/app/providers.dart';
import 'package:customer_app/core/navigation/app_navigator.dart';
import 'package:customer_app/features/onboarding/onboading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart'; // عشان AppEnv + InspectorOverlayButton
import 'package:shared_ui/shared_ui.dart';
import '../core/customer_errror/app_global_error_listener.dart';

class CustomerApp extends ConsumerWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(customerAppEnvProvider);

    return MaterialApp(
      navigatorKey: rootNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'RNTLS Customer',

      builder: (context, child) {
        final wrapped = AppGlobalErrorListener(
          child: child ?? const SizedBox.shrink(),
        );

        if (!env.enableInspector) return wrapped;

        return Stack(
          children: [
            wrapped,
              OFloatingActionButton(
      child: InspectorOverlayButton(navigatorKey: rootNavigatorKey),
    ),
          ],
        );
      },

      home: SplashScreen(
        next: (_) => CustomerOnboardingScreen(
          onDone: () => () {},
        ),
      ),
    );
  }
}