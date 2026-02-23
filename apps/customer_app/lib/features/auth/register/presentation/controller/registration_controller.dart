import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';

import '../../../../../app/providers.dart';
import '../../../../../core/customer_errror/error_extensions.dart';
import '../../../../../core/customer_network/app_response.dart';
import '../../domain/registration_repository.dart';
import '../../domain/registration_step.dart';
import 'registration_state.dart';

final registrationControllerProvider =
    NotifierProvider<RegistrationController, RegistrationState>(
      RegistrationController.new,
    );

class RegistrationController extends Notifier<RegistrationState> {
  static const _userType = 'customer';

  @override
  RegistrationState build() => const RegistrationState();

  // -------------------------
  // Setters for draft fields
  // -------------------------
  void setFirstName(String v) => state = state.copyWith(
    draft: state.draft.copyWith(firstName: v),
    firstNameError: null,
  );

  void setLastName(String v) => state = state.copyWith(
    draft: state.draft.copyWith(lastName: v),
    lastNameError: null,
  );

  void setEmail(String v) => state = state.copyWith(
    draft: state.draft.copyWith(email: v),
    emailError: null,
  );

  void setPhone(String v) => state = state.copyWith(
    draft: state.draft.copyWith(phone: v),
    phoneError: null,
  );

  void setDob(String v) => state = state.copyWith(
    draft: state.draft.copyWith(dateOfBirth: v),
    dobError: null,
  );

  void setAbout(String v) => state = state.copyWith(
    draft: state.draft.copyWith(aboutMe: v),
    aboutError: null,
  );

  // ✅ لما أغير password امسح confirm error لو كان mismatch
  void setPassword(String v) => state = state.copyWith(
    draft: state.draft.copyWith(password: v),
    passwordError: null,
    confirmPasswordError: null,
  );

  void setConfirmPassword(String v) {
    state = state.copyWith(confirmPassword: v, confirmPasswordError: null);
  }

  void setAddress({required String address, double? lat, double? lng}) {
    state = state.copyWith(
      draft: state.draft.copyWith(address: address, lat: lat, lng: lng),
      addressError: null,
    );
  }

  // OTP code inputs
  void setPhoneCode(String v) =>
      state = state.copyWith(phoneCode: v, otpError: null);

  void setEmailCode(String v) =>
      state = state.copyWith(emailCode: v, otpError: null);

  // -------------------------
  // Validation helpers
  // -------------------------
  String? _req(String v, String msg) => v.trim().isEmpty ? msg : null;

  String? _validateEmail(String email) {
    final e = email.trim();
    if (e.isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(e);
    if (!ok) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String p) {
    if (p.isEmpty) return 'Password is required';
    if (p.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  String? _fieldMsg(Map<String, dynamic> fields, String key) {
    final v = fields[key];
    if (v == null) return null;
    if (v is List && v.isNotEmpty) return v.first.toString();
    return v.toString();
  }

  // -------------------------
  // Flow actions
  // -------------------------
  void back() {
    final s = state.step;
    final prev = switch (s) {
      RegistrationStep.basicInfo => RegistrationStep.basicInfo,
      RegistrationStep.phoneOtp => RegistrationStep.basicInfo,
      RegistrationStep.emailSend => RegistrationStep.phoneOtp,
      RegistrationStep.emailOtp => RegistrationStep.emailSend,
      RegistrationStep.emailVerified => RegistrationStep.emailOtp,
      RegistrationStep.createPassword => RegistrationStep.emailVerified,
      RegistrationStep.address => RegistrationStep.createPassword,
      RegistrationStep.identity => RegistrationStep.address,
      RegistrationStep.submit => RegistrationStep.identity,
      RegistrationStep.done => RegistrationStep.done,
    };

    state = state.copyWith(step: prev, clearErrors: true, otpError: null);
  }

  Future<void> next() async {
    if (state.isLoading) return;

    switch (state.step) {
      case RegistrationStep.basicInfo:
        await _submitBasicInfo();
        return;

      case RegistrationStep.phoneOtp:
        await _submitPhoneOtp();
        return;

      case RegistrationStep.emailSend:
        await _sendEmailOtp();
        return;

      case RegistrationStep.emailOtp:
        await _submitEmailOtp();
        return;

      case RegistrationStep.emailVerified:
        state = state.copyWith(
          step: RegistrationStep.createPassword,
          clearErrors: true,
          otpError: null,
        );
        return;

      case RegistrationStep.createPassword:
        await _submitPasswordStep();
        return;

      case RegistrationStep.address:
        await _submitAddressStep();
        return;

      case RegistrationStep.identity:
        // placeholder: identity done
        state = state.copyWith(
          step: RegistrationStep.submit,
          clearErrors: true,
        );
        await _submitRegister();
        return;

      case RegistrationStep.submit:
        await _submitRegister();
        return;

      case RegistrationStep.done:
        return;
    }
  }

  // -------- Basic info -> send sms otp
  Future<void> _submitBasicInfo() async {
    final d = state.draft;

    final fnErr = _req(d.firstName, 'First name is required');
    final lnErr = _req(d.lastName, 'Last name is required');
    final emErr = _validateEmail(d.email);
    final phErr = _req(d.phone, 'Phone is required');
    final dobErr = _req(d.dateOfBirth, 'Date of birth is required');

    if (fnErr != null ||
        lnErr != null ||
        emErr != null ||
        phErr != null ||
        dobErr != null) {
      state = state.copyWith(
        firstNameError: fnErr,
        lastNameError: lnErr,
        emailError: emErr,
        phoneError: phErr,
        dobError: dobErr,
      );
      return;
    }

    state = state.copyWith(
      isLoading: true,
      clearErrors: true,
      otpError: null,
      phoneCode: '',
    );

    final repo = ref.read(registrationRepositoryProvider);
    final res = await repo.sendSmsOtp(
      phone: d.phone.trim(),
      userType: _userType,
      rentalUuid: d.rentalUuid,
    );

    state = state.copyWith(isLoading: false);

    if (res is AppSuccess<OtpSendResult>) {
      state = state.copyWith(
        draft: d.copyWith(phoneOtpUuid: res.data.uuid),
        step: RegistrationStep.phoneOtp,
      );
      return;
    }

    final failure = (res as AppFailure<OtpSendResult>).failure;
    ref.emitFailure(failure);
  }

  // -------- verify phone -> go email send screen
  Future<void> _submitPhoneOtp() async {
    final d = state.draft;
    final code = state.phoneCode.trim();

    if (code.isEmpty) {
      state = state.copyWith(otpError: 'Enter the code');
      return;
    }
    if (d.phoneOtpUuid == null || d.phoneOtpUuid!.isEmpty) {
      state = state.copyWith(
        otpError: 'Missing verification uuid. Resend code.',
      );
      return;
    }

    state = state.copyWith(isLoading: true, otpError: null);

    final repo = ref.read(registrationRepositoryProvider);
    final res = await repo.verifyMobile(
      code: code,
      phone: d.phone.trim(),
      uuid: d.phoneOtpUuid!,
      userType: _userType,
      rentalUuid: d.rentalUuid,
    );

    state = state.copyWith(isLoading: false);

    if (res is AppSuccess<void>) {
      state = state.copyWith(
        step: RegistrationStep.emailSend,
        clearErrors: true,
        otpError: null,
        emailCode: '',
      );
      return;
    }

    final failure = (res as AppFailure<void>).failure;
    state = state.copyWith(otpError: failure.message);
  }

  // -------- send email otp -> go emailOtp screen
  Future<void> _sendEmailOtp() async {
    final d = state.draft;

    final emErr = _validateEmail(d.email);
    if (emErr != null) {
      state = state.copyWith(emailError: emErr);
      return;
    }

    state = state.copyWith(
      isLoading: true,
      otpError: null,
      clearErrors: true,
      emailCode: '',
    );

    final repo = ref.read(registrationRepositoryProvider);
    final emailRes = await repo.sendEmailOtp(
      email: d.email.trim(),
      userType: _userType,
      rentalUuid: d.rentalUuid,
    );

    state = state.copyWith(isLoading: false);

    if (emailRes is AppSuccess<OtpSendResult>) {
      state = state.copyWith(
        draft: d.copyWith(emailOtpUuid: emailRes.data.uuid),
        step: RegistrationStep.emailOtp,
      );
      return;
    }

    final failure = (emailRes as AppFailure<OtpSendResult>).failure;
    ref.emitFailure(failure);
  }

  // -------- verify email -> go emailVerified screen
  Future<void> _submitEmailOtp() async {
    final d = state.draft;
    final code = state.emailCode.trim();

    if (code.isEmpty) {
      state = state.copyWith(otpError: 'Enter the code');
      return;
    }
    if (d.emailOtpUuid == null || d.emailOtpUuid!.isEmpty) {
      state = state.copyWith(
        otpError: 'Missing verification uuid. Resend code.',
      );
      return;
    }

    state = state.copyWith(isLoading: true, otpError: null);

    final repo = ref.read(registrationRepositoryProvider);
    final res = await repo.verifyEmail(
      code: code,
      email: d.email.trim(),
      uid: d.emailOtpUuid!,
      userType: _userType,
      rentalUuid: d.rentalUuid,
    );

    state = state.copyWith(isLoading: false);

    if (res is AppSuccess<void>) {
      state = state.copyWith(
        step: RegistrationStep.emailVerified,
        clearErrors: true,
        otpError: null,
      );
      return;
    }

    final failure = (res as AppFailure<void>).failure;
    state = state.copyWith(otpError: failure.message);
  }

  // -------- password step -> address
  Future<void> _submitPasswordStep() async {
    final pass = state.draft.password;
    final confirm = state.confirmPassword;

    final pErr = _validatePassword(pass);

    String? cErr;
    if (confirm.trim().isEmpty) {
      cErr = 'Confirm password is required';
    } else if (confirm != pass) {
      cErr = 'Passwords do not match';
    }

    if (pErr != null || cErr != null) {
      state = state.copyWith(passwordError: pErr, confirmPasswordError: cErr);
      return;
    }

    state = state.copyWith(step: RegistrationStep.address, clearErrors: true);
  }

  // -------- address -> identity
  Future<void> _submitAddressStep() async {
    final d = state.draft;

    final aErr = _req(d.address, 'Address is required');
    if (aErr != null) {
      state = state.copyWith(addressError: aErr);
      return;
    }

    state = state.copyWith(step: RegistrationStep.identity, clearErrors: true);
  }

  // -------- register
  Future<void> _submitRegister() async {
    final d = state.draft;

    if (d.phoneOtpUuid == null || d.phoneOtpUuid!.isEmpty) {
      state = state.copyWith(
        step: RegistrationStep.phoneOtp,
        otpError: 'Verify phone first',
      );
      return;
    }
    if (d.emailOtpUuid == null || d.emailOtpUuid!.isEmpty) {
      state = state.copyWith(
        step: RegistrationStep.emailSend,
        otpError: 'Verify email first',
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearErrors: true, otpError: null);

    final repo = ref.read(registrationRepositoryProvider);
    final res = await repo.registerCustomer(draft: d, userType: _userType);

    state = state.copyWith(isLoading: false);

    if (res is AppSuccess<void>) {
      state = state.copyWith(step: RegistrationStep.done, clearErrors: true);
      return;
    }

    final failure = (res as AppFailure<void>).failure;

    if (failure is ValidationFailure && failure.fields != null) {
      final fields = failure.fields!;
      state = state.copyWith(
        firstNameError: _fieldMsg(fields, 'first_name'),
        lastNameError: _fieldMsg(fields, 'last_name'),
        emailError: _fieldMsg(fields, 'email'),
        phoneError: _fieldMsg(fields, 'phone'),
        passwordError: _fieldMsg(fields, 'password'),
        dobError: _fieldMsg(fields, 'date_of_birth'),
        aboutError: _fieldMsg(fields, 'about_me'),
        addressError:
            _fieldMsg(fields, 'location') ?? _fieldMsg(fields, 'address'),
      );
      state = state.copyWith(step: RegistrationStep.basicInfo);
      return;
    }

    ref.emitFailure(failure);
  }

  // -------------------------
  // Optional: Resend actions (لو UI محتاجها)
  // -------------------------
  Future<void> resendPhoneOtp() async {
    if (state.isLoading) return;
    final d = state.draft;

    state = state.copyWith(isLoading: true, otpError: null);

    final repo = ref.read(registrationRepositoryProvider);
    final res = await repo.sendSmsOtp(
      phone: d.phone.trim(),
      userType: _userType,
      rentalUuid: d.rentalUuid,
    );

    state = state.copyWith(isLoading: false);

    if (res is AppSuccess<OtpSendResult>) {
      state = state.copyWith(
        draft: d.copyWith(phoneOtpUuid: res.data.uuid),
        phoneCode: '',
      );
      return;
    }

    final failure = (res as AppFailure<OtpSendResult>).failure;
    ref.emitFailure(failure);
  }



  // -------------------------
  // Location 
  // -------------------------

  Future<void> fillAddressFromCurrentLocation() async {
  if (state.isLoading) return;

  state = state.copyWith(isLoading: true, addressError: null);

  try {
    final loc = await ref.read(locationServiceProvider).getCurrentLocation();

    setAddress(
      address: loc.address,
      lat: loc.lat,
      lng: loc.lng,
    );

    state = state.copyWith(isLoading: false);
  } catch (e) {
    state = state.copyWith(
      isLoading: false,
      addressError: e.toString().replaceFirst('Exception: ', ''),
    );
  }
}

  Future<void> resendEmailOtp() async {
    if (state.isLoading) return;
    await _sendEmailOtp();
  }
}
