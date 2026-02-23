// apps/customer_app/lib/features/auth/presentation/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_ui/shared_ui.dart';

import '../../register/presentation/screens/registration_flow_screen.dart';
import '../controller/login_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    // close keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    // avoid double submit
    final state = ref.read(loginControllerProvider);
    if (state.isLoading) return;

    final ok = await ref.read(loginControllerProvider.notifier).submit();
    if (!ok) return;

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Logged in ✅')));

    // TODO: Navigator.pushReplacement(Home)
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 26),

              Image.asset('assets/images/rntls_logo.png', width: 110),

              const SizedBox(height: 12),
              const Text(
                'Sign In To Rent A Vehicle',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 28),

              // if (state.generalError != null) ...[
              //   _ErrorBanner(message: state.generalError!),
              //   const SizedBox(height: 12),
              // ],
              AutofillGroup(
                child: Column(
                  children: [
                    SharedTextField(
                      key: const ValueKey('login_email'),
                      label: 'Email',
                      hint: 'rntls@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefix: const Icon(Icons.email_outlined),
                      errorText: state.emailError,
                      // autofillHints: const [AutofillHints.username, AutofillHints.email],
                      onChanged: ref
                          .read(loginControllerProvider.notifier)
                          .setEmail,
                    ),

                    const SizedBox(height: 14),

                    SharedTextField(
                      key: const ValueKey('login_password'),
                      label: 'Password',
                      hint: '********',
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      prefix: const Icon(Icons.lock_outline),
                      errorText: state.passwordError,
                      // autofillHints: const [AutofillHints.password],
                      onChanged: ref
                          .read(loginControllerProvider.notifier)
                          .setPassword,
                      onSubmitted: (_) => _submit(context, ref),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          // TODO: navigate to forgot password
                        },
                  child: const Text('Forgot password?'),
                ),
              ),

              const SizedBox(height: 6),

              SharedButton(
                label: 'Sign in',
                onPressed: state.isLoading ? null : () => _submit(context, ref),
                isLoading: state.isLoading,
                variant: SharedButtonVariant.filled,
                rounded: false,
                radius: 14,
                height: 52,
              ),

              const SizedBox(height: 18),

              const Text('or', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialIconButton(
                    asset: 'assets/images/google.png',
                    onTap: state.isLoading
                        ? null
                        : () {
                            // TODO: google sign in
                          },
                  ),
                  const SizedBox(width: 12),
                  _SocialIconButton(
                    asset: 'assets/images/apple.png',
                    onTap: state.isLoading
                        ? null
                        : () {
                            // TODO: apple sign in
                          },
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New to RNTLS? '),
                  SharedButton(
                    label: 'Sign up',
                    onPressed: state.isLoading
                        ? null
                        : () {
                            // TODO: navigate to sign up
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RegistrationFlowScreen(),
                              ),
                            );
                          },
                    variant: SharedButtonVariant.text,
                    fullWidth: false,
                    rounded: true,
                    height: 40,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'If you already have an existing request,\nplease open it from the SMS or Email you received.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, height: 1.3),
                ),
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// class _ErrorBanner extends StatelessWidget {
//   final String message;
//   const _ErrorBanner({required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFFF2F2),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFFFC7C7)),
//       ),
//       child: Text(
//         message,
//         style: const TextStyle(color: Color(0xFFB00020)),
//       ),
//     );
//   }
// }

class _SocialIconButton extends StatelessWidget {
  final String asset;
  final VoidCallback? onTap;

  const _SocialIconButton({required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Opacity(
        opacity: onTap == null ? 0.6 : 1,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE6E6E6)),
          ),
          child: Center(child: Image.asset(asset, width: 22, height: 22)),
        ),
      ),
    );
  }
}
