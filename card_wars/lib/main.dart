import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/item_model.dart';
import 'providers/Base.dart';
import 'home_screen.dart';
import 'login.dart';
import 'register.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterPage(),
      ),
      GoRoute(
        path: '/cards',
        builder: (context, state) => HomeScreen(),
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Base()),
        StreamProvider<List<Item>>(
          create: (context) => context.read<Base>().mongoDBService.itemsStream,
          initialData: const [],
        ),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
