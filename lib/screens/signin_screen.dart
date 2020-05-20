import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchattersapp/helper/helperfunctions.dart';
import 'package:flutterchattersapp/screens/chat_room_screen.dart';
import 'package:flutterchattersapp/services/auth.dart';
import 'package:flutterchattersapp/services/database.dart';
import 'package:flutterchattersapp/widgets/widgets.dart';

class SignInScreen extends StatefulWidget {
  final Function toggle;
  SignInScreen(this.toggle);
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  bool isLoading = false;
  QuerySnapshot snapShotUserInfo;
  signInUser(){
    if(formKey.currentState.validate()){
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      //HelperFunctions.saveUserNameSharedPreference(emailTextEditingController.text);
      setState(() {
        isLoading = true;
      });
      databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val){
        snapShotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(snapShotUserInfo.documents[0].data["name"]);
      });

      authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){
        if (val != null){
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoomScreen()));
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val) ? null : "Please provide a valid email";
                        },
                        controller: emailTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration(
                            "email"
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val){
                          return val.length > 6 ? null : "Please provide password more than 6 characters";
                        },
                        controller: passwordTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration(
                            "password"
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Text(
                      "Forgot Password? ",
                      style: simpleTextStyle(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                GestureDetector(
                  onTap: () {
                    signInUser();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30.0)
                    ),
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: Text(
                    "Sign In with Google",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "Register now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                            decoration: TextDecoration.underline
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
