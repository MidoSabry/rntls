import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_ui/shared_ui.dart';

import '../../controller/registration_controller.dart';
import '../../controller/registration_vm.dart';

class RegAddressScreen extends ConsumerStatefulWidget {
  const RegAddressScreen({super.key});

  @override
  ConsumerState<RegAddressScreen> createState() => _RegAddressScreenState();
}

class _RegAddressScreenState extends ConsumerState<RegAddressScreen> {
  late final TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    _addressCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 1) watch wrapper + extract vm
    final vs = ref.watch(registrationControllerProvider);
    final s = vs.dataOrNull ?? const RegistrationVM();

    final c = ref.read(registrationControllerProvider.notifier);

    // ✅ 2) loading from wrapper
    final isLoading = vs is ViewLoading<RegistrationVM>;

    // keep controller synced with state (important when GPS fills address)
    final stateAddress = s.draft.address;
    if (_addressCtrl.text != stateAddress) {
      _addressCtrl.text = stateAddress;
      _addressCtrl.selection = TextSelection.fromPosition(
        TextPosition(offset: _addressCtrl.text.length),
      );
    }

    final hasCoords = (s.draft.lat != null && s.draft.lng != null);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set your residential address',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Use your current location or type your address manually.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 14),

          SharedButton(
            label: 'Use my current location',
            onPressed: isLoading ? null : () => c.fillAddressFromCurrentLocation(),
            isLoading: isLoading,
            variant: SharedButtonVariant.filled,
            rounded: false,
            radius: 14,
            height: 48,
            fullWidth: true,
          ),

          if (hasCoords) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.my_location, size: 18, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Lat: ${s.draft.lat!.toStringAsFixed(6)}   •   Lng: ${s.draft.lng!.toStringAsFixed(6)}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 14),

          Container(
            height: 360,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE6E6E6)),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Text(
                    'MAP (TODO)',
                    style: TextStyle(color: Colors.black45),
                  ),
                ),

                Positioned(
                  left: 14,
                  right: 14,
                  top: 14,
                  child: SharedTextField(
                    label: 'Residential Address',
                    hint: 'Enter address',
                    errorText: s.addressError,
                    controller: _addressCtrl,
                    onChanged: (v) => c.setAddress(address: v),
                    prefix: const Icon(Icons.location_on_outlined),
                  ),
                ),

                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          SharedButton(
            label: 'Confirm Address',
            onPressed: isLoading ? null : () => c.next(),
            isLoading: isLoading,
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