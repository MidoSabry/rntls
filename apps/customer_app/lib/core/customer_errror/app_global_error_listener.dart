import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../navigation/app_navigator.dart';
import 'app_error.dart';
import 'error_bus.dart';

class AppGlobalErrorListener extends ConsumerStatefulWidget {
  final Widget child;
  const AppGlobalErrorListener({super.key, required this.child});

  @override
  ConsumerState<AppGlobalErrorListener> createState() =>
      _AppGlobalErrorListenerState();
}

class _AppGlobalErrorListenerState extends ConsumerState<AppGlobalErrorListener> {
  bool _sheetOpen = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<AppError?>(errorBusProvider, (prev, next) {
      if (next == null) return;
      if (_sheetOpen) return;

      _sheetOpen = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final nav = rootNavigatorKey.currentState;
        if (nav == null) {
          _sheetOpen = false;
          return;
        }

        await showModalBottomSheet<void>(
          context: nav.context,
          useRootNavigator: true,
          isScrollControlled: true,
          showDragHandle: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          builder: (_) => _ErrorBottomSheet(error: next),
        );

        ref.read(errorBusProvider.notifier).clear();
        _sheetOpen = false;
      });
    });

    return widget.child;
  }
}

class _ErrorBottomSheet extends StatelessWidget {
  final AppError error;
  const _ErrorBottomSheet({required this.error});

  IconData _iconFor(AppError e) {
    if (e.isUnauthorized) return Icons.lock_outline;
    return Icons.error_outline;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 14, 16, 16 + bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(_iconFor(error), size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  error.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              error.message,
              style: const TextStyle(fontSize: 14, height: 1.3),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }
}