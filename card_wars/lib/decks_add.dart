import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/item_model.dart';
import 'providers/file_provider.dart';

class ItemSelectionPage extends StatefulWidget {
  @override
  _ItemSelectionPageState createState() => _ItemSelectionPageState();
}

class _ItemSelectionPageState extends State<ItemSelectionPage> {
  // A list of items to display (for demonstration purposes)
  Future<List<Item>> getAllItems() async {
    final itoms = FileProvider();
    List<Item>? items = (await itoms.readListFromFile('adamass'));
    return items;
  }

  Uint8List getImage(String x) {
    Uint8List imageBytes = base64Decode(x);
    return imageBytes;
  }

  // A Set to keep track of selected items
  final Set<Item> selectedItems = {};
  List<Item> items = [];
  int x = 0;
  List<Item>? popo() {
    Future<List<Item>?> itemso = getAllItems();
    print('before popo:$itemso');
    itemso.then((myValue) {
      // Access the properties of `myValue` here
      print('after poopo: $myValue');
      return myValue;
    }).catchError((error) {
      // Handle any errors
      print('Error: $error');
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (x == 0) {
      Future<List<Item>> itemso = getAllItems();
      print('thi is the items$items');
      itemso.then((myValue) {
        // Access the properties of `myValue` here
        print('after poopo: ${myValue[0].name}');
        //items = myValue.toList();
        setState(() {
          items = myValue;
        });
      }).catchError((error) {
        // Handle any errors
        print('Error: $error');
      });
      /* while (items.) {
      if (items != null) {
        break;
      }

    }*/
      x++;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Item Selection Page'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          childAspectRatio: 1, // Aspect ratio for each item
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = selectedItems.contains(item);

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
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child:
                        // Adjust the radius as needed
                        Image.memory(
                      getImage(item.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      size: 24.0,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
