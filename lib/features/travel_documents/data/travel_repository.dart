import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/models/travel_item_model.dart';

class TravelRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  TravelRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  Future<List<TravelItemModel>> getUserTravelItems() async {
    final user = auth.currentUser;
    if (user == null) return const [];

    final snapshot = await firestore
        .collection('usuarios')
        .doc(user.uid)
        .collection('travel_items')
        .get();

    return snapshot.docs
        .map((doc) => TravelItemModel.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<void> saveItem(TravelItemModel item) async {
    final user = auth.currentUser;
    if (user == null) return;

    await firestore
        .collection('usuarios')
        .doc(user.uid)
        .collection('travel_items')
        .doc(item.id)
        .set(item.toMap(), SetOptions(merge: true));
  }

  Future<void> deleteItem(String itemId) async {
    final user = auth.currentUser;
    if (user == null) return;

    await firestore
        .collection('usuarios')
        .doc(user.uid)
        .collection('travel_items')
        .doc(itemId)
        .delete();
  }
}
