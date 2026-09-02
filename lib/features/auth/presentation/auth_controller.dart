import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../data/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repository;

  AuthController({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _repository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<User?> signInWithGoogle() async {
    return _repository.signInWithGoogle();
  }

  Future<User?> signInWithApple() async {
    return _repository.signInWithApple();
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _repository.sendPasswordResetEmail(email: email);
  }
}
