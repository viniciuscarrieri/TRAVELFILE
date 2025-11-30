import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:travelfile/app_widget.dart';
import 'package:travelfile/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    providerWeb: ReCaptchaV3Provider(
      '6Lfq2v0lAAAAAEE1Xk4g7q5x8r9a1j4nqz0e2f8g',
    ),
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  runApp(AppWidget());
}
