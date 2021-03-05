import 'dart:io';

import 'package:a_commerce/constants.dart';
import 'package:a_commerce/screens/register_page.dart';
import 'package:a_commerce/widgets/custom_btn.dart';
import 'package:a_commerce/widgets/custom_input.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              TextButton(
                child: Text("Close Dialog"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  // Create a new user account
  Future<String> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail, password: _loginPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    // Set the form to loading state
    setState(() {
      _loginFormLoading = true;
    });

    // Run the create account method
    String _loginFeedback = await _loginAccount();

    // If the string is not null, we got error while create account.
    if (_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);

      // Set the form to regular state [not loading].
      setState(() {
        _loginFormLoading = false;
      });
    }
  }

  // Default Form Loading State
  bool _loginFormLoading = false;

  // Form Input Field Values
  String _loginEmail = "";
  String _loginPassword = "";

  // Focus Node for input fields
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: DelayedDisplay(
                    fadingDuration: Duration(seconds: 2),
                    fadeIn: true,
                    slidingCurve: Curves.easeInCirc,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 30,
                      ),
                      child: Image.asset("assets/covertitle.png"),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            labelText: 'E-mail',
                            hintText: 'Enter e-mail here'),
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          _loginEmail = value;
                        },
                        onFieldSubmitted: (value) {
                          _passwordFocusNode.requestFocus();
                        },
                      ),
                      // CustomInput(
                      //   hintText: "Email...",
                      //   onChanged: (value) {
                      //     _loginEmail = value;
                      //   },
                      //   onSubmitted: (value) {
                      //     _passwordFocusNode.requestFocus();
                      //   },
                      //   textInputAction: TextInputAction.next,
                      // ),
                      SizedBox(height: 15),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter password here',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                        ),
                        focusNode: _passwordFocusNode,
                        onChanged: (value) {
                          _loginPassword = value;
                        },
                        onFieldSubmitted: (value) {
                          _submitForm();
                        },
                      ),
                      // CustomInput(
                      //   hintText: "Password...",
                      //   onChanged: (value) {
                      //     _loginPassword = value;
                      //   },
                      //   focusNode: _passwordFocusNode,
                      //   isPasswordField: true,
                      //   onSubmitted: (value) {
                      //     _submitForm();
                      //   },
                      // ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black)),
                        onPressed: () {},
                        icon: Icon(
                          Icons.login,
                          color: Colors.white,
                          size: 25,
                        ),
                        label: Text(
                          'SIGN IN',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      // CustomBtn(
                      //   text: "Login",
                      //   onPressed: () {
                      //     _submitForm();
                      //   },
                      //   isLoading: _loginFormLoading,
                      // )
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                        icon: Icon(
                          Icons.app_registration,
                          color: Colors.black,
                          size: 25,
                        ),
                        label: Text(
                          'Don\'t have an account? Sign Up now!',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //     bottom: 16.0,
                //   ),
                //   child: CustomBtn(
                //     text: "Create New Account",
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => RegisterPage()),
                //       );
                //     },
                //     outlineBtn: true,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
