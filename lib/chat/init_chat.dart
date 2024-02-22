import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:seniors_go_digital/chat/model/chat_room_model.dart';
import 'package:seniors_go_digital/constants/firebase_Collection.dart';

class InitiateChat {
  String? to;
  String? by;
  String? peerId;
  InitiateChat({
    this.to,
    this.by,
    this.peerId,
  });
  List<ChatRoomModel> chatRooms = [];
  DocumentSnapshot? myChatRoom;
  var db = FirebaseFirestore.instance;

  Future<ChatRoomModel> now() async {
    QuerySnapshot querySnapshot = await db.collection("chat").get();
    for (var element in querySnapshot.docs) {
      chatRooms.add(ChatRoomModel.fromJson(element));
    }
    debugPrint("${querySnapshot.docs.length}");
    if (!EmptyList.isTrue(querySnapshot.docs)) {
      List<ChatRoomModel> roomInfo = chatRooms
          .where((element) =>
              ((element.createdBy == by || element.createdBy == to) &&
                  (element.peerId == to || element.peerId == by)))
          .toList();
      //debugPrint("my room ${roomInfo.first.roomId.toString()}");
      if (EmptyList.isTrue(roomInfo)) {
        myChatRoom = await getRoomDoc(to!, by!);
        return ChatRoomModel.fromJson(myChatRoom!.data());
      } else {
        return roomInfo[0];
      }
    } else {
      debugPrint("direct here");
      DocumentSnapshot doc = await getRoomDoc(to!, by!);
      return ChatRoomModel.fromJson(doc);
    }
  }

  Future<DocumentSnapshot> getRoomDoc(String to, String by) async {
    // var model = Provider.of<DashBoardProvider>(Get.context, listen: false);
    // await model.startNewChatNotification(to, by, name);
    DocumentReference docId = FBCollections.chatRoom.doc();

    ChatRoomModel chatRoomModel = ChatRoomModel(
        createdAt: FieldValue.serverTimestamp(),
        createdBy: by,
        roomId: docId.id,
        peerId: peerId,
        users: [by, to],
        lastMessage: LastMessage(),
        delete: []);
    log(chatRoomModel.toJson().toString());
    await FBCollections.chatRoom.doc(docId.id).set(chatRoomModel.toJson());
    DocumentSnapshot chatRoomDoc =
        await FBCollections.chatRoom.doc(docId.id).get();
    return chatRoomDoc;
  }
}

class EmptyList {
  static bool isTrue(List list) {
    if (list.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
