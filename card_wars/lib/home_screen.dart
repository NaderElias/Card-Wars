import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers/Base.dart';
import './Models/item_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database Items'),
      ),
      body: Consumer<Base>(
        builder: (context, base, _) {
          return StreamBuilder<List<Item>>(
            stream: base.mongoDBService.itemsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              List<Item> items = snapshot.data ?? [];

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index].name),
                    subtitle: Text('Image URL: ${items[index].image}'),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Base base = Provider.of<Base>(context, listen: false);
          base.mongoDBService.insertItem(Item(name: 'New Item', image: 'https://example.com/image.jpg'));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
class Base with ChangeNotifier {
  final MongoDBService mongoDBService = MongoDBService();
}
