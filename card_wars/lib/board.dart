import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/arena.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArenaProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Board Page'),
        ),
        body: Center(
          child: ArenaWidget(),
        ),
      ),
    );
  }
}
