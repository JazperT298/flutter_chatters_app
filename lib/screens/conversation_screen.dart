import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterchattersapp/helper/constants.dart';
import 'package:flutterchattersapp/services/database.dart';
import 'package:flutterchattersapp/services/database.dart';
import 'package:flutterchattersapp/widgets/widgets.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();

  Stream chatMessagesStream;
  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return MessageTile(snapshot.data.documents[index].data["message"],
                snapshot.data.documents[index].data["sendBy"] == Constants.myName);
          },
        ) : Container();
      },
    );
  }

  sendMessage(){
    if (messageController.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }else{
      print("Can't send empty message");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: <Widget>[
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                          controller: messageController,
                          style: TextStyle(
                              color: Colors.white
                          ),
                          decoration: InputDecoration(
                              hintText: "Message...",
                              hintStyle: TextStyle(
                                  color: Colors.white54
                              ),
                              border: InputBorder.none
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: () {
                        //initiateSearch();
                        sendMessage();
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
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget{
  final String message;
  final bool isSendByMe;

  MessageTile( this.message,this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0 : 18.0, right: isSendByMe ? 18.0 : 0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [
              const Color(0xff007EF4),
              const Color(0xff2A75BC)
            ]: [
              const Color(0x1AFFFFFF),
              const Color(0x1AFFFFFF)
            ],
          ),
          borderRadius: isSendByMe ?
              BorderRadius.only(
                topLeft: Radius.circular(23.0),
                topRight: Radius.circular(23.0),
                bottomLeft: Radius.circular(23.0)
              ) : BorderRadius.only(
              topLeft: Radius.circular(23.0),
              topRight: Radius.circular(23.0),
              bottomRight: Radius.circular(23.0)
          )
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17
          ),
        ),
      ),
    );
  }

}
