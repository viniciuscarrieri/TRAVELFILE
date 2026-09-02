import 'package:firebase_auth/firebase_auth.dart';

import 'features/auth/data/auth_repository.dart';

class GoogleAuthController {
  final AuthRepository _repository = AuthRepository();

  Future<User?> signInWithGoogle() async {
    return _repository.signInWithGoogle();
  }
}
