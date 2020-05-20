import 'package:flutter/material.dart';
import 'package:flutterchattersapp/helper/authenticate.dart';
import 'package:flutterchattersapp/helper/helperfunctions.dart';
import 'package:flutterchattersapp/screens/chat_room_screen.dart';
import 'package:flutterchattersapp/screens/signin_screen.dart';
import 'package:flutterchattersapp/screens/signup_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        if (value == null){
          userIsLoggedIn = false;
        }else{
          userIsLoggedIn = value;
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
      ),
      home: userIsLoggedIn ? ChatRoomScreen() :  Authenticate(),
    );
  }
}
