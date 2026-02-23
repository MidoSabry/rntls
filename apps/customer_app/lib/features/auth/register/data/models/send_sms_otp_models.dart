class SendSmsOtpRequest {
  final String phone;
  final String userType;
  final String? rentalUuid;

  const SendSmsOtpRequest({
    required this.phone,
    required this.userType,
    this.rentalUuid,
  });

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'user_type': userType,
        if (rentalUuid != null) 'rental_uuid': rentalUuid,
      };
}

class SendSmsOtpDataDto {
  final String uuid;
  final int? expiresInMinutes;
  final String? phone;

  const SendSmsOtpDataDto({
    required this.uuid,
    this.expiresInMinutes,
    this.phone,
  });

  factory SendSmsOtpDataDto.fromJson(Map<String, dynamic> json) {
    return SendSmsOtpDataDto(
      uuid: (json['uuid'] ?? '').toString(),
      expiresInMinutes: json['expires_in_minutes'] is int
          ? json['expires_in_minutes'] as int
          : int.tryParse((json['expires_in_minutes'] ?? '').toString()),
      phone: json['phone']?.toString(),
    );
  }
}