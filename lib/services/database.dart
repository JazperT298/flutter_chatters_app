import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  getUserByUsername(String username) async{
    return await Firestore.instance.collection("users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getUserByUserEmail(String userEmail) async{
    return await Firestore.instance.collection("users")
        .where("email", isEqualTo: userEmail)
        .getDocuments();
  }

  uploadUserInfo(userMap){
    Firestore.instance.collection("users").add(userMap).catchError((e){
      print(e.toString());
    });
  }

  createChatRoom(String chatroomid, chatroommap){
    Firestore.instance.collection("chat_room").document(chatroomid).setData(chatroommap).catchError((e){

    });
  }
  
  addConversationMessages(String chatRoomId, messageMap){
    Firestore.instance.collection("chat_room").document(chatRoomId).collection("chats").add(messageMap).catchError((e){
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId)async{
    return await Firestore.instance.collection("chat_room").document(chatRoomId).collection("chats").orderBy("time", descending: false).snapshots();
  }

  getChatRooms(String userName) async{
    return await Firestore.instance.collection("chat_room").where("users",arrayContains: userName).snapshots();
  }
}