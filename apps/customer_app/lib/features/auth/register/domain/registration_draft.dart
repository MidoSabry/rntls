class RegistrationDraft {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String dateOfBirth; 
  final String aboutMe;

  final String? phoneOtpUuid; 
  final String? emailOtpUuid; 

  final String password;

  final String address;
  final double? lat;
  final double? lng;

  final String? rentalUuid; 

  const RegistrationDraft({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.dateOfBirth = '',
    this.aboutMe = '',
    this.phoneOtpUuid,
    this.emailOtpUuid,
    this.password = '',
    this.address = '',
    this.lat,
    this.lng,
    this.rentalUuid,
  });

  RegistrationDraft copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? dateOfBirth,
    String? aboutMe,
    String? phoneOtpUuid,
    String? emailOtpUuid,
    String? password,
    String? address,
    double? lat,
    double? lng,
    String? rentalUuid,
  }) {
    return RegistrationDraft(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      aboutMe: aboutMe ?? this.aboutMe,
      phoneOtpUuid: phoneOtpUuid ?? this.phoneOtpUuid,
      emailOtpUuid: emailOtpUuid ?? this.emailOtpUuid,
      password: password ?? this.password,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      rentalUuid: rentalUuid ?? this.rentalUuid,
    );
  }
}