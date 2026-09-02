import 'package:firebase_auth/firebase_auth.dart';

import 'features/auth/data/auth_repository.dart';

class AppleAuthController {
  final AuthRepository _repository = AuthRepository();

  Future<User?> signInWithApple() async {
    return _repository.signInWithApple();
  }
}
