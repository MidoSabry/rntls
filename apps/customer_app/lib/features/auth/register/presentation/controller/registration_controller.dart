import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';

import '../../../../../app/providers.dart';
import '../../../../../core/error_handler/error_extensions.dart';
import '../../domain/registration_repository.dart';
import '../../domain/registration_step.dart';
import 'registration_vm.dart';

final registrationControllerProvider =
    NotifierProvider<RegistrationController, ViewState<RegistrationVM>>(
  RegistrationController.new,
);

class RegistrationController extends Notifier<ViewState<RegistrationVM>> {
  static const _userType = 'customer';

  @override
  ViewState<RegistrationVM> build() => const ViewData(RegistrationVM());

  // -------- helpers to get/set vm safely
  RegistrationVM get _vm => state.dataOrNull ?? const RegistrationVM();

  void _setVm(RegistrationVM vm) => state = ViewData(vm);

  bool get _isLoading => state is ViewLoading<RegistrationVM>;

  void _setLoading([bool keepData = true]) {
    state = ViewLoading(data: keepData ? _vm : null);
  }

  void _emitGlobal(Failure f, {String? override}) {
    ref.emitFailure(f, messageOverride: override);
  }

  // -------------------------
  // Setters (تعدّل الـ VM)
  // -------------------------
  void setFirstName(String v) => _setVm(_vm.copyWith(
        draft: _vm.draft.copyWith(firstName: v),
        firstNameError: null,
      ));

  void setLastName(String v) => _setVm(_vm.copyWith(
        draft: _vm.draft.copyWith(lastName: v),
        lastNameError: null,
      ));

  void setEmail(String v) => _setVm(_vm.copyWith(
        draft: _vm.draft.copyWith(email: v),
        emailError: null,
      ));

  void setPhone(String v) => _setVm(_vm.copyWith(
        draft: _vm.draft.copyWith(phone: v),
        phoneError: null,
      ));

  void setDob(String v) => _setVm(_vm.copyWith(
        draft: _vm.draft.copyWith(dateOfBirth: v),
        dobError: null,
      ));

  void setAbout(String v) => _setVm(_vm.copyWith(
        draft: _vm.draft.copyWith(aboutMe: v),
        aboutError: null,
      ));

  void setPassword(String v) => _setVm(_vm.copyWith(
        draft: _vm.draft.copyWith(password: v),
        passwordError: null,
        confirmPasswordError: null,
      ));

  void setConfirmPassword(String v) =>
      _setVm(_vm.copyWith(confirmPassword: v, confirmPasswordError: null));

  void setAddress({required String address, double? lat, double? lng}) {
    _setVm(_vm.copyWith(
      draft: _vm.draft.copyWith(address: address, lat: lat, lng: lng),
      addressError: null,
    ));
  }

  void setPhoneCode(String v) => _setVm(_vm.copyWith(phoneCode: v, otpError: null));
  void setEmailCode(String v) => _setVm(_vm.copyWith(emailCode: v, otpError: null));

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

  /// Handles: String OR List<String>
  String? _firstMsg(dynamic v) {
    if (v == null) return null;
    if (v is List && v.isNotEmpty) return v.first.toString();
    return v.toString();
  }

  String? _fieldMsg(Map<String, dynamic> fields, String key) =>
      _firstMsg(fields[key]);

  // -------------------------
  // Flow actions
  // -------------------------
  void back() {
    final prev = switch (_vm.step) {
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

    _setVm(_vm.copyWith(step: prev, clearErrors: true, otpError: null));
  }

  Future<void> next() async {
    if (_isLoading) return;

    switch (_vm.step) {
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
        _setVm(_vm.copyWith(
          step: RegistrationStep.createPassword,
          clearErrors: true,
          otpError: null,
        ));
        return;

      case RegistrationStep.createPassword:
        await _submitPasswordStep();
        return;

      case RegistrationStep.address:
        await _submitAddressStep();
        return;

      case RegistrationStep.identity:
        _setVm(_vm.copyWith(step: RegistrationStep.submit, clearErrors: true));
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
    final d = _vm.draft;

    final fnErr = _req(d.firstName, 'First name is required');
    final lnErr = _req(d.lastName, 'Last name is required');
    final emErr = _validateEmail(d.email);
    final phErr = _req(d.phone, 'Phone is required');
    final dobErr = _req(d.dateOfBirth, 'Date of birth is required');

    if (fnErr != null || lnErr != null || emErr != null || phErr != null || dobErr != null) {
      _setVm(_vm.copyWith(
        firstNameError: fnErr,
        lastNameError: lnErr,
        emailError: emErr,
        phoneError: phErr,
        dobError: dobErr,
      ));
      return;
    }

    _setLoading(true);

    final repo = ref.read(registrationRepositoryProvider);
    final res = await repo.sendSmsOtp(
      phone: d.phone.trim(),
      userType: _userType,
      rentalUuid: d.rentalUuid,
    );

    if (res is AppSuccess<OtpSendResult>) {
      _setVm(_vm.copyWith(
        draft: d.copyWith(phoneOtpUuid: res.data.uuid),
        step: RegistrationStep.phoneOtp,
        clearErrors: true,
        otpError: null,
        phoneCode: '',
      ));
      return;
    }

    final failure = (res as AppFailure<OtpSendResult>).failure;

    String? override;
    if (failure is ValidationFailure && failure.fields != null) {
      override = _firstMsg(failure.fields!['phone']);
    }

    _emitGlobal(failure, override: override);

    // رجّع للحالة الطبيعية مع بقاء البيانات
    _setVm(_vm);
  }

  // -------- verify phone -> go email send screen
  Future<void> _submitPhoneOtp() async {
    final d = _vm.draft;
    final code = _vm.phoneCode.trim();

    if (code.isEmpty) {
      _setVm(_vm.copyWith(otpError: 'Enter the code'));
      return;
    }
    if (d.phoneOtpUuid == null || d.phoneOtpUuid!.isEmpty) {
      _setVm(_vm.copyWith(otpError: 'Missing verification uuid. Resend code.'));
      return;
    }

    _setLoading(true);

    final repo = ref.read(registrationRepositoryProvider);
    final res = await repo.verifyMobile(
      code: code,
      phone: d.phone.trim(),
      uuid: d.phoneOtpUuid!,
      userType: _userType,
      rentalUuid: d.rentalUuid,
    );

    if (res is AppSuccess<void>) {
      _setVm(_vm.copyWith(
        step: RegistrationStep.emailSend,
        clearErrors: true,
        otpError: null,
        emailCode: '',
      ));
      return;
    }

    final failure = (res as AppFailure<void>).failure;

    // OTP غالبًا inline
    _setVm(_vm.copyWith(otpError: failure.message));
  }

  // -------- send email otp -> go emailOtp screen
  Future<void> _sendEmailOtp() async {
    final d = _vm.draft;

    final emErr = _validateEmail(d.email);
    if (emErr != null) {
      _setVm(_vm.copyWith(emailError: emErr));
      return;
    }

    _setLoading(true);

    final repo = ref.read(registrationRepositoryProvider);
    final emailRes = await repo.sendEmailOtp(
      email: d.email.trim(),
      userType: _userType,
      rentalUuid: d.rentalUuid,
    );

    if (emailRes is AppSuccess<OtpSendResult>) {
      _setVm(_vm.copyWith(
        draft: d.copyWith(emailOtpUuid: emailRes.data.uuid),
        step: RegistrationStep.emailOtp,
        clearErrors: true,
        otpError: null,
        emailCode: '',
      ));
      return;
    }

    final failure = (emailRes as AppFailure<OtpSendResult>).failure;
    _emitGlobal(failure);
    _setVm(_vm);
  }

  // -------- verify email -> go emailVerified screen
  Future<void> _submitEmailOtp() async {
    final d = _vm.draft;
    final code = _vm.emailCode.trim();

    if (code.isEmpty) {
      _setVm(_vm.copyWith(otpError: 'Enter the code'));
      return;
    }
    if (d.emailOtpUuid == null || d.emailOtpUuid!.isEmpty) {
      _setVm(_vm.copyWith(otpError: 'Missing verification uuid. Resend code.'));
      return;
    }

    _setLoading(true);

    final repo = ref.read(registrationRepositoryProvider);
    final res = await repo.verifyEmail(
      code: code,
      email: d.email.trim(),
      uid: d.emailOtpUuid!,
      userType: _userType,
      rentalUuid: d.rentalUuid,
    );

    if (res is AppSuccess<void>) {
      _setVm(_vm.copyWith(
        step: RegistrationStep.emailVerified,
        clearErrors: true,
        otpError: null,
      ));
      return;
    }

    final failure = (res as AppFailure<void>).failure;
    _setVm(_vm.copyWith(otpError: failure.message));
  }

  // -------- password step -> address
  Future<void> _submitPasswordStep() async {
    final pass = _vm.draft.password;
    final confirm = _vm.confirmPassword;

    final pErr = _validatePassword(pass);

    String? cErr;
    if (confirm.trim().isEmpty) {
      cErr = 'Confirm password is required';
    } else if (confirm != pass) {
      cErr = 'Passwords do not match';
    }

    if (pErr != null || cErr != null) {
      _setVm(_vm.copyWith(passwordError: pErr, confirmPasswordError: cErr));
      return;
    }

    _setVm(_vm.copyWith(step: RegistrationStep.address, clearErrors: true));
  }

  // -------- address -> identity
  Future<void> _submitAddressStep() async {
    final d = _vm.draft;

    final aErr = _req(d.address, 'Address is required');
    if (aErr != null) {
      _setVm(_vm.copyWith(addressError: aErr));
      return;
    }

    _setVm(_vm.copyWith(step: RegistrationStep.identity, clearErrors: true));
  }

  // -------- register
  Future<void> _submitRegister() async {
    final d = _vm.draft;

    if (d.phoneOtpUuid == null || d.phoneOtpUuid!.isEmpty) {
      _setVm(_vm.copyWith(step: RegistrationStep.phoneOtp, otpError: 'Verify phone first'));
      return;
    }
    if (d.emailOtpUuid == null || d.emailOtpUuid!.isEmpty) {
      _setVm(_vm.copyWith(step: RegistrationStep.emailSend, otpError: 'Verify email first'));
      return;
    }

    _setLoading(true);

    final repo = ref.read(registrationRepositoryProvider);
    final res = await repo.registerCustomer(draft: d, userType: _userType);

    if (res is AppSuccess<void>) {
      _setVm(_vm.copyWith(step: RegistrationStep.done, clearErrors: true));
      return;
    }

    final failure = (res as AppFailure<void>).failure;

    // inline validation على كل الحقول
    if (failure is ValidationFailure && failure.fields != null) {
      final fields = failure.fields!;
      _setVm(_vm.copyWith(
        firstNameError: _fieldMsg(fields, 'first_name'),
        lastNameError: _fieldMsg(fields, 'last_name'),
        emailError: _fieldMsg(fields, 'email'),
        phoneError: _fieldMsg(fields, 'phone'),
        passwordError: _fieldMsg(fields, 'password'),
        dobError: _fieldMsg(fields, 'date_of_birth'),
        aboutError: _fieldMsg(fields, 'about_me'),
        addressError: _fieldMsg(fields, 'location') ?? _fieldMsg(fields, 'address'),
        step: RegistrationStep.basicInfo,
      ));
      return;
    }

    _emitGlobal(failure);
    _setVm(_vm);
  }

  // -------------------------
  // Optional: resend actions
  // -------------------------
  Future<void> resendPhoneOtp() async {
    if (_isLoading) return;

    final d = _vm.draft;
    _setLoading(true);

    final repo = ref.read(registrationRepositoryProvider);
    final res = await repo.sendSmsOtp(
      phone: d.phone.trim(),
      userType: _userType,
      rentalUuid: d.rentalUuid,
    );

    if (res is AppSuccess<OtpSendResult>) {
      _setVm(_vm.copyWith(
        draft: d.copyWith(phoneOtpUuid: res.data.uuid),
        phoneCode: '',
        otpError: null,
      ));
      return;
    }

    final failure = (res as AppFailure<OtpSendResult>).failure;
    _emitGlobal(failure);
    _setVm(_vm);
  }

  Future<void> resendEmailOtp() async {
    if (_isLoading) return;
    await _sendEmailOtp();
  }

  // -------------------------
  // Location
  // -------------------------
  Future<void> fillAddressFromCurrentLocation() async {
    if (_isLoading) return;

    _setLoading(true);

    try {
      final loc = await ref.read(locationServiceProvider).getCurrentLocation();
      setAddress(address: loc.address, lat: loc.lat, lng: loc.lng);
      _setVm(_vm.copyWith(addressError: null));
    } catch (e) {
      _setVm(_vm.copyWith(
        addressError: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}