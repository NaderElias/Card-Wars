import 'item_model.dart';

class User {
  String name;
  String image;
  String email;
  String password;
  List<List<Item>> decks=[[]];
  List<String> friends=[];

  User({
    required this.name,
    required this.image,
    required this.email,
    required this.password,
    required this.decks,
    required this.friends,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      image: map['image'],
      email: map['email'],
      password: map['password'],
      decks: (map['decks'] as List<dynamic>).map((deck) => (deck as List<dynamic>).map((item) => Item.fromMap(item as Map<String, dynamic>)).toList()).toList(),
      friends: List<String>.from(map['friends']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'email': email,
      'password': password,
      'decks': decks.map((innerList) {
      return innerList.map((item) => item.toMap()).toList();
    }).toList(),
      'friends': friends,
    };
  }
}
