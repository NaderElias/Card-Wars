import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/item_model.dart';  // Make sure the path is correct

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Item> items = Provider.of<List<Item>>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Database Items'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index].name),
            subtitle: Text(items[index].image),
          );
        },
      ),
    );
  }
}
