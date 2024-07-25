import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/item_model.dart';
import 'providers/Base.dart';
import 'providers/kards.dart';
import 'providers/arena.dart';
import 'providers/hand.dart';
import 'home_screen.dart';
import 'login.dart';
import 'board.dart';
import 'register.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Base()),
        ChangeNotifierProvider(create: (context) => ItemsProvider()),
        ChangeNotifierProvider(create: (context) => HandProvider()),
        ChangeNotifierProvider(create: (context) => ArenaProvider()),
        StreamProvider<List<Item>>(
          create: (context) => context.read<Base>().mongoDBService.itemsStream,
          initialData: const [],
        ),
      ],
      child: MaterialApp.router(
        title: 'Your App Title',
        debugShowCheckedModeBanner: false,
        routerConfig: _buildRouter(context),
      ),
    );
  }

  GoRouter _buildRouter(BuildContext context) {
    return GoRouter(
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
        GoRoute(
          path: '/arena',
          builder: (context, state) => BoardPage(),
        ),
      ],
    );
  }
}
