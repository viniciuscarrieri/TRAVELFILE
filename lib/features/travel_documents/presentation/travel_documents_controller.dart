import 'package:flutter/foundation.dart';

import '../data/travel_repository.dart';
import '../domain/models/travel_item_model.dart';

class TravelDocumentsController extends ChangeNotifier {
  final TravelRepository _repository;

  TravelDocumentsController({TravelRepository? repository})
      : _repository = repository ?? TravelRepository();

  bool isLoading = false;
  List<TravelItemModel> items = const [];

  Future<void> loadItems() async {
    isLoading = true;
    notifyListeners();

    try {
      items = await _repository.getUserTravelItems();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveItem(TravelItemModel item) async {
    await _repository.saveItem(item);
    final index = items.indexWhere((existing) => existing.id == item.id);

    if (index >= 0) {
      items[index] = item;
    } else {
      items = [...items, item];
    }

    notifyListeners();
  }

  Future<void> deleteItem(String itemId) async {
    await _repository.deleteItem(itemId);
    items = items.where((item) => item.id != itemId).toList();
    notifyListeners();
  }
}
