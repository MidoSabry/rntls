import 'package:shared_core/src/network/response/app_response.dart';
import 'package:shared_core/shared_core.dart';

import '../../../../app/constants/api_endpoints_constants.dart';
import '../domain/registration_draft.dart';
import '../domain/registration_repository.dart';
import 'models/register_customer_models.dart';
import 'models/send_email_otp_models.dart';
import 'models/send_sms_otp_models.dart';
import 'models/verify_email_models.dart';
import 'models/verify_mobile_models.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final ApiClient api;

  RegistrationRepositoryImpl({required this.api});

  @override
  Future<AppResponse<OtpSendResult>> sendSmsOtp({
    required String phone,
    required String userType,
    String? rentalUuid,
  }) {
    return responseHelper(() async {
      final req = SendSmsOtpRequest(
        phone: phone,
        userType: userType,
        rentalUuid: rentalUuid,
      );

      final data = await api.post<SendSmsOtpDataDto>(
        ApiEndpointsConstants.sendSmsOtp,
        body: req.toJson(),
        fromJson: (json) =>
            SendSmsOtpDataDto.fromJson(json as Map<String, dynamic>),
      );

      return OtpSendResult(
        uuid: data.uuid,
        expiresInMinutes: data.expiresInMinutes,
      );
    });
  }

  @override
  Future<AppResponse<void>> verifyMobile({
    required String code,
    required String phone,
    required String uuid,
    required String userType,
    String? rentalUuid,
  }) {
    return responseHelper(() async {
      final req = VerifyMobileRequest(
        code: code,
        phone: phone,
        userType: userType,
        uuid: uuid,
        rentalUuid: rentalUuid,
      );

      await api.post<dynamic>(
        ApiEndpointsConstants.verifyMobile,
        body: req.toJson(),
        fromJson: (json) => json, // we don't care about data for now
      );

      return null;
    });
  }

  @override
  Future<AppResponse<OtpSendResult>> sendEmailOtp({
    required String email,
    required String userType,
    String? rentalUuid,
  }) {
    return responseHelper(() async {
      final req = SendEmailOtpRequest(
        email: email,
        userType: userType,
        rentalUuid: rentalUuid,
      );

      final data = await api.post<SendEmailOtpDataDto>(
        ApiEndpointsConstants.sendEmailOtp,
        body: req.toJson(),
        fromJson: (json) =>
            SendEmailOtpDataDto.fromJson(json as Map<String, dynamic>),
      );

      return OtpSendResult(
        uuid: data.uuid,
        expiresInMinutes: data.expiresInMinutes,
      );
    });
  }

  @override
  Future<AppResponse<void>> verifyEmail({
    required String code,
    required String email,
    required String uid,
    required String userType,
    String? rentalUuid,
  }) {
    return responseHelper(() async {
      final req = VerifyEmailRequest(
        code: code,
        email: email,
        userType: userType,
        uid: uid,
        rentalUuid: rentalUuid,
      );

      await api.post<dynamic>(
        ApiEndpointsConstants.verifyEmail,
        body: req.toJson(),
        fromJson: (json) => json,
      );

      return null;
    });
  }

  @override
  Future<AppResponse<void>> registerCustomer({
    required RegistrationDraft draft,
    required String userType,
  }) {
    return responseHelper(() async {
      final req = RegisterCustomerRequest.fromDraft(draft);

      await api.post<dynamic>(
        ApiEndpointsConstants.createCustomer,
        body: req.toJson(),
        fromJson: (json) => json,
      );

      return null;
    });
  }
}
