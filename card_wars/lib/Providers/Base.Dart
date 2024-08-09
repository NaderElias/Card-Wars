import 'package:flutter/material.dart';
import './mongodb_service.dart';

class Base with ChangeNotifier {
   MongoDBService _mongoDBService=MongoDBService('');

  MongoDBService get mongoDBService => _mongoDBService;

 void initialize(String col)  {
    _mongoDBService =  MongoDBService(col);
    notifyListeners();
    
  }
}
