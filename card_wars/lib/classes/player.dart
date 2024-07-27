import '../models/item_model.dart';

class Player {
  final String name;
  final String image;
  int HP;
  int turns;
  List<Item> deck = [];
  List<Item> hand = [];
  List<Item> grave = [];

  Player({
    required this.name,
    required this.image,
    required this.HP,
    required this.turns,
    required this.hand,
    required this.deck,
    required this.grave,
  });

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      name: map['name'],
      image: map['image'],
      HP: map['HP'],
      turns: map['turns'],
      hand: (map['hand'] as List).map((item) => Item.fromMap(item)).toList(),
      deck: (map['deck'] as List).map((item) => Item.fromMap(item)).toList(),
      grave: (map['grave'] as List).map((item) => Item.fromMap(item)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'HP': HP,
      'turns': turns,
      'hand': hand.map((item) => item.toMap()).toList(),
      'deck': deck.map((item) => item.toMap()).toList(),
      'grave': grave.map((item) => item.toMap()).toList(),
    };
  }
}
