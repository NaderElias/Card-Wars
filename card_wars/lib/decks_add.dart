import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/file_provider.dart';
import 'models/item_model.dart';


// ItemSelectionPage with image buttons and checkmark overlay
class ItemSelectionPage extends StatefulWidget {
  @override
  _ItemSelectionPageState createState() => _ItemSelectionPageState();
}

class _ItemSelectionPageState extends State<ItemSelectionPage> {
  // A Set to keep track of selected items
  final Set<Item> selectedItems = {};

  Future<List<Item>> getAllItems() async {
    final cards = Provider.of<FileProvider>(context, listen: false);
    final items = await cards.readListFromFile('adamass');
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Selection Page'),
      ),
      body: FutureBuilder<List<Item>>(
        future: getAllItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found'));
          } else {
            final items = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid
                childAspectRatio: 1, // Aspect ratio for each item
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedItems.contains(item);

                // Decode the base64 image
                Uint8List imageBytes = base64Decode(item.image);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedItems.remove(item);
                      } else {
                        selectedItems.add(item);
                      }
                    });
                  },
                  child: Stack(
                    children: [
                      // Display the image as a button
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.memory(
                          imageBytes,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      // Overlay for selected state
                      if (isSelected)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      // Checkmark icon
                      if (isSelected)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 24.0,
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
