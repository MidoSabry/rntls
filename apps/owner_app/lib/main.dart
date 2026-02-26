import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owner_app/app/app.dart';
import 'package:owner_app/app/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ load env قبل أي Provider يقرأ dotenv
  await dotenv.load(fileName: "api_end_points.env");

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
      child: const CustomerApp(),
    ),
  );
}
