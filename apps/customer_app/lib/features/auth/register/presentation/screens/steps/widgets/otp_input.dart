import 'package:flutter/material.dart';

class OtpInput extends StatefulWidget {
  final int length;
  final String value;
  final ValueChanged<String> onChanged;

  const OtpInput({
    super.key,
    this.length = 4,
    required this.value,
    required this.onChanged,
  });

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> _cts;
  late final List<FocusNode> _fns;

  @override
  void initState() {
    super.initState();
    _cts = List.generate(widget.length, (_) => TextEditingController());
    _fns = List.generate(widget.length, (_) => FocusNode());
    _syncFromValue(widget.value);
  }

  @override
  void didUpdateWidget(covariant OtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _syncFromValue(widget.value);
  }

  void _syncFromValue(String v) {
    final chars = v.split('');
    for (int i = 0; i < widget.length; i++) {
      _cts[i].text = i < chars.length ? chars[i] : '';
    }
  }

  void _emit() {
    final v = _cts.map((c) => c.text).join();
    widget.onChanged(v);
  }

  @override
  void dispose() {
    for (final c in _cts) c.dispose();
    for (final f in _fns) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (i) {
        return Container(
          width: 58,
          margin: EdgeInsets.only(right: i == widget.length - 1 ? 0 : 10),
          child: TextField(
            controller: _cts[i],
            focusNode: _fns[i],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E2E2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFD8B24C), width: 2),
              ),
            ),
            onChanged: (v) {
              if (v.isNotEmpty && i < widget.length - 1) {
                _fns[i + 1].requestFocus();
              }
              if (v.isEmpty && i > 0) {
                _fns[i - 1].requestFocus();
              }
              _emit();
            },
          ),
        );
      }),
    );
  }
}