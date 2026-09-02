import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? name;
  final String? photoUrl;
  final bool isPremium;
  final String loginMethod;
  final DateTime? createdAt;

  const UserModel({
    required this.uid,
    this.email,
    this.name,
    this.photoUrl,
    required this.isPremium,
    required this.loginMethod,
    this.createdAt,
  });

  factory UserModel.fromFirestore(
    Map<String, dynamic> data,
    String uid, {
    String loginMethod = 'Email',
  }) {
    final createdAtValue = data['dataCadastro'];

    return UserModel(
      uid: uid,
      email: data['email'] as String?,
      name: data['nome'] as String?,
      photoUrl: data['photoUrl'] as String?,
      isPremium: data['isPremium'] == true,
      loginMethod: loginMethod,
      createdAt: createdAtValue is Timestamp
          ? createdAtValue.toDate()
          : createdAtValue is DateTime
              ? createdAtValue
              : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'nome': name,
      'photoUrl': photoUrl,
      'isPremium': isPremium,
      'loginMethod': loginMethod,
      'dataCadastro': createdAt ?? DateTime.now(),
    };
  }
}
