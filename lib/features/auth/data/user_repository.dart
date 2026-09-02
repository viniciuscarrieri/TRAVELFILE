import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore firestore;

  UserRepository({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserModel?> getCurrentUserModel(User? user) async {
    if (user == null) return null;

    final snapshot = await firestore.collection('usuarios').doc(user.uid).get();
    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return UserModel.fromFirestore(snapshot.data()!, user.uid);
  }

  Future<void> synchronizeUser({
    required User user,
    required String loginMethod,
    String? name,
    String? photoUrl,
    String? email,
  }) async {
    final data = {
      'uid': user.uid,
      'LoginMetodo': loginMethod,
      'nome': name ?? user.displayName,
      'email': email ?? user.email,
      'photoUrl': photoUrl ?? user.photoURL,
      'dataCadastro': FieldValue.serverTimestamp(),
      'status': 'ativo',
      'isPremium': false,
    };

    await firestore.collection('usuarios').doc(user.uid).set(data, SetOptions(merge: true));
  }

  Future<bool> isPremium(User? user) async {
    if (user == null) return false;

    try {
      final doc = await firestore.collection('usuarios').doc(user.uid).get();
      if (!doc.exists || doc.data() == null) {
        return false;
      }

      return doc.data()!['isPremium'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> ensurePremiumFlagExists(User? user) async {
    if (user == null) return;

    final docRef = firestore.collection('usuarios').doc(user.uid);
    final doc = await docRef.get();

    if (doc.exists) {
      final data = doc.data() ?? {};
      if (!data.containsKey('isPremium')) {
        await docRef.update({'isPremium': false});
      }
      return;
    }

    await docRef.set({
      'email': user.email,
      'isPremium': false,
    }, SetOptions(merge: true));
  }
}
