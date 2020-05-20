import 'package:flutter/material.dart';
import 'package:flutterchattersapp/helper/authenticate.dart';
import 'package:flutterchattersapp/helper/constants.dart';
import 'package:flutterchattersapp/helper/helperfunctions.dart';
import 'package:flutterchattersapp/screens/conversation_screen.dart';
import 'package:flutterchattersapp/screens/search_screen.dart';
import 'package:flutterchattersapp/screens/signin_screen.dart';
import 'package:flutterchattersapp/services/auth.dart';
import 'package:flutterchattersapp/services/database.dart';
import 'package:flutterchattersapp/widgets/widgets.dart';

class ChatRoomScreen extends StatefulWidget {
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return ChatRoomTile(
              snapshot.data.documents[index].data["chatroomid"]
                  .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                snapshot.data.documents[index].data["chatroomid"]
            );
          },
        ) : Container();
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter connect'
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              authMethods.signOutUser();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.exit_to_app)
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
      body: chatRoomList(),
    );
  }
}

class ChatRoomTile extends StatelessWidget{
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: <Widget>[
            Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40.0)
              ),
              child: Text(
                "${userName.substring(0,1).toUpperCase()}"
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(
              userName,
              style: mediumTextStyle(),
            ),
          ],
        ),
      ),
    );
  }

}
