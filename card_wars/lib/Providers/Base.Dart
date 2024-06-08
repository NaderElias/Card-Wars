import 'package:flutter/material.dart';
import './mongodb_service.dart';

class Base with ChangeNotifier {
  late MongoDBService _mongoDBService;
  MongoDBService get mongoDBService => _mongoDBService;

  void initialize(String col) {
    _mongoDBService = MongoDBService(col);
    notifyListeners();
  }
}
