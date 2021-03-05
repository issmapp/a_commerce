import 'package:a_commerce/widgets/custom_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Build an alert dialog to display some errors.
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
  Future<String> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail, password: _registerPassword);
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
      _registerFormLoading = true;
    });

    // Run the create account method
    String _createAccountFeedback = await _createAccount();

    // If the string is not null, we got error while create account.
    if (_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);

      // Set the form to regular state [not loading].
      setState(() {
        _registerFormLoading = false;
      });
    } else {
      // The String was null, user is logged in.
      Navigator.pop(context);
    }
  }

  // Default Form Loading State
  bool _registerFormLoading = false;

  // Form Input Field Values
  String _registerEmail = "";
  String _registerPassword = "";

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
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          'Register',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                ),

                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter e-mail address',
                    labelText: 'E-mail : ',
                    prefixIcon:
                        Icon(Icons.email, color: Colors.black, size: 25),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  onChanged: (value) {
                    _registerEmail = value;
                  },
                  onFieldSubmitted: (value) {
                    _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 30),

                TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    labelText: 'Password : ',
                    prefixIcon:
                        Icon(Icons.lock_outline, color: Colors.black, size: 25),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  onChanged: (value) {
                    _registerPassword = value;
                  },
                  focusNode: _passwordFocusNode,
                  onFieldSubmitted: (value) {
                    _submitForm();
                  },
                ),
                SizedBox(
                  height: 50,
                ),

                // CustomInput(
                //   hintText: "Password...",
                //   onChanged: (value) {
                //     _registerPassword = value;
                //   },
                //   focusNode: _passwordFocusNode,
                //   isPasswordField: true,
                //   onSubmitted: (value) {
                //     _submitForm();
                //   },
                // ),

                // ElevatedButton.icon(
                //   style: ButtonStyle(
                //       backgroundColor: MaterialStateProperty.all(Colors.black)),
                //   onPressed: () {
                //     _submitForm();
                //   },

                //   icon: Icon(
                //     Icons.app_registration,
                //     color: Colors.white,
                //     size: 25,
                //   ),
                //   label: Text(
                //     'REGISTER',
                //     style: TextStyle(color: Colors.white, fontSize: 20),
                //   ),
                // ),
                CustomBtn(
                  text: "Create New Account",
                  onPressed: () {
                    _submitForm();
                  },
                  isLoading: _registerFormLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
