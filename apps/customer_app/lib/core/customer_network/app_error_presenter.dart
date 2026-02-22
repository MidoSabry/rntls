// customer_app/lib/app/error_presenter.dart
import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';

class ErrorPresenter {
  Future<void> show(BuildContext context, Failure failure) async {
    final title = _titleFor(failure);
    final message = failure.message; // دي جاية من الباك اند/mapper

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _titleFor(Failure f) {
    return switch (f) {
      NetworkFailure() => 'No Internet',
      TimeoutFailure() => 'Timeout',
      UnauthorizedFailure() => 'Unauthorized',
      ForbiddenFailure() => 'Forbidden',
      NotFoundFailure() => 'Not Found',
      ValidationFailure() => 'Validation Error',
      ServerFailure() => 'Server Error',
      UnknownFailure() => 'Error',
      // ignore: unreachable_switch_case
      (_) => 'Error',
    };
  }
}