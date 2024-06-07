import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/item_model.dart';
import 'providers/Base.dart';
import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Base()),
        StreamProvider<List<Item>>(
          create: (context) => context.read<Base>().mongoDBService.itemsStream,
          initialData: [],
        ),
      ],
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
