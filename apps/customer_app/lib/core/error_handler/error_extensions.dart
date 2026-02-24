import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';

import 'app_error_mapper.dart';
import 'error_bus.dart';

extension ErrorEmitX on Ref {
  void emitFailure(
    Failure f, {
    String? messageOverride,
    String? titleOverride,
    String? codeOverride,
  }) {
    final appError = AppErrorMapper.fromFailure(
      f,
      messageOverride: messageOverride,
      titleOverride: titleOverride,
      codeOverride: codeOverride,
    );
    read(errorBusProvider.notifier).emit(appError);
  }
}