import 'package:flutter/material.dart';
import 'package:foodhub/models/http_exception.dart';
import 'package:foodhub/provider/auth.dart';
import 'package:provider/provider.dart';
import '../../models/http_exception.dart';

import './signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

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
      // if (_authMode == AuthMode.login) {
      //   await Provider.of<Auth>(context, listen: false)
      //       .login(_authData['email']!, _authData['password']!);
      // } else {
      //   await Provider.of<Auth>(context, listen: false)
      //       .signup(_authData['email']!, _authData['password']!);
      // }
      await Provider.of<Auth>(context, listen: false)
          .login(_authData['email']!, _authData['password']!);
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
                        margin: const EdgeInsets.only(top: 50),
                        child: const CircleAvatar(
                          radius: 50.0,
                          backgroundImage: AssetImage("assets/images/logo.jpg"),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 40, top: 0),
                        alignment: Alignment.bottomRight,
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 70),
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
                        child: Center(
                          child: TextFormField(
                            cursorColor: const Color(0xffF5591F),
                            decoration: const InputDecoration(
                              icon: Icon(
                                Icons.email,
                                color: Color(0xffF5591F),
                              ),
                              hintText: "Enter Email",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !value.endsWith('@heraldcollege.edu.np')) {
                                return 'must ends with :@heraldcollege.edu.np';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              _authData['email'] = value!;
                            },
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                        child: Center(
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
                              if (value!.isEmpty) {
                                return 'required field';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['password'] = value!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                //   alignment: Alignment.centerRight,
                //   child: GestureDetector(
                //     onTap: () {
                //       // Write Click Listener Code Here
                //     },
                //     child: const Text("Forget Password?"),
                //   ),
                // ),
                GestureDetector(
                  onTap: _submit,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 25),
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
                            color: Color(0xffEEEEEE)),
                      ],
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't Have Any Account?  "),
                      GestureDetector(
                        child: const Text(
                          "Register Now",
                          style: TextStyle(color: Color(0xffF5591F)),
                        ),
                        onTap: () {
                          // Write Tap Code Here.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
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
