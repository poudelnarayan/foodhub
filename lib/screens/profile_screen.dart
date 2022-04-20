import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodhub/widgets/foods_grid.dart';
import 'package:foodhub/widgets/pickers/user_image_picker.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _userImageFile;
  void _pickedImage(File image) {
    _userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserImagePicker(imagePickFn: _pickedImage),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    Text('Your Name'),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Foods you liked',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FoodsGrid(
              showFavourites: true,
              isProfileScreen: true,
            ),
          ],
        ),
      ),
    );
  }
}
