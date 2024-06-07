import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import '../providers/Base.dart';
import '../providers/mongodb_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Call the function from provider when the page is opened
    MongoDBService mongoDBService =
        Provider.of<MongoDBService>(context, listen: false);
    // Call the fetch method directly from the MongoDBService instance
    mongoDBService.fetchop();
  }

  @override
  Widget build(BuildContext context) {
    List<Item> items = Provider.of<List<Item>>(context);
    Base base = Provider.of<Base>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Items'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          Uint8List imageBytes = base64Decode(items[index].image);
          return ListTile(
            title: Text(items[index].name),
            subtitle: Image.memory(imageBytes),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final picker = ImagePicker();
          final pickedFile =
              await picker.pickImage(source: ImageSource.gallery);

          if (pickedFile != null) {
            String base64Image =
                await base.mongoDBService.encodeImageToBase64(pickedFile.path);
            Item newItem = Item(name: 'New Name', image: base64Image);
            await base.mongoDBService.insertItem(newItem);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
