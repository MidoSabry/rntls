class VerifyEmailRequest {
  final String code;
  final String email;
  final String userType;
  final String uid;
  final String? rentalUuid;

  const VerifyEmailRequest({
    required this.code,
    required this.email,
    required this.userType,
    required this.uid,
    this.rentalUuid,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'email': email,
        'user_type': userType,
        'uuid': uid,
        if (rentalUuid != null) 'rental_uuid': rentalUuid,
      };
}