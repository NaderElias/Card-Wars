import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import '../models/game_model.dart';
import '../models/user_model.dart';
import '../providers/file_provider.dart';
import '../providers/Base.dart';
import 'package:crypto/crypto.dart'; // For hashing passwords
import 'package:uuid/uuid.dart'; // For generating tokens
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MongoDBService {
  late final StreamController<List<Item>> _controller;
  final storage = FlutterSecureStorage();
  final String connectionString =
      'mongodb+srv://Finn:yt8750yg@cluster0.pv838z4.mongodb.net/CardWars?retryWrites=true&w=majority';
  late Db _db;
  late DbCollection _collection;
  final _loadingController = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get isLoading => _loadingController.stream;
  DbCollection get collection => _collection;

  MongoDBService(String col) {
    _controller = StreamController<List<Item>>();
    _init(col);
  }

  Future<void> _init(String col) async {
    _db = await Db.create(connectionString);
    await _db.open();
    _collection = _db.collection(col);
    _startListening(col);
  }

  Future<DbCollection> _connect(String col) async {
    //Db db = await Db.create(connectionString);
    await _db.open();
    DbCollection collet = _db.collection(col);
    return collet;
  }

  void _startListening(String col) {
    if (col == 'live') {
      Timer.periodic(Duration(seconds: 1), (_) async {});
    } else {
      fetchop();
    }
  }

  Future<String> login(String username, String password) async {
    try {
      // Find the user by username and password
      final user = await _collection.findOne({
        'email': username,
        'password':
            md5.convert(utf8.encode(password)).toString(), // Hash the password
      });

      if (user == null) {
        return '404'; // User not found
      }

      // Generate a token
      final token = Uuid().v4();
      var usero = await _collection.update(
          where.id(user['_id']),
          modify
              .set('token', token)
              .set('tokenCreation', DateTime.now().toIso8601String()));
      storeToken(token);
      storeCookie(user);
      return '200'; // Return the generated token
    } catch (e) {
      print('Error logging in: $e');
      return '500'; // Internal Server Error
    }
  }

  Future<void> register(User user) async {
    try {
      // Hash the password before storing
      user.password = md5.convert(utf8.encode(user.password)).toString();
      await _collection.insert(user.toMap());
    } catch (e) {
      print('Error registering user: $e');
    }
  }

  Future<void> insertItem(Item item) async {
    try {
      await _collection.insert(item.toMap());
      print('Item inserted: $item');
    } catch (e) {}
  }

  Future<bool> validateToken(String token) async {
    try {
      final user = await _collection.findOne({'token': token});
      return user != null;
    } catch (e) {
      print('Error validating token: $e');
      return false;
    }
  }

  Future<void> insertGame(Game game) async {
    try {
      await _collection.insert(game.toMap());
      print('Item inserted: $game');
    } catch (e) {}
  }

  Future<void> storeToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }

  Future<void> storeCookie(Map<String, dynamic>? cookie) async {
    if (cookie != null) {
      String jsonString = jsonEncode(cookie); // Convert map to JSON string
      await storage.write(key: 'cookie', value: jsonString);
    } else {
      await storage.delete(
          key: 'cookie'); // Optionally delete if cookie is null
    }
  }

  Future<Map<String, dynamic>?> readCookie() async {
    String? jsonString = await storage.read(key: 'cookie');
    if (jsonString != null) {
      return jsonDecode(jsonString); // Convert JSON string back to Map
    } else {
      return null; // No cookie found
    }
  }

  Future<bool> isSessionValid(String token) async {
    try {
      final user = await _collection.findOne({'token': token});
      if (user == null) return false;

      // Get the token creation time and check if it has expired
      DateTime tokenCreation = user['tokenCreation'].toDate();
      final expirationDuration =
          Duration(seconds: 30); // Session timeout duration
      return DateTime.now().difference(tokenCreation) < expirationDuration;
    } catch (e) {
      print('Error checking session validity: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getGame(String s) async {
    try {
      final objectId = ObjectId.parse(s); // Convert the string ID to ObjectId
      return await _collection.findOne(where.id(objectId));
    } catch (e) {
      print(e);
    }
  }

  Future<String> encodeImageToBase64(String imagePath) async {
    File imageFile = File(imagePath);
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Stream<List<Item>> get itemsStream => _controller.stream;

  void fetchop() async {
    
    try {
      _loadingController.add(true); // Start loading
    var filo = FileProvider();
    List<Item>? adam = (await filo.readListFromFile('adamass'));
    if (adam.isEmpty) {
      List<Item> items = await mongoAll();
      if (items.isNotEmpty) {
        await filo.saveListToFile(items, 'adamass');
      }
      List<Item>? odam = (await filo.readListFromFile('adamass'));
      _controller.add(odam);
    } else {
      var x = adam.reduce(
          (current, next) => current.date.isAfter(next.date) ? current : next);
      final documents =
          await _collection.find(where.gte('date', x.date)).toList();
      final itemsll = documents.map((doc) => Item.fromMap(doc)).toList();
      print('hello$itemsll');
      if(itemsll.isNotEmpty){filo.addEntriesToFile(itemsll, 'adamass');}
      
      List<Item>? opop = (await filo.readListFromFile('adamass'));
      _controller.add(opop);
      
    }
      
    } catch (e) {
      // Handle error
      print(e);
    } finally {
      _loadingController.add(false); // End loading
    }
  }

  Future<List<Item>> mongoAll() async {
    try {
      final documents = await _collection.find().toList();
      final items = documents.map((doc) => Item.fromMap(doc)).toList();
      return items;
    } catch (e) {
      print(e);
      List<Item> itemso = [];
      return itemso;
    }
  }

  void dispose() {
    _loadingController.close();
    _controller.close();
    _db.close();
  }
}
