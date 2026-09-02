import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'user_repository.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final UserRepository userRepository;
  final GoogleSignIn googleSignIn;

  AuthRepository({
    FirebaseAuth? auth,
    UserRepository? userRepository,
    GoogleSignIn? googleSignIn,
  })  : auth = auth ?? FirebaseAuth.instance,
        userRepository = userRepository ?? UserRepository(),
        googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<User?> signInWithGoogle() async {
    try {
      await googleSignIn.initialize();

      final googleUser = await googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.idToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await userRepository.synchronizeUser(
          user: user,
          loginMethod: 'Google',
          name: googleUser.displayName,
          photoUrl: googleUser.photoUrl,
          email: googleUser.email,
        );
      }

      return user;
    } catch (_) {
      return null;
    }
  }

  Future<User?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final name = [appleCredential.givenName, appleCredential.familyName]
            .whereType<String>()
            .join(' ')
            .trim();

        await userRepository.synchronizeUser(
          user: user,
          loginMethod: 'Apple',
          name: name.isEmpty ? user.displayName : name,
          email: user.email ?? appleCredential.email,
        );
      }

      return user;
    } catch (_) {
      return null;
    }
  }

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
