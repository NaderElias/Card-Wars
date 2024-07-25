import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../models/item_model.dart';
import '../models/game_model.dart';
import '../models/user_model.dart';

class MongoDBService {
  late final StreamController<List<Item>> _controller;
  final String connectionString =
      'mongodb+srv://Finn:yt8750yg@cluster0.pv838z4.mongodb.net/CardWars?retryWrites=true&w=majority';
  late Db _db;
  late DbCollection _collection;

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

  void _startListening(String col) {
    if (col == 'live') {
      Timer.periodic(Duration(seconds: 1), (_) async {
       
      });
    } else {
      
        fetchop();
      
    }
  }



  Future<String> login(String user,String password) async {
    try {
      
      final userm = await _collection.find({
        'username': user,
        'password': password,
      });
      if(userm==null){print(userm);return '404';}
      return '200';
    } catch (e) {
      print('Error inserting item: $e');
      return '500';
    }
  }
Future<void> register(User user) async {
    try {
      await _collection.insert(user.toMap());
    } catch (e) {
      print('Error inserting item: $e');
    }
  }


  Future<void> insertItem(Item item) async {
    try {
      await _collection.insert(item.toMap());
      print('Item inserted: $item');
   

  }
  catch(e){}}


  Future<void> insertGame(Game game) async {
    try {
      await _collection.insert(game.toMap());
      print('Item inserted: $game');
   

  }
  catch(e){}}
  Future<Map<String, dynamic>?> getGame(String s) async {
    try {
       final objectId = ObjectId.parse(s); // Convert the string ID to ObjectId
    return await _collection.findOne(where.id(objectId));
   

  }
  catch(e){print(e);}}

  Future<String> encodeImageToBase64(String imagePath) async {
    File imageFile = File(imagePath);
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Stream<List<Item>> get itemsStream => _controller.stream;

  void fetchop() async {
    final documents = await _collection.find().toList();
    final items = documents.map((doc) => Item.fromMap(doc)).toList();
    _controller.add(items);
  }

  void dispose() {
    _controller.close();
    _db.close();
  }
}
