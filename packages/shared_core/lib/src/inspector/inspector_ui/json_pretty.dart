import 'dart:convert';

String prettyJson(dynamic obj) {
  try {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(obj);
  } catch (_) {
    return obj?.toString() ?? '';
  }
}
