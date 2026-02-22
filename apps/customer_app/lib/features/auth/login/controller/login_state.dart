// apps/customer_app/lib/features/auth/controller/login_state.dart

import 'package:shared_core/shared_core.dart';

class LoginState {
  final String email;
  final String password;

  final bool isLoading;

  final String? emailError;
  final String? passwordError;

  final String? generalError;

  final Failure? lastFailure;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.emailError,
    this.passwordError,
    this.generalError,
    this.lastFailure
  });

  bool get canSubmit =>
      !isLoading && email.trim().isNotEmpty && password.isNotEmpty;

  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? emailError,
    String? passwordError,
    String? generalError,
    Failure? lastFailure
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      emailError: emailError,
      passwordError: passwordError,
      generalError: generalError,
      lastFailure: lastFailure,
    );
  }
}