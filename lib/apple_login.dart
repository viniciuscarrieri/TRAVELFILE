import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      final AuthCredential credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Sincronizar com Firestore
        await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).set({
          'uid': user.uid,
          'LoginMetodo': 'Apple',
          'nome': user.displayName ?? '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim(),
          'email': user.email ?? appleCredential.email,
          'dataCadastro': FieldValue.serverTimestamp(),
          'status': 'ativo',
          'isPremium': false,
        }, SetOptions(merge: true));
      }

      return user;
    } catch (e) {
      print('Erro ao autenticar com a Apple: $e');
      return null;
    }
  }
}
