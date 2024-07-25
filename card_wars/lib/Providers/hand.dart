import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import 'arena.dart';
import 'mongodb_service.dart';
import "../providers/kards.dart";
class HandProvider extends ChangeNotifier {
  List<Item> _hand = [];

  List<Item> get hand => _hand;

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
}
// ignore: must_be_immutable
class HandWidget extends StatelessWidget {
  Item? onItemClicked = null;

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
              Transform.rotate(
                angle: (i - handSize / 2) * 0.1, // Adjust the angle for fanned-out effect
                child: GestureDetector(
                  onTap: () => _onCardTap(context, i),
                  child: Container(
                    margin: EdgeInsets.all(4.0),
                    width: 60,
                    height: 90,
                    decoration: BoxDecoration(
                      color: i < handProvider.hand.length ? Colors.white : Colors.grey,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: i < handProvider.hand.length
                        ? Image.memory(
                            base64Decode(handProvider.hand[i].image),
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

    if (index < handProvider.hand.length) {
      final item = handProvider.hand[index];

      // Show Snackbar with item details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item: ${item.name}'),
        ),
      );

      // Optional: set `onItemClicked` if needed
      onItemClicked = item;
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