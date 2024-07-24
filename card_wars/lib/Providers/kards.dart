import 'package:flutter/foundation.dart';
import '../models/item_model.dart';

class ItemsProvider with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items => _items;

  void setItems(List<Item> items) {
    _items = items;
    notifyListeners();
  }

  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(Item item) {
    _items.remove(item);
    notifyListeners();
  }
}
