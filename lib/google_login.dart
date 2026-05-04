import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final dynamic googleSignIn = GoogleSignIn.instance;

  signInWithGoogle() async {
    try {
      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

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
        'isPremium': false,
      });
      return userCredential.user;
    } catch (e) {
      print('Erro ao autenticar com o Google: $e');
      return null;
    }
  }
}
