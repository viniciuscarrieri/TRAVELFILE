import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:travelfile/app_widget.dart';
import 'package:travelfile/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  runApp(AppWidget());
}
