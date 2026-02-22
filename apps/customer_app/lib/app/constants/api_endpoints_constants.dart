import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpointsConstants {
  static String get baseUrl => dotenv.env['BASE_URL_DEV'] ?? '';

  static String get loginEndpoint => dotenv.env['LOGIN_ENDPOINT'] ?? '';

}