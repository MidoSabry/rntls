class AppEnv {
  final String baseUrl;
  final bool enableLogging;
  final bool enableInspector;

  const AppEnv({
    required this.baseUrl,
    this.enableLogging = false,
    this.enableInspector = false,
  });
}
