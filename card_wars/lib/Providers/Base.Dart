import 'package:flutter/material.dart';
import './mongodb_service.dart';

class Base with ChangeNotifier {
  final MongoDBService mongoDBService = MongoDBService();
}
