class SendEmailOtpRequest {
  final String email;
  final String userType;
  final String? rentalUuid;

  const SendEmailOtpRequest({
    required this.email,
    required this.userType,
    this.rentalUuid,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'user_type': userType,
        if (rentalUuid != null) 'rental_uuid': rentalUuid,
      };
}

class SendEmailOtpDataDto {
  final String uuid;
  final int? expiresInMinutes;
  final String? email;

  const SendEmailOtpDataDto({
    required this.uuid,
    this.expiresInMinutes,
    this.email,
  });

  factory SendEmailOtpDataDto.fromJson(Map<String, dynamic> json) {
    return SendEmailOtpDataDto(
      uuid: (json['uuid'] ?? '').toString(),
      expiresInMinutes: json['expires_in_minutes'] is int
          ? json['expires_in_minutes'] as int
          : int.tryParse((json['expires_in_minutes'] ?? '').toString()),
      email: json['email']?.toString(),
    );
  }
}