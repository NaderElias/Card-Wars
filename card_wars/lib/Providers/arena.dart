import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import 'Base.dart';
import 'mongodb_service.dart';

class ArenaProvider with ChangeNotifier {
  // Define a 5x5 list to represent the map with `Item` type
  List<List<Item?>> _map = List.generate(
    5,
    (_) => List.generate(5, (_) => null),
  );

  List<List<Item?>> get map => _map;

  void updateItem(int row, int col, Item? item) {
    _map[row][col] = item;
    notifyListeners();
  }

  void resetMap() {
    _map = List.generate(
      5,
      (_) => List.generate(5, (_) => null),
    );
    notifyListeners();
  }
}

class ArenaWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ArenaProvider>(
      builder: (context, arenaProvider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var row in arenaProvider.map)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var cell in row)
                    Container(
                      margin: EdgeInsets.all(4.0),
                      width: 60,
                      height: 90,
                      decoration: BoxDecoration(
                        color: cell == null ? Colors.grey : Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                        image: cell != null
                            ? DecorationImage(
                                image: NetworkImage(cell.image),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: cell == null
                          ? null
                          : Center(
                              child: Text(
                                cell.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  backgroundColor: Colors.white70,
                                ),
                              ),
                            ),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}
