import 'dart:convert';
import 'dart:typed_data';
import 'package:card_wars/Providers/hand.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import 'Base.dart';
import 'mongodb_service.dart';
import '../providers/kards.dart';

class ArenaProvider with ChangeNotifier {
  List<List<Item?>> _map = List.generate(
    4,
    (_) => List.generate(5, (_) => null),
  );
  Item? onItemClicked = null;
  bool isCard = false;
  List<List<Item?>> get map => _map;
  int fcard = 6;
  int? _elevatedRow;
  int? _elevatedCol;

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

  int? get elevatedRow => _elevatedRow;
  int? get elevatedCol => _elevatedCol;

  void setElevatedCell(int? row, int? col) {
    if (_elevatedRow == row && _elevatedCol == col) {
      _elevatedRow = null; // Deselect if already elevated
      _elevatedCol = null;
    } else {
      _elevatedRow = row;
      _elevatedCol = col;
    }
    notifyListeners();
  }
}

class ArenaWidget extends StatelessWidget {
  ArenaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final itemsProvider = Provider.of<ItemsProvider>(context);
    final arenaProvider = Provider.of<ArenaProvider>(context);

    int rows = arenaProvider.map.length;
    int cols = arenaProvider.map[0].length;

    int itemIndex = 0;
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        if (itemIndex < itemsProvider.items.length) {
          arenaProvider._map[row][col] = itemsProvider.items[itemIndex];
          itemIndex++;
        } else {
          arenaProvider._map[row][col] =
              null; // Default value if items are exhausted
        }
      }
    }

    return Stack(
      children: [
        // Main Arena
        Consumer<ArenaProvider>(
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
                          child: AnimatedScale(
                            scale: arenaProvider.elevatedRow == rowIndex &&
                                    arenaProvider.elevatedCol == colIndex
                                ? 1.2
                                : 1.0,
                            duration: Duration(milliseconds: 300),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.all(4.0),
                              width: 60,
                              height: 90,
                              decoration: BoxDecoration(
                                color: arenaProvider.map[rowIndex][colIndex] ==
                                        null
                                    ? Colors.grey
                                    : Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: arenaProvider.elevatedRow ==
                                            rowIndex &&
                                        arenaProvider.elevatedCol == colIndex
                                    ? [
                                        BoxShadow(
                                            color: Colors.black54,
                                            blurRadius: 8,
                                            offset: Offset(0, 8))
                                      ]
                                    : [],
                              ),
                              child:
                                  arenaProvider.map[rowIndex][colIndex] == null
                                      ? null
                                      : Image.memory(
                                          base64Decode(arenaProvider
                                              .map[rowIndex][colIndex]!.image),
                                          fit: BoxFit.cover,
                                        ),
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            );
          },
        ),
        // Overlay Cards
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < arenaProvider.fcard; i++)
                Transform.translate(
                  offset: Offset(i * 4.0 - 12,
                      0), // Adjust the offset for overlapping effect
                  child: Transform.rotate(
                    angle: (i - 2.5) *
                        0.02, // Adjust the angle for slight fan effect
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.0),
                      width: 60,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _onCellTap(BuildContext context, int row, int col) {
    final arenaProvider = Provider.of<ArenaProvider>(context, listen: false);
    var handProvider = Provider.of<HandProvider>(context, listen: false);
    if (handProvider.onItemClicked != null) {
      if (arenaProvider._map[row][col] == null) {
        arenaProvider._map[row][col] = handProvider.onItemClicked;
      }
      handProvider.onItemClicked = null;
      handProvider.SetElevatedCardIndex(null as int);
      handProvider.setElevatedCard(handProvider.indexo as int);

      if (handProvider.indexo! < handProvider.hand.length) {
        final item = handProvider.hand[handProvider.indexo as int ];
      }
      return;
    }
    arenaProvider.setElevatedCell(row, col);

    final item = arenaProvider.getItem(row, col);

    // Show Snackbar with item details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(item != null ? 'Item: ${item.name}' : 'No item in this cell'),
      ),
    );

    // Optional: set `onItemClicked` if needed
    arenaProvider.onItemClicked = item;
  }
}
