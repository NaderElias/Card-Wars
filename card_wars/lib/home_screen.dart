import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/item_model.dart';
import 'providers/Base.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Item> items = Provider.of<List<Item>>(context);
    Base base = Provider.of<Base>(context, listen: false);

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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Item newItem = Item(name: 'New Name', image: 'New Image');
          await base.mongoDBService.insertItem(newItem);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
