import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import '../providers/Base.dart';
import '../providers/mongodb_service.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Use the provider instance of Base
    final base = Provider.of<Base>(context, listen: false);
    base.initialize('Cards');
    base.mongoDBService.fetchop();
  }

  @override
  Widget build(BuildContext context) {
    final base = Provider.of<Base>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Items'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.go('/arena');
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Item>>(
        stream: base.mongoDBService.itemsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items available'));
          } else {
            List<Item> items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                Uint8List imageBytes = base64Decode(items[index].image);
                return ListTile(
                  title: Text(items[index].name),
                  subtitle: Image.memory(imageBytes),
                );
              },
            );
          }
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
          base.mongoDBService.fetchop();
        },
        child: const Icon(Icons.add),
      ),
      
    );
  }
}
