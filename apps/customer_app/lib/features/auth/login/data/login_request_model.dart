// apps/customer_app/lib/features/auth/data/models/login_models.dart

class LoginRequest {
  final String email;
  final String password;
  final String userType; // customer

  const LoginRequest({
    required this.email,
    required this.password,
    this.userType = 'customer',
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'user_type': userType,
      };
}

class UserDto {
  final int id;
  final String name;
  final String email;

  const UserDto({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: (json['id'] ?? 0) as int,
        name: (json['name'] ?? '') as String,
        email: (json['email'] ?? '') as String,
      );
}

class LoginDataDto {
  final UserDto user;
  final String token;
  final String? refreshToken;

  const LoginDataDto({
    required this.user,
    required this.token,
    this.refreshToken,
  });

  factory LoginDataDto.fromJson(Map<String, dynamic> json) => LoginDataDto(
        user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
        token: (json['token'] ?? '') as String,
        refreshToken: json['refresh_token'] as String?,
      );
}