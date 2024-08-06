import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

import 'package:card_wars/models/item_model.dart';

class FileProvider with ChangeNotifier {
  Future<String> getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> saveListToFile(List<Item> list, String fileName) async {
    try {
      final path = await getFilePath();
      final file = File('$path/$fileName');

      // Convert the list of items to a list of maps and handle DateTime conversion to string
      List<Map<String, dynamic>> jsonList = list.map((item) {
        final map = item.toMap();
        map['date'] = item.date.toIso8601String(); // Ensure DateTime is converted to string
        return map;
      }).toList();
      
      String jsonString = jsonEncode(jsonList);
      await file.writeAsString(jsonString);
      notifyListeners();
    } catch (e) {
      print("Error saving file: $e");
    }
  }

  Future<List<Item>> readListFromFile(String fileName) async {
    try {
      final path = await getFilePath();
      final file = File('$path/$fileName');
      String jsonString = await file.readAsString();
      
      // Decode JSON and handle DateTime conversion from string
      List<dynamic> jsonList = jsonDecode(jsonString);
      List<Item> list = jsonList.map((json) {
        final map = Map<String, dynamic>.from(json);
        if (map.containsKey('date')) {
          map['date'] = DateTime.parse(map['date']); // Convert string to DateTime
        }
        return Item.fromMap(map);
      }).toList();
      
      return list;
    } catch (e) {
      print("Error reading file: $e");
      return [];
    }
  }

  Future<void> addEntriesToFile(List<Item> newItems, String fileName) async {
    try {
      final path = await getFilePath();
      final file = File('$path/$fileName');

      List<Item> existingItems = await readListFromFile(fileName);
      existingItems.addAll(newItems);

      // Convert the updated list of items to a list of maps and handle DateTime conversion to string
      List<Map<String, dynamic>> jsonList = existingItems.map((item) {
        final map = item.toMap();
        map['date'] = item.date.toIso8601String(); // Ensure DateTime is converted to string
        return map;
      }).toList();

      String jsonString = jsonEncode(jsonList);
      await file.writeAsString(jsonString);
      notifyListeners();
    } catch (e) {
      print("Error adding entries to file: $e");
    }
  }
}
