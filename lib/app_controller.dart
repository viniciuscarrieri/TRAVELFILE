import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  static AppController instance = AppController();

  bool isDarkTheme = false;

  // ignore: strict_top_level_inference
  changeTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }

  // ignore: strict_top_level_inference
  nomeusuario(String? nomeusuario) async {
    nomeusuario = nomeusuario;
    notifyListeners();
  }
}
