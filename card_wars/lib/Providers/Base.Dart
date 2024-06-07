import 'dart:async';
import 'package:card_wars/Models/item_model.dart';
import 'package:card_wars/Models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../Models/item_model.dart';

class MongoDBService {
  final _controller = StreamController<List<Item>>.broadcast();
  final String connectionString = 'mongodb+srv://Finn:yt8750yg@cluster0.pv838z4.mongodb.net/CardWars?retryWrites=true&w=majority';
  late Db _db;
  late DbCollection _collection;

  MongoDBService() {
    _init();
  }

  Future<void> _init() async {
    try {
      _db = await Db.create(connectionString);
      await _db.open();
      print('Database connected');
      _collection = _db.collection('Cards');
      _startListening();
    } catch (e) {
      print('Error connecting to the database: $e');
    }
  }

  void _startListening() {
    // Simulate listening for real-time updates
    Timer.periodic(Duration(seconds: 1), (_) async {
      try {
        final documents = await _collection.find().toList();
        final items = documents.map((doc) => Item.fromMap(doc)).toList();
  
   

    Future<void> insertItem(Item item) async {
    try {
      await _collection.insert(item.toMap());
      print('Item inserted: $item');
    } catch (e) {
      print('Error inserting item: $e');
    }
  };
      }
      catch(e){      print('Error inserting item: $e');
}
    });
  }

  Stream<List<Item>> get itemsStream => _controller.stream;



  void dispose() {
    _controller.close();
    _db.close();
  }
}


