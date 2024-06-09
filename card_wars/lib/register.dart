import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import '../models/user_model.dart';

import '../providers/Base.dart';
import '../providers/mongodb_service.dart';
import 'package:go_router/go_router.dart';
class RegisterPage extends StatefulWidget {
const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  void initState() {
    super.initState();
    // Use the provider instance of Base
    final base = Provider.of<Base>(context, listen: false);
    base.initialize('user');
  }
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _base64Image;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
final base = Provider.of<Base>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

                if (pickedFile != null) {
                  final bytes = await pickedFile.readAsBytes();
                  setState(() {
                    _base64Image = base64Encode(bytes);
                  });
                }
              },
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            _base64Image != null
                ? Image.memory(
                    base64Decode(_base64Image!),
                    height: 100,
                    width: 100,
                  )
                : Text('No image selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_passwordController.text == _confirmPasswordController.text) {
                  User user = User(
                    name: _nameController.text,
                    image: _base64Image ?? '',
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  base.mongoDBService.register(user);
                  context.go('/');

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Passwords do not match')),
                  );
                }
              },
              child: Text('Register'),
            ),
            TextButton(
              onPressed: () {
                context.go('/');
              },
              child: Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
