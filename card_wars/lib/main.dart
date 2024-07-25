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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final base = Base();

  final storage = FlutterSecureStorage();
  var cookies = base.mongoDBService.readCookie();
  bool flag = false;
  if (cookies == null) {
    flag = false;
  } else {
    flag = true;
  }
  //base.initialize('user');
  //final prefs = await SharedPreferences.getInstance();
  //String? token = prefs.getString('auth_token');

  //var isValid = await base.mongoDBService.isSessionValid(token!);
  runApp(MyApp(flag));
}

class MyApp extends StatelessWidget {
  final isValid;
  const MyApp(this.isValid, {super.key});

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
          redirect: (context, state) async {
            if (isValid == null) {
              return '/';
            }
            if (isValid) {
              return '/cards';
            }
            // Redirect to login if token is not valid
            return null; // Continue to the HomeScreen
          },
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
