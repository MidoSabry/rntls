class VerifyMobileRequest {
  final String code;
  final String phone;
  final String userType;
  final String uuid;
  final String? rentalUuid;

  const VerifyMobileRequest({
    required this.code,
    required this.phone,
    required this.userType,
    required this.uuid,
    this.rentalUuid,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'phone': phone,
        'user_type': userType,
        'uuid': uuid,
        if (rentalUuid != null) 'rental_uuid': rentalUuid,
      };
}