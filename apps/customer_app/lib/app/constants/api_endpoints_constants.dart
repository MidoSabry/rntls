import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpointsConstants {
  static String get baseUrl => dotenv.env['BASE_URL_DEV'] ?? '';

  static String get loginEndpoint => dotenv.env['LOGIN_ENDPOINT'] ?? '';

  static String get createCustomer => dotenv.env['CREATE_CUSTOER'] ?? '';

  static String get sendSmsOtp => dotenv.env['SEND_SMMS_OTP'] ?? '';

  static String get verifyMobile => dotenv.env['VERIFY_MOBILE'] ?? '';

  static String get sendEmailOtp => dotenv.env['SEND_EMAIL_OTP'] ?? '';

  static String get verifyEmail => dotenv.env['VERIFY_EMAIL'] ?? '';



}