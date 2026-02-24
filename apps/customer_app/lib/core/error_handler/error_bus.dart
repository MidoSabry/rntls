import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_error.dart';

class ErrorBus extends Notifier<AppError?> {
  @override
  AppError? build() => null;

  void emit(AppError error) => state = error;
  void clear() => state = null;
}

final errorBusProvider = NotifierProvider<ErrorBus, AppError?>(ErrorBus.new);
