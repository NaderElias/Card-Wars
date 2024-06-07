import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers/Base.dart';  // Make sure the path is correct
import 'Models/item_model.dart';
import 'home_screen.dart';  // Make sure the path is correct

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Item>>(
          create: (context) => MongoDBService().itemsStream,
          initialData: [],
        ),
      ],
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
