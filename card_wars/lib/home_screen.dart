import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/item_model.dart';
import '../providers/Base.dart';
import '../providers/kards.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  // State to determine if we are showing buttons or content
  bool _showingContent = false;
  Widget _drawerContent = Container(); // Placeholder for content widget

  @override
  void initState() {
    super.initState();
    final base = Provider.of<Base>(context, listen: false);
    base.initialize('Cards');
    base.mongoDBService.fetchop();
  }

  void _showDrawerContent(Widget content) {
    setState(() {
      _showingContent = true;
      _drawerContent = content;
    });
  }

  void _showDrawerButtons() {
    setState(() {
      _showingContent = false;
      _drawerContent = _buildDrawerButtons();
    });
  }

  Widget _buildDrawerButtons() {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          title: Text('Option 1'),
          onTap: () => _showDrawerContent(_buildContent('Content for Option 1')),
        ),
        ListTile(
          title: Text('Option 2'),
          onTap: () => _showDrawerContent(_buildContent('Content for Option 2')),
        ),
        ListTile(
          title: Text('Option 3'),
          onTap: () => _showDrawerContent(_buildContent('Content for Option 3')),
        ),
        // Add more options as needed
      ],
    );
  }

  Widget _buildContent(String contentText) {
   // final prefs = await SharedPreferences.getInstance();
    return Column(
      children: [
        AppBar(
          title: Text('Content View'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _showDrawerButtons,
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              contentText,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final base = Provider.of<Base>(context);
    final itemsProvider = Provider.of<ItemsProvider>(context);

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
      drawer: Drawer(
        child: _showingContent ? _drawerContent : _buildDrawerButtons(),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: StreamBuilder<List<Item>>(
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
                  itemsProvider.setItems(items);

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
          ),
          
        ],
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
            base.mongoDBService.fetchop();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}