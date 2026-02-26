import '../../domain/registration_draft.dart';
import '../../domain/registration_step.dart';

class RegistrationVM {
  final RegistrationStep step;
  final RegistrationDraft draft;

  // OTP
  final String phoneCode;
  final String emailCode;
  final String? otpError;

  // inline errors
  final String? firstNameError;
  final String? lastNameError;
  final String? emailError;
  final String? phoneError;
  final String? dobError;
  final String? aboutError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? addressError;

  final String confirmPassword;
  final int resendSeconds;

  const RegistrationVM({
    this.step = RegistrationStep.basicInfo,
    this.draft = const RegistrationDraft(),
    this.phoneCode = '',
    this.emailCode = '',
    this.otpError,
    this.firstNameError,
    this.lastNameError,
    this.emailError,
    this.phoneError,
    this.dobError,
    this.aboutError,
    this.passwordError,
    this.confirmPasswordError,
    this.addressError,
    this.confirmPassword = '',
    this.resendSeconds = 0,
  });

  RegistrationVM copyWith({
    RegistrationStep? step,
    RegistrationDraft? draft,
    String? phoneCode,
    String? emailCode,
    String? otpError,

    String? firstNameError,
    String? lastNameError,
    String? emailError,
    String? phoneError,
    String? dobError,
    String? aboutError,
    String? passwordError,
    String? confirmPasswordError,
    String? addressError,

    String? confirmPassword,
    int? resendSeconds,
    bool clearErrors = false,
  }) {
    return RegistrationVM(
      step: step ?? this.step,
      draft: draft ?? this.draft,
      phoneCode: phoneCode ?? this.phoneCode,
      emailCode: emailCode ?? this.emailCode,

      otpError: clearErrors ? null : (otpError ?? this.otpError),

      firstNameError: clearErrors ? null : firstNameError,
      lastNameError: clearErrors ? null : lastNameError,
      emailError: clearErrors ? null : emailError,
      phoneError: clearErrors ? null : phoneError,
      dobError: clearErrors ? null : dobError,
      aboutError: clearErrors ? null : aboutError,
      passwordError: clearErrors ? null : passwordError,
      confirmPasswordError: clearErrors ? null : confirmPasswordError,
      addressError: clearErrors ? null : addressError,

      confirmPassword: confirmPassword ?? this.confirmPassword,
      resendSeconds: resendSeconds ?? this.resendSeconds,
    );
  }
}