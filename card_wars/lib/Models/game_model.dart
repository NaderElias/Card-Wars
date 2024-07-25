import '../models/item_model.dart';
class Game {
   String playera;
   String playerb;
  List<List<Item?>> map = List.generate(
    5,
    (_) => List.generate(5, (_) => null),
  );

  Game({required this.playera, required this.playerb,required this.map});

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      playera: map['playera'],
      playerb: map['playerb'],
      map: map['map'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'playera': playera,
      'playerb': playerb,
      'map': map,
    };
  }
}
