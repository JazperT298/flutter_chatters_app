import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchattersapp/helper/constants.dart';
import 'package:flutterchattersapp/screens/conversation_screen.dart';
import 'package:flutterchattersapp/services/database.dart';
import 'package:flutterchattersapp/widgets/widgets.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapShot;

  initiateSearch(){
    databaseMethods.getUserByUsername(searchTextEditingController.text).then((val){
      setState(() {
        searchSnapShot = val;
      });
      print(searchSnapShot.documents.length);
    });
  }

  //create chat room, send user to conversation screen
  createChatroomAndStartConversation({String userName}){
    if (userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomid": chatRoomId
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId)));
    }else{
      print("you cannot sent message to yourself");
    }
  }

  Widget SearchTile({String userName, String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName,
                style: simpleTextStyle(),
              ),
              Text(
                userEmail,
                style: simpleTextStyle(),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatroomAndStartConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30.0)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("Message",style: simpleTextStyle()),
            ),
          ),
        ],
      ),
    );
  }
  Widget searchList(){
    return searchSnapShot != null ? ListView.builder(
      itemCount: searchSnapShot.documents.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return SearchTile(
          userName: searchSnapShot.documents[index].data["name"],
          userEmail: searchSnapShot.documents[index].data["email"],
        );
      }
    ) : Container();
  }

  @override
  void initState() {
    // TODO: implement initState
    //initiateSearch();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(
                          color: Colors.white
                        ),
                        decoration: InputDecoration(
                          hintText: "Search Username...",
                          hintStyle: TextStyle(
                            color: Colors.white54
                          ),
                          border: InputBorder.none
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF)
                          ]
                        ),
                        borderRadius: BorderRadius.circular(40.0)
                      ),
                      padding: EdgeInsets.all(12.0),
                      child: Image.asset(
                          "assets/images/white_search.png",
                      ),
                    ),
                  )
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}



getChatRoomId(String user1, String user2){
  if(user1.substring(0, 1).codeUnitAt(0) > user2.substring(0, 1).codeUnitAt(0)){
    return "$user2\_$user1";
  }else{
    return "$user1\_$user2";
  }
}
