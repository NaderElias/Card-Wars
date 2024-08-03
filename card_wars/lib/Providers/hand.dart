import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import 'arena.dart';
import 'mongodb_service.dart';
import "../providers/kards.dart";

class HandProvider extends ChangeNotifier {
  List<Item?> _hand = [];
  int? _elevatedCardIndex;
  Item? onItemClicked = null;
  int? indexo;
  List<Item?> get hand => _hand;
  int? get elevatedCardIndex => _elevatedCardIndex;

  void SetElevatedCardIndex(int x) {
    if(x<0){return;}
    _elevatedCardIndex = x;
  }

  void addItem(Item item) {
    if (_hand.length < 6) {
      _hand.add(item);
      notifyListeners();
    }
  }

  void removeItem(Item item) {
    _hand.remove(item);
    notifyListeners();
  }

  void clearHand() {
    _hand.clear();
    notifyListeners();
  }

  void setElevatedCard(int index) {
    if(index<0){return;}
    if (_elevatedCardIndex == index) {
      _elevatedCardIndex = null; // Deselect if already elevated
    } else {
      _elevatedCardIndex = index;
    }
    notifyListeners();
  }
}

class HandWidget extends StatelessWidget {
  HandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final handProvider = Provider.of<HandProvider>(context);

    int handSize = 6;

    return Consumer<HandProvider>(
      builder: (context, handProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < handSize; i++)
              GestureDetector(
                onTap: () => _onCardTap(context, i),
                child: AnimatedScale(
                  scale: i == handProvider.elevatedCardIndex ? 1.2 : 1.0,
                  duration: Duration(milliseconds: 300),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.all(4.0),
                    width: 60,
                    height: 90,
                    decoration: BoxDecoration(
                      color: i < handProvider.hand.length
                          ? Colors.white
                          : Color.fromARGB(255, 3, 230, 59),
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: i == handProvider.elevatedCardIndex
                          ? [
                              BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 8,
                                  offset: Offset(0, 8))
                            ]
                          : [],
                    ),
                    child: i < handProvider.hand.length
                        ? Image.memory(
                            base64Decode(handProvider.hand[i]!.image),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _onCardTap(BuildContext context, int index) {
    final handProvider = Provider.of<HandProvider>(context, listen: false);
    handProvider.indexo = index;
    handProvider.setElevatedCard(index);

    if (index < handProvider.hand.length) {
      final item = handProvider.hand[index];

      // Show Snackbar with item details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item: ${item?.name}'),
        ),
      );

      // Optional: set `onItemClicked` if needed
      handProvider.onItemClicked = item;
    } else {
      // Show Snackbar if no item
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No item in this card slot'),
        ),
      );
    }
  }
}
