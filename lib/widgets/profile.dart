import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:foodhub/widgets/foods_grid.dart';

class UserProfile extends StatefulWidget {
  static const routeName = '/profile-screen';
  const UserProfile({Key? key, required this.currentUser}) : super(key: key);
  final String currentUser;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  DocumentSnapshot<Map<String, dynamic>>? snapshot;
  final editNameController = TextEditingController();
  String? url;
  final _formKey = GlobalKey<FormState>();

  void getData() async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUser)
        .get();
    setState(() {
      snapshot = data;
    });
  }

  void updateData() async {
    Map<String, Object> data = {
      'username': editNameController.text,
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUser)
        .update(data);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // UserImagePicker(imagePickFn: _pickedImage),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: editNameController,
                          decoration:
                              const InputDecoration(label: Text('Enter name')),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Required field';
                            }
                            if (value.trim().length < 3) {
                              return 'Atleast four character required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel')),
                  TextButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      _formKey.currentState!.save();
                      updateData();
                      getData();

                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.edit),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: url == null
                      ? const AssetImage('assets/images/addimage.png')
                      : null,
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    Text(
                      snapshot?.data()?['username'].toString() ?? 'Loading..',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
            const FoodsGrid(
              showFavourites: true,
              isProfileScreen: true,
            ),
          ],
        ),
      ),
    );
  }
}
