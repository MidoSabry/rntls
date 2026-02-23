import 'package:customer_app/core/customer_network/app_response.dart';

import 'registration_draft.dart';

class OtpSendResult {
  final String uuid;
  final int? expiresInMinutes;

  const OtpSendResult({required this.uuid, this.expiresInMinutes});
}

abstract class RegistrationRepository {
  Future<AppResponse<OtpSendResult>> sendSmsOtp({
    required String phone,
    required String userType, // "customer"
    String? rentalUuid,
  });

  Future<AppResponse<void>> verifyMobile({
    required String code,
    required String phone,
    required String uuid,
    required String userType,
    String? rentalUuid,
  });

  Future<AppResponse<OtpSendResult>> sendEmailOtp({
    required String email,
    required String userType,
    String? rentalUuid,
  });

  Future<AppResponse<void>> verifyEmail({
    required String code,
    required String email,
    required String uid,
    required String userType,
    String? rentalUuid,
  });

  Future<AppResponse<void>> registerCustomer({
    required RegistrationDraft draft,
    required String userType, // "customer"
  });
}
