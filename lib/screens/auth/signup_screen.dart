import 'package:flutter/material.dart';
import 'package:foodhub/models/http_exception.dart';
import 'package:foodhub/provider/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../models/http_exception.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  // ignore: prefer_final_fields
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occured'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Okay')),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      final authResult = await Provider.of<Auth>(context, listen: false)
          .signup(_authData['email']!, _authData['password']!);
      await FirebaseFirestore.instance.collection('users').doc(authResult).set({
        'username': _nameController.text,
        'email': _authData['email']!,
      });

      Navigator.of(context).pop();
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you. Please try again later';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(90)),
                    color: Color(0xffF5591F),
                    gradient: LinearGradient(
                      colors: [(Color(0xffF5591F)), Color(0xffF2861E)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 40),
                          child: const CircleAvatar(
                            radius: 50.0,
                            backgroundImage:
                                AssetImage("assets/images/icon.png"),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 40, top: 0),
                          alignment: Alignment.bottomRight,
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 30),
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[200],
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(0, 10),
                                  blurRadius: 50,
                                  color: Color(0xffEEEEEE)),
                            ],
                          ),
                          child: TextFormField(
                            cursorColor: const Color(0xffF5591F),
                            decoration: const InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: Color(0xffF5591F),
                              ),
                              hintText: "Full Name",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            controller: _nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'required field';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 15),
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[200],
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 10),
                                blurRadius: 50,
                                color: Color(0xffEEEEEE),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            cursorColor: const Color(0xffF5591F),
                            decoration: const InputDecoration(
                              icon: Icon(
                                Icons.email,
                                color: Color(0xffF5591F),
                              ),
                              hintText: "Email",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              // if (value!.isEmpty ||
                              //     !value.endsWith('@heraldcollege.edu.np')) {
                              //   return 'must ends with :@heraldcollege.edu.np';
                              // } else {
                              //   return null;
                              // }
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'not a valid email';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              _authData['email'] = value!;
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 15),
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xffEEEEEE),
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(0, 20),
                                  blurRadius: 100,
                                  color: Color(0xffEEEEEE)),
                            ],
                          ),
                          child: TextFormField(
                            obscureText: true,
                            cursorColor: const Color(0xffF5591F),
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              focusColor: Color(0xffF5591F),
                              icon: Icon(
                                Icons.vpn_key,
                                color: Color(0xffF5591F),
                              ),
                              hintText: "Enter Password",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 5) {
                                return 'Password is too short!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['password'] = value!;
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 15),
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xffEEEEEE),
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(0, 20),
                                  blurRadius: 100,
                                  color: Color(0xffEEEEEE)),
                            ],
                          ),
                          child: TextFormField(
                              obscureText: true,
                              cursorColor: const Color(0xffF5591F),
                              decoration: const InputDecoration(
                                focusColor: Color(0xffF5591F),
                                icon: Icon(
                                  Icons.vpn_key,
                                  color: Color(0xffF5591F),
                                ),
                                hintText: "Enter Password Again",
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                                if (value!.isEmpty) {
                                  return 'required field';
                                }
                                return null;
                              }),
                        ),
                      ],
                    )),
                GestureDetector(
                  onTap: _submit,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [(Color(0xffF5591F)), Color(0xffF2861E)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200],
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          color: Color(0xffEEEEEE),
                        ),
                      ],
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "REGISTER",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already a Member?  "),
                      GestureDetector(
                        child: const Text(
                          "Login Now",
                          style: TextStyle(color: Color(0xffF5591F)),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
