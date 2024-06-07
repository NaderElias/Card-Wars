import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Providers/Base.dart';
import './home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Base()),
      ],
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
