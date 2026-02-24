// apps/customer_app/lib/features/auth/controller/login_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';

import '../../../../../app/providers.dart';
import '../../../../../core/error_handler/error_extensions.dart';
import '../../domain/auth_repository.dart';
import 'login_state.dart';

final loginControllerProvider = NotifierProvider<LoginController, LoginState>(
  LoginController.new,
);

class LoginController extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void setEmail(String v) {
    state = state.copyWith(email: v, emailError: null, generalError: null);
  }

  void setPassword(String v) {
    state = state.copyWith(
      password: v,
      passwordError: null,
      generalError: null,
    );
  }

  String? _validateEmail(String email) {
    final e = email.trim();
    if (e.isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(e);
    if (!ok) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String pass) {
    if (pass.isEmpty) return 'Password is required';
    if (pass.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<bool> submit() async {
    final emailErr = _validateEmail(state.email);
    final passErr = _validatePassword(state.password);

    if (emailErr != null || passErr != null) {
      state = state.copyWith(
        emailError: emailErr,
        passwordError: passErr,
        generalError: null,
      );
      return false;
    }

    state = state.copyWith(isLoading: true, generalError: null);

    final repo = ref.read(authRepositoryProvider);
    final result = await repo.login(
      email: state.email.trim(),
      password: state.password,
    );

    state = state.copyWith(isLoading: false);

    if (result is AppSuccess<AuthTokens>) {
      return true;
    }

    final failure = (result as AppFailure<AuthTokens>).failure;

    // ✅ Validation: خليها Inline
    if (failure is ValidationFailure && failure.fields != null) {
      final fields = failure.fields!;
      state = state.copyWith(
        emailError: fields['email']?.toString(),
        passwordError: fields['password']?.toString(),
        generalError: failure.message, // لو تحب banner فوق
      );
      return false;
    }

    ref.emitFailure(failure);
    return false;
  }

  void clearFailure() {
    state = state.copyWith(lastFailure: null);
  }
}
