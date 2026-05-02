import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// Verifica se o usuário atual tem a flag isPremium no Firestore
  static Future<bool> isUserPremium() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final doc = await _firestore.collection('usuarios').doc(user.uid).get();
      
      if (doc.exists && doc.data() != null) {
        return doc.data()!['isPremium'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('Erro ao verificar status premium: $e');
      return false;
    }
  }

  /// Verifica e garante que o documento do usuário atual tenha a flag isPremium configurada
  static Future<void> ensurePremiumFlagExists() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final docRef = _firestore.collection('usuarios').doc(user.uid);
      final doc = await docRef.get();

      if (doc.exists) {
        final data = doc.data()!;
        if (!data.containsKey('isPremium')) {
          await docRef.update({'isPremium': false});
        }
      } else {
        await docRef.set({
          'email': user.email,
          'isPremium': false,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('Erro ao configurar flag premium: $e');
    }
  }
}
