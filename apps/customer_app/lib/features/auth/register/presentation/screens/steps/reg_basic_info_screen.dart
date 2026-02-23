import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_ui/shared_ui.dart';

import '../../controller/registration_controller.dart';
import '../../controller/registration_state.dart';

class RegBasicInfoScreen extends ConsumerStatefulWidget {
  const RegBasicInfoScreen({super.key});

  @override
  ConsumerState<RegBasicInfoScreen> createState() => _RegBasicInfoScreenState();
}

class _RegBasicInfoScreenState extends ConsumerState<RegBasicInfoScreen> {
  late final TextEditingController _dobCtrl;

  @override
  void initState() {
    super.initState();
    _dobCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _dobCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDob(WidgetRef ref) async {
    FocusManager.instance.primaryFocus?.unfocus();

    final s = ref.read(registrationControllerProvider);

    DateTime? initial;
    // لو عندك dob مخزن كنص MM/DD/YYYY نحاول نفهمه
    try {
      if (s.draft.dateOfBirth.trim().isNotEmpty) {
        initial = DateFormat('MM/dd/yyyy').parseStrict(s.draft.dateOfBirth);
      }
    } catch (_) {}

    initial ??= DateTime(DateTime.now().year - 25, 1, 1);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
      helpText: 'Select date of birth',
    );

    if (picked == null) return;

    final formatted = DateFormat('MM/dd/yyyy').format(picked);

    // update controller text
    _dobCtrl.text = formatted;

    // update state
    ref.read(registrationControllerProvider.notifier).setDob(formatted);
  }

  @override
  Widget build(BuildContext context) {
    final RegistrationState s = ref.watch(registrationControllerProvider);
    final c = ref.read(registrationControllerProvider.notifier);

    // keep controller synced (بدون setState)
    if (_dobCtrl.text != s.draft.dateOfBirth) {
      _dobCtrl.text = s.draft.dateOfBirth;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: SharedTextField(
                  label: 'First Name',
                  hint: 'John',
                  errorText: s.firstNameError,
                  onChanged: c.setFirstName,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SharedTextField(
                  label: 'Last Name',
                  hint: 'Doe',
                  errorText: s.lastNameError,
                  onChanged: c.setLastName,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          SharedTextField(
            label: 'Email',
            hint: 'rntls@gmail.com',
            keyboardType: TextInputType.emailAddress,
            prefix: const Icon(Icons.email_outlined),
            errorText: s.emailError,
            onChanged: c.setEmail,
          ),

          const SizedBox(height: 14),

          SharedTextField(
            label: 'Phone number',
            hint: '+1 (555) 000-0000',
            keyboardType: TextInputType.phone,
            prefix: const Icon(Icons.phone_outlined),
            errorText: s.phoneError,
            onChanged: c.setPhone,
          ),

          const SizedBox(height: 14),

          // ✅ DatePicker Field
          SharedTextField(
            label: 'Date of birth',
            hint: 'MM/DD/YYYY',
            prefix: const Icon(Icons.calendar_month_outlined),
            errorText: s.dobError,

            // أهم 3 سطور:
            controller: _dobCtrl,
            readOnly: true,
            onTap: () => _pickDob(ref),
          ),

          const SizedBox(height: 14),

          SharedTextField(
            label: 'About me',
            hint: 'Tell us about you...',
            errorText: s.aboutError,
            onChanged: c.setAbout,
            maxLines: 4,
          ),

          const SizedBox(height: 18),

          SharedButton(
            label: 'Continue',
            onPressed: s.isLoading ? null : () => c.next(),
            isLoading: s.isLoading,
            variant: SharedButtonVariant.filled,
            rounded: false,
            radius: 14,
            height: 52,
          ),
        ],
      ),
    );
  }
}
