import '../../domain/registration_draft.dart';

class RegisterCustomerRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String emailVerificationUuid;

  final String phone;
  final String phoneVerificationUuid;

  final String password;
  final String dateOfBirth;
  final String aboutMe;

  final LocationDto location;

  const RegisterCustomerRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.emailVerificationUuid,
    required this.phone,
    required this.phoneVerificationUuid,
    required this.password,
    required this.dateOfBirth,
    required this.aboutMe,
    required this.location,
  });

  factory RegisterCustomerRequest.fromDraft(RegistrationDraft d) {
    return RegisterCustomerRequest(
      firstName: d.firstName,
      lastName: d.lastName,
      email: d.email,
      emailVerificationUuid: d.emailOtpUuid ?? '',
      phone: d.phone,
      phoneVerificationUuid: d.phoneOtpUuid ?? '',
      password: d.password,
      dateOfBirth: d.dateOfBirth,
      aboutMe: d.aboutMe,
      location: LocationDto(
        address: d.address,
        lat: d.lat ?? 0,
        lng: d.lng ?? 0,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'email_verification_uuid': emailVerificationUuid,
        'phone': phone,
        'phone_verification_uuid': phoneVerificationUuid,
        'location': location.toJson(),
        'password': password,
        'date_of_birth': dateOfBirth,
        'about_me': aboutMe,
      };
}

class LocationDto {
  final String address;
  final double lat;
  final double lng;

  const LocationDto({
    required this.address,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() => {
        'address': address,
        'lat': lat,
        'lng': lng,
      };
}