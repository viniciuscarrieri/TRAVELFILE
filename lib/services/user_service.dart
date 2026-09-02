import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../features/auth/data/user_repository.dart';

class UserService {
  static final _auth = FirebaseAuth.instance;
  static final _repository = UserRepository();

  /// Verifica se o usuário atual tem a flag isPremium no Firestore
  static Future<bool> isUserPremium() async {
    try {
      final user = _auth.currentUser;
      return _repository.isPremium(user);
    } catch (e) {
      debugPrint('Erro ao verificar status premium: $e');
      return false;
    }
  }

  /// Verifica e garante que o documento do usuário atual tenha a flag isPremium configurada
  static Future<void> ensurePremiumFlagExists() async {
    try {
      final user = _auth.currentUser;
      await _repository.ensurePremiumFlagExists(user);
    } catch (e) {
      debugPrint('Erro ao configurar flag premium: $e');
    }
  }
}
