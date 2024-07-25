import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/arena.dart';
import '../providers/hand.dart';
class BoardPage extends StatelessWidget {
  const BoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ArenaProvider()),
        ChangeNotifierProvider(create: (context) => HandProvider()), // Add ItemsProvider
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Board Page'),
        ),
        body: Stack(
          children: [
            Center(
              child: ArenaWidget(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: HandWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}