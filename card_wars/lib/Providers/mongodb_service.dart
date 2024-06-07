import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import '../models/item_model.dart';

class MongoDBService {
  final _controller = StreamController<List<Item>>();
  final String connectionString = 'mongodb+srv://Finn:yt8750yg@cluster0.pv838z4.mongodb.net/CardWars?retryWrites=true&w=majority';
  late Db _db;
  late DbCollection _collection;

  MongoDBService() {
    _init();
    void fetchop() async {
  final documents = await _collection.find().toList();
      final items = documents.map((doc) => Item.fromMap(doc)).toList();
      _controller.add(items);}
  }

  Future<void> _init() async {
    _db = await Db.create(connectionString);
    await _db.open();
    _collection = _db.collection('Cards');
    _startListening();
  }

  void _startListening() {
    Timer.periodic(Duration(seconds: 360), (_) async {
      fetchop();
    });
  }

  Future<void> insertItem(Item item) async {
    try {
      await _collection.insert(item.toMap());
      print('Item inserted: $item');
    } catch (e) {
      print('Error inserting item: $e');
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
  final documents = await _collection.find().toList();
      final items = documents.map((doc) => Item.fromMap(doc)).toList();
      _controller.add(items);}
  void dispose() {
    _controller.close();
    _db.close();
  }
}
