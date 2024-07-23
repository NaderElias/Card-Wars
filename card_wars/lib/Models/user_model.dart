class User {
  final String name;
  final String image;
  final String email;
  final String password;
  User({required this.name, required this.image,required this.email,required this.password});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      image: map['image'],
      email: map['email'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'email':email,
      'password':password,
    };
  }
}
