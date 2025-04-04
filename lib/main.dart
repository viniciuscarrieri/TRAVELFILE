import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:travelfile/app_widget.dart';
import 'package:travelfile/firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(AppWidget());
}
