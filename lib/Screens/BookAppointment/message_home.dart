import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniors_go_digital/chat/model/chat_room_model.dart';
import 'package:seniors_go_digital/constants/firebase_Collection.dart';
import 'package:seniors_go_digital/models/userDataModel.dart';

import '../../AppStrings/Textstyle.dart';
import '../../AppStrings/app_routes.dart';
import '../../AppStrings/asset_images.dart';
import 'message.dart';

class MessageHome extends StatefulWidget {
  const MessageHome({super.key});

  @override
  State<MessageHome> createState() => _MessageHomeState();
}

class _MessageHomeState extends State<MessageHome> {
  List<String> name = [
    "Dr. Kainat Nasir",
    "Dr. Irfan Lutfi",
    "Dr. Umna Khan",
    "Dr. Manahil Ali",
    "Dr. Azhar Chugtai",
    "Dr. Shoaib Suleman"
  ];
  List<String> imagePath = [
    AssetImages.avatar1Icon,
    AssetImages.avatar2Icon,
    AssetImages.avatar3Icon,
    AssetImages.avatar4Icon,
    AssetImages.avatar5Icon,
    AssetImages.avatar6Icon
  ];
  List<int> unRead = [2, 4, 8, 10, 11, 12];
  UserProfile product = UserProfile();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> getUserData() async {
    await FBCollections.userData
        .where("email", isEqualTo: _firebaseAuth.currentUser!.email)
        .get()
        .then((value) {
      product =
          UserProfile.fromMap(value.docs.first.data() as Map<String, dynamic>?);
    });
    setState(() {});
  }

  @override
  void initState() {
    getUserData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Inbox",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            fontFamily: "Poppins",
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,

      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          children: [
            StreamBuilder(
                stream: FBCollections.chatRoom
                    .where("users", arrayContains: product.email)
                    .where("last_message.message", isNull: false)
                    .orderBy(
                      "last_message.message",
                    )
                    .orderBy("created_at", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: Get.height * 0.35),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Chat Not Found",
                              ),
                              Container(
                                child: const Text(
                                  "Conversation Not Started Yet!",
                                ),
                              )
                            ]),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.separated(
                        physics: const ScrollPhysics(),
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoom = ChatRoomModel.fromJson(
                              snapshot.data!.docs[index]);
                          debugPrint(chatRoom.roomId);
                          return chatHead(chatRoom);
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 8.0,
                            color: Color(0xFFEEEEEE),
                            thickness: 1.0,
                          );
                        },
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  Widget chatHead(ChatRoomModel chatRoom) {
    return FutureBuilder(
        future: FBCollections.userData
            .where("email",
                isEqualTo: product.email != chatRoom.users![0].toString()
                    ? chatRoom.users![0].toString()
                    : chatRoom.users![1].toString())
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          } else {
            UserProfile user = UserProfile.fromMap(
                snapshot.data!.docs.first.data() as Map<String, dynamic>?);
            return ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) {
                    if (chatRoom.lastMessage!.seen == false &&
                        chatRoom.lastMessage!.receiverId == product.email) {
                      FBCollections.chatRoom
                          .doc(chatRoom.roomId)
                          .update({"last_message.seen": true});
                    }
                    return MessageRoom(
                      name: user.name ?? "",
                      assetImage: user.imageUrl ?? "",
                      chatRoomModel: chatRoom,
                      myProfile: product,
                      otherProfile: user,
                    );
                  }));
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.imageUrl!),
                ),
                title: Text(
                  user.name!,
                  style: CustomTextStyles.customTextStyle700,
                ),
                subtitle: Text(
                  chatRoom.lastMessage!.type == 1
                      ? "${chatRoom.lastMessage!.message}"
                      : "Appointment",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: CircleAvatar(
                  backgroundColor: chatRoom.lastMessage!.seen == false &&
                          chatRoom.lastMessage!.receiverId == product.email
                      ? Colors.redAccent
                      : Colors.transparent,
                  radius: 5,
                ));
          }
        });
  }
}
