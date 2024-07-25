class Item {
   String name;
   String image;
    
  Item({required this.name, required this.image});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }
}
