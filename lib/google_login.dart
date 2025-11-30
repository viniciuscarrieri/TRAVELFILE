import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();

      final GoogleSignInAccount? googleUser =
          await googleSignIn.attemptLightweightAuthentication();
      if (googleUser == null) {
        // O usuário cancelou o login
        return null;
      }
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.idToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      FirebaseFirestore.instance.collection('usuarios').doc(googleUser.id).set({
        'uid': googleUser.id,
        'LoginMetodo': 'Google',
        'nome': googleUser.displayName,
        'email': googleUser.email,
        'photoUrl': googleUser.photoUrl,
        'dataCadastro': DateTime.now(),
        'status': 'ativo',
      });
      return userCredential.user;
    } catch (e) {
      print('Erro ao autenticar com o Google: $e');
      return null;
    }
  }
}
