import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchattersapp/helper/helperfunctions.dart';
import 'package:flutterchattersapp/screens/chat_room_screen.dart';
import 'package:flutterchattersapp/services/auth.dart';
import 'package:flutterchattersapp/services/database.dart';
import 'package:flutterchattersapp/widgets/widgets.dart';

class SignUpScreen extends StatefulWidget {
  final Function toggle;
  SignUpScreen(this.toggle);
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController usernameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  QuerySnapshot snapShotUserInfo;

  signUpUser(){
    if(formKey.currentState.validate()){
      Map<String, String> userInfoMap = {
        "name": usernameTextEditingController.text,
        "email": emailTextEditingController.text
      };
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(usernameTextEditingController.text);
      setState(() {
        isLoading =  true;
      });
      databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val){
        snapShotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(snapShotUserInfo.documents[0].data["name"]);
      });
      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){
        //print("${val.uid}");
        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoomScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(
            child: CircularProgressIndicator()
        ),
      ) : SingleChildScrollView(
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
                          return val.isEmpty || val.length < 2 ? "Please provide a username" : null;
                        },
                        controller: usernameTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration(
                            "username"
                        ),
                      ),
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
                    signUpUser();
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
                      "Sign Up",
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
                      "Already have an account? ",
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
                          "Signin now",
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
