abstract class AppLogger {
  void d(String message); // debug
  void i(String message); // info
  void w(String message); // warn
  void e(String message, {Object? error, StackTrace? stackTrace}); // error
}

class ConsoleLogger implements AppLogger {
  @override
  void d(String message) => _p('D', message);

  @override
  void i(String message) => _p('I', message);

  @override
  void w(String message) => _p('W', message);

  @override
  void e(String message, {Object? error, StackTrace? stackTrace}) {
    _p('E', message);
    if (error != null) _p('E', 'error: $error');
    if (stackTrace != null) _p('E', 'stack: $stackTrace');
  }

  void _p(String level, String message) {
    // ignore: avoid_print
    print('[$level] $message');
  }
}

/// Useful for production or tests when you want no logs.
class NoOpLogger implements AppLogger {
  @override
  void d(String message) {}

  @override
  void i(String message) {}

  @override
  void w(String message) {}

  @override
  void e(String message, {Object? error, StackTrace? stackTrace}) {}
}
