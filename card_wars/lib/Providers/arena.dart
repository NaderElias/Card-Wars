import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import 'Base.dart';
import 'mongodb_service.dart';
import '../providers/kards.dart';

class ArenaProvider with ChangeNotifier {
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

  Item? getItem(int row, int col) {
    return _map[row][col];
  }
}

class ArenaWidget extends StatelessWidget {
  Item? onItemClicked = null;

  ArenaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final itemsProvider = Provider.of<ItemsProvider>(context);
     final arenaProvider = Provider.of<ArenaProvider>(context);

int rows = arenaProvider._map .length;
int cols = arenaProvider._map [0].length;

int itemIndex = 0;
for (int row = 0; row < rows; row++) {
  for (int col = 0; col < cols; col++) {
    if (itemIndex < itemsProvider.items.length) {
      arenaProvider._map[row][col] = itemsProvider.items[itemIndex];
      itemIndex++;
    } else {
      // Optional: handle if items are exhausted
      arenaProvider._map[row][col] = null; // Default value, change as needed
    }
  }
}






    return Consumer<ArenaProvider>(
      builder: (context, arenaProvider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var rowIndex = 0;
                rowIndex < arenaProvider.map.length;
                rowIndex++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var colIndex = 0;
                      colIndex < arenaProvider.map[rowIndex].length;
                      colIndex++)
                    GestureDetector(
                      onTap: () => _onCellTap(context, rowIndex, colIndex),
                      child: Container(
                        margin: EdgeInsets.all(4.0),
                        width: 60,
                        height: 90,
                        decoration: BoxDecoration(
                          color: arenaProvider.map[rowIndex][colIndex] == null
                              ? Colors.grey
                              : Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                          image: arenaProvider.map[rowIndex][colIndex] != null
                              ? DecorationImage(
                                  image: NetworkImage(arenaProvider
                                      .map[rowIndex][colIndex]!.image),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: arenaProvider.map[rowIndex][colIndex] == null
                            ? null
                            : Center(
                                child: Text(
                                  arenaProvider.map[rowIndex][colIndex]!.name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    backgroundColor: Colors.white70,
                                  ),
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

  void _onCellTap(BuildContext context, int row, int col) {
    final arenaProvider = Provider.of<ArenaProvider>(context, listen: false);
    final item = arenaProvider.getItem(row, col);
    onItemClicked != item;
  }
}
