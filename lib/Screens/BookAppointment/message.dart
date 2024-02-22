import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seniors_go_digital/AppStrings/Textstyle.dart';
import 'package:seniors_go_digital/chat/model/appointment_m.dart';
import 'package:seniors_go_digital/chat/model/chat_room_model.dart';
import 'package:seniors_go_digital/chat/model/message.dart';
import 'package:seniors_go_digital/constants/date_formate_service.dart';
import 'package:seniors_go_digital/constants/enum.dart';
import 'package:seniors_go_digital/constants/firebase_Collection.dart';
import 'package:seniors_go_digital/constants/user_data.dart';
import 'package:seniors_go_digital/utils/zbtoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../agura/create_channel_page.dart';
import '../../models/userDataModel.dart';

class MessageRoom extends StatefulWidget {
  final String name;
  final String assetImage;
  final ChatRoomModel? chatRoomModel;
  final UserProfile? myProfile;
  final UserProfile? otherProfile;
  const MessageRoom(
      {super.key,
      required this.name,
      this.chatRoomModel,
      required this.assetImage,
      this.myProfile,
      this.otherProfile});

  @override
  State<MessageRoom> createState() => _MessageRoomState();
}

class _MessageRoomState extends State<MessageRoom> {
  Color calculateTextColor(Color backgroundColor) {
    final double relativeLuminance = (0.299 * backgroundColor.red +
            0.587 * backgroundColor.green +
            0.114 * backgroundColor.blue) /
        255;

    return relativeLuminance > 0.5 ? Colors.black : Colors.white;
  }

  final TextEditingController _textController = TextEditingController();
  ScrollController scrollController = ScrollController();

  bool isZoomUrl(String url) {
    return url.contains("https://") && url.contains("zoom.us/");
  }

  final Query<UserProfile> userQuery = FirebaseFirestore.instance
      .collection('userData')
      .where("id", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .withConverter(
        fromFirestore: (snapshot, _) => UserProfile.fromMap(snapshot.data()!),
        toFirestore: (job, _) => job.toMap(),
      );
  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 1),
      () => scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.decelerate),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: ListTile(
          title: Text(
            widget.name,
            style: CustomTextStyles.customTextStyle600,
          ),
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.red, // Set a transparent background
            backgroundImage: widget.assetImage.isNotEmpty
                ? NetworkImage(widget.assetImage) // Use the provided image URL
                : null, // Set to null if no image URL is provided
            child: widget.assetImage.isNotEmpty
                ? null // No child if an image is present
                : Text(
                    widget.name.isNotEmpty
                        ? widget.name.substring(0, 1).toUpperCase()
                        : "", // Display initials if name is provided
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF2456D8),
          ),
        ),
        actions: [
          if (UserData.userProfile.role == "senior")
            IconButton(
                onPressed: () {
                  Get.bottomSheet(meetingLinkSend());
                },
                icon: Image.asset(
                  "assets/images/icon/video_call.png",
                  scale: 3.5,
                )),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
                stream: FBCollections.chatRoom
                    .doc(widget.chatRoomModel!.roomId)
                    .collection("conversation")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    return ListView(
                      controller: scrollController,
                      children: [
                        ...List.generate(snapshot.data!.docs.length, (index) {
                          MessageM message = MessageM.fromJson(
                              snapshot.data!.docs[index].data());
                          if (message.senderId == widget.myProfile!.email) {
                            return sender(message);
                          } else {
                            return receiver(message);
                          }
                        })
                      ],
                    );
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  if (widget.myProfile!.role == "User")
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.orange, shape: BoxShape.circle),
                      child: IconButton(
                        icon: const Icon(
                          Icons.schedule,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          dateCon.clear();
                          subCon.clear();
                          queryCon.clear();
                          isSend = false;
                          setState(() {});
                          Get.dialog(sendAppointment());
                        },
                      ),
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextField(
                    textAlign: TextAlign.start,
                    controller: _textController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: const TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.blue, shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        onSendMessage(_textController.text, 1);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget appointmentSender(MessageM m) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.red, // Set a transparent background
              backgroundImage: widget.otherProfile!.imageUrl!.isNotEmpty
                  ? NetworkImage(widget
                      .otherProfile!.imageUrl!) // Use the provided image URL
                  : null, // Set to null if no image URL is provided
              child: widget.otherProfile!.imageUrl!.isNotEmpty
                  ? null // No child if an image is present
                  : Text(
                      widget.otherProfile!.name!.isNotEmpty
                          ? widget.otherProfile!.name!
                              .substring(0, 1)
                              .toUpperCase()
                          : "", // Display initials if name is provided
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
            SizedBox(
              width: Get.width * 0.03,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherProfile!.name!.toString().capitalizeFirst!,
                  style: TextStyle(
                    color: calculateTextColor(
                        const Color(0xFF3a2b2e)), // Text color
                    fontSize: Get.width * 0.04, // Font size
                    fontStyle: FontStyle.normal, // Font style
                    fontWeight: FontWeight.bold,
                    // Font weight
                  ),
                ),
                Text(
                  widget.otherProfile!.email!.toString().capitalizeFirst!,
                  style: TextStyle(
                    color: calculateTextColor(
                        const Color(0xFF3a2b2e)), // Text color
                    fontSize: Get.width * 0.03, // Font size
                    fontStyle: FontStyle.normal, // Font style
                    fontWeight: FontWeight.w400,
                    // Font weight
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: Get.height * 0.02,
        ),
        StreamBuilder(
            stream: FBCollections.appointments.doc(m.message).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              } else {
                AppointmentM query =
                    AppointmentM.fromJson(snapshot.data!.data()!);
                return Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Subject : ",
                          style: TextStyle(
                            color: calculateTextColor(
                                const Color(0xFF3a2b2e)), // Text color
                            fontSize: 14.0, // Font size
                            fontStyle: FontStyle.normal, // Font style
                            fontWeight: FontWeight.bold, // Font weight
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            "${query.subject}",
                            style: TextStyle(
                              color: calculateTextColor(
                                  const Color(0xFF3a2b2e)), // Text color
                              fontSize: 14.0, // Font size
                              fontStyle: FontStyle.normal, // Font style
                              fontWeight: FontWeight.w300, // Font weight
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        Text(
                          "Query : ",
                          style: TextStyle(
                            color: calculateTextColor(
                                const Color(0xFF3a2b2e)), // Text color
                            fontSize: 14.0, // Font size
                            fontStyle: FontStyle.normal, // Font style
                            fontWeight: FontWeight.bold, // Font weight
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            "${query.query}",
                            style: TextStyle(
                              color: calculateTextColor(
                                  const Color(0xFF3a2b2e)), // Text color
                              fontSize: 14.0, // Font size
                              fontStyle: FontStyle.normal, // Font style
                              fontWeight: FontWeight.w300, // Font weight
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        Text(
                          "Appointment Date : ",
                          style: TextStyle(
                            color: calculateTextColor(
                                const Color(0xFF3a2b2e)), // Text color
                            fontSize: 14.0, // Font size
                            fontStyle: FontStyle.normal, // Font style
                            fontWeight: FontWeight.bold, // Font weight
                          ),
                        ),
                        Container(
                          width: Get.width * 0.7,
                          child: Text(
                            DateFormatService.dateFormatWithMonthNameTime(
                                query.date!.toDate()),
                            style: TextStyle(
                              color: calculateTextColor(
                                  const Color(0xFF3a2b2e)), // Text color
                              fontSize: 14.0, // Font size
                              fontStyle: FontStyle.normal, // Font style
                              fontWeight: FontWeight.w300, // Font weight
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          padding:
                              EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                          child: ElevatedButton(
                            onPressed: () {
                              if (query.status == 0) {
                                FBCollections.appointments
                                    .doc(query.id)
                                    .update({
                                  "status": AppointmentEnum.cancel.index
                                }).whenComplete(() {
                                  query.status = AppointmentEnum.cancel.index;
                                  setState(() {});
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: appointmentButtonColorSender(
                                    AppointmentEnum
                                        .values[query.status!.toInt()]),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Text(appointmentButtonSender(
                                  AppointmentEnum
                                      .values[query.status!.toInt()])),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                );
              }
            }),
      ],
    );
  }

  Widget appointmentReceiver(MessageM m) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.red, // Set a transparent background
              backgroundImage: widget.otherProfile!.imageUrl!.isNotEmpty
                  ? NetworkImage(widget
                      .otherProfile!.imageUrl!) // Use the provided image URL
                  : null, // Set to null if no image URL is provided
              child: widget.otherProfile!.imageUrl!.isNotEmpty
                  ? null // No child if an image is present
                  : Text(
                      widget.otherProfile!.name!.isNotEmpty
                          ? widget.otherProfile!.name!
                              .substring(0, 1)
                              .toUpperCase()
                          : "", // Display initials if name is provided
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
            SizedBox(
              width: Get.width * 0.03,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherProfile!.name!.toString().capitalizeFirst!,
                  style: TextStyle(
                    color: calculateTextColor(
                        const Color(0xFF3a2b2e)), // Text color
                    fontSize: Get.width * 0.035, // Font size
                    fontStyle: FontStyle.normal, // Font style
                    fontWeight: FontWeight.bold,
                    // Font weight
                  ),
                ),
                Text(
                  widget.otherProfile!.email!.toString().capitalizeFirst!,
                  style: TextStyle(
                    color: calculateTextColor(
                        const Color(0xFF3a2b2e)), // Text color
                    fontSize: Get.width * 0.03, // Font size
                    fontStyle: FontStyle.normal, // Font style
                    fontWeight: FontWeight.w400,
                    // Font weight
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: Get.height * 0.02,
        ),
        StreamBuilder(
            stream: FBCollections.appointments.doc(m.message).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              } else {
                AppointmentM query =
                    AppointmentM.fromJson(snapshot.data!.data()!);
                return Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Subject : ",
                          style: TextStyle(
                            color: calculateTextColor(
                                const Color(0xFF3a2b2e)), // Text color
                            fontSize: 14.0, // Font size
                            fontStyle: FontStyle.normal, // Font style
                            fontWeight: FontWeight.bold, // Font weight
                          ),
                        ),
                        Container(
                          width: Get.width * 0.7,
                          child: Text(
                            "${query.subject}",
                            style: TextStyle(
                              color: calculateTextColor(
                                  const Color(0xFF3a2b2e)), // Text color
                              fontSize: 14.0, // Font size
                              fontStyle: FontStyle.normal, // Font style
                              fontWeight: FontWeight.w300, // Font weight
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        Text(
                          "Query : ",
                          style: TextStyle(
                            color: calculateTextColor(
                                const Color(0xFF3a2b2e)), // Text color
                            fontSize: 14.0, // Font size
                            fontStyle: FontStyle.normal, // Font style
                            fontWeight: FontWeight.bold, // Font weight
                          ),
                        ),
                        Container(
                          width: Get.width * 0.7,
                          child: Text(
                            "${query.query}",
                            style: TextStyle(
                              color: calculateTextColor(
                                  const Color(0xFF3a2b2e)), // Text color
                              fontSize: 14.0, // Font size
                              fontStyle: FontStyle.normal, // Font style
                              fontWeight: FontWeight.w300, // Font weight
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        Text(
                          "Appointment Date : ",
                          style: TextStyle(
                            color: calculateTextColor(
                                const Color(0xFF3a2b2e)), // Text color
                            fontSize: 14.0, // Font size
                            fontStyle: FontStyle.normal, // Font style
                            fontWeight: FontWeight.bold, // Font weight
                          ),
                        ),
                        Container(
                          width: Get.width * 0.7,
                          child: Text(
                            DateFormatService.dateFormatWithMonthNameTime(
                                query.date!.toDate()),
                            style: TextStyle(
                              color: calculateTextColor(
                                  const Color(0xFF3a2b2e)), // Text color
                              fontSize: 14.0, // Font size
                              fontStyle: FontStyle.normal, // Font style
                              fontWeight: FontWeight.w300, // Font weight
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          padding:
                              EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                          child: ElevatedButton(
                            onPressed: () {
                              if (query.status == 0) {
                                FBCollections.appointments
                                    .doc(query.id)
                                    .update({
                                  "status": AppointmentEnum.accept.index
                                }).whenComplete(() {
                                  query.status = AppointmentEnum.accept.index;
                                  setState(() {});
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: appointmentButtonColorSender(
                                    AppointmentEnum
                                        .values[query.status!.toInt()]),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Text(appointmentButtonReceiver(
                                  AppointmentEnum
                                      .values[query.status!.toInt()])),
                            ),
                          ),
                        ),
                        if (query.status == 0)
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.1),
                            child: ElevatedButton(
                              onPressed: () {
                                if (query.status == 0) {
                                  FBCollections.appointments
                                      .doc(query.id)
                                      .update({
                                    "status": AppointmentEnum.reject.index
                                  }).whenComplete(() {
                                    query.status = AppointmentEnum.reject.index;
                                    setState(() {});
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: Text("Reject Now"),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              }
            }),
      ],
    );
  }

  Widget sender(MessageM m) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 7),
          child: Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Color(0xFF3a2b2e),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
                minHeight: MediaQuery.of(context).size.width * 0.03,
              ),
              child: m.type == 1
                  ? Linkify(
                      onOpen: _onUrlClicked,
                      text: m.message!,
                      style: TextStyle(
                        color: calculateTextColor(
                            const Color(0xFF3a2b2e)), // Text color
                        fontSize: 14.0, // Font size
                        fontStyle: FontStyle.normal, // Font style
                        fontWeight: FontWeight.w300, // Font weight
                      ),
                      linkStyle: TextStyle(
                        color: calculateTextColor(
                            const Color(0xFF3a2b2e)), // Text color
                        fontSize: 14.0, // Font size
                        fontStyle: FontStyle.normal, // Font style
                        fontWeight: FontWeight.w300, // Font weight
                      ),
                    )
                  : m.type == 2
                      ? appointmentSender(m)
                      : GestureDetector(
                          onTap: () {
                            Get.bottomSheet(CreateChannelPage(
                              chanelId: m.senderId! + m.id!,
                            ));
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/icon/video_call.png",
                                  scale: 3.5,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Meeting Link",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Get.width * 0.045),
                                    ),
                                    Text(
                                      "You can join meeting anytime.",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Get.width * 0.035),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
            ),
          ),
        ),
        // Add your user image here
      ],
    );
  }

  Widget receiver(MessageM m) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 7),
              child: Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF9BA8CA),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                      minHeight: MediaQuery.of(context).size.width * 0.03,
                    ),
                    child: m.type == 1
                        ? Linkify(
                            onOpen: _onUrlClicked,
                            text: m.message!,
                            style: TextStyle(
                              color: calculateTextColor(
                                  const Color(0xFF3a2b2e)), // Text color
                              fontSize: 14.0, // Font size
                              fontStyle: FontStyle.normal, // Font style
                              fontWeight: FontWeight.w300, // Font weight
                            ),
                            linkStyle: TextStyle(
                              color: calculateTextColor(
                                  const Color(0xFF3a2b2e)), // Text color
                              fontSize: 14.0, // Font size
                              fontStyle: FontStyle.normal, // Font style
                              fontWeight: FontWeight.w300, // Font weight
                            ),
                          )
                        : m.type == 2
                            ? appointmentReceiver(m)
                            : GestureDetector(
                                onTap: () {
                                  Get.bottomSheet(CreateChannelPage(
                                    chanelId: m.senderId! + m.id!,
                                  ));
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/icon/video_call.png",
                                        scale: 3.5,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Meeting Link",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Get.width * 0.045),
                                          ),
                                          Text(
                                            "You can join meeting anytime.",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Get.width * 0.035),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                  )),
            ),
          ],
        ));
  }

  Future<void> onSendMessage(String content, int type) async {
    if (content.trim() != '') {
      String docId = Timestamp.now().millisecondsSinceEpoch.toString();
      DocumentReference ref =
          FBCollections.chat(widget.chatRoomModel!.roomId).doc(docId);
      final serverTime = FieldValue.serverTimestamp();

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          ref,
          {
            'message': content,
            'receiver_id': widget.myProfile!.email !=
                    widget.chatRoomModel!.users![0].toString()
                ? widget.chatRoomModel!.users![0].toString()
                : widget.chatRoomModel!.users![1].toString(),
            'sender_id': widget.myProfile!.email,
            'created_at': serverTime,
            'seen': false,
            "id": docId,
            'type': type,
          },
        );
      }).then((value) {
        FBCollections.chatRoom.doc(widget.chatRoomModel!.roomId).update({
          "created_at": serverTime,
          "last_message": {
            'message': content,
            'receiver_id': widget.myProfile!.email !=
                    widget.chatRoomModel!.users![0].toString()
                ? widget.chatRoomModel!.users![0].toString()
                : widget.chatRoomModel!.users![1].toString(),
            'sender_id': widget.myProfile!.email,
            'created_at': serverTime,
            'seen': false,
            "id": docId,
            'type': type,
          }
        });
      }).then((value) async {
        if (type == 3) {
          await joinRoom(widget.myProfile!.email! + docId);
        }
      });

      _textController.clear();
      await Future.delayed(const Duration(seconds: 1));
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1), curve: Curves.decelerate);
    } else {
      Fluttertoast.showToast(msg: "Nothing send");
    }
  }

  Widget sendAppointment() {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Book Appointment",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.width * 0.04),
                  ),
                  TextFormField(
                    controller: subCon,
                    decoration: InputDecoration(hintText: "Enter subject"),
                  ),
                  TextFormField(
                    controller: queryCon,
                    decoration: InputDecoration(hintText: "Enter query"),
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: dateCon,
                    decoration: InputDecoration(hintText: "Select Date"),
                    onTap: () {
                      pickDateTime();
                    },
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  isSend == true
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            if (subCon.text.isEmpty) {
                              Fluttertoast.showToast(msg: "Subject Missing");
                            } else if (queryCon.text.isEmpty) {
                              Fluttertoast.showToast(msg: "query Missing");
                            } else if (dateCon.text.isEmpty) {
                              Fluttertoast.showToast(msg: "Date Missing");
                            } else {
                              isSend = true;
                              setState(() {});
                              String id = Timestamp.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              FBCollections.appointments
                                  .doc(id)
                                  .set(AppointmentM(
                                          id: id,
                                          date: Timestamp.fromDate(dateTime),
                                          query: queryCon.text,
                                          queryBy: widget.myProfile!.email,
                                          subject: subCon.text,
                                          queryTo: widget.otherProfile!.email,
                                          status: 0,
                                          createdAt: Timestamp.now())
                                      .toJson())
                                  .then((value) {
                                onSendMessage(id, 2).then((value) {
                                  Get.back();
                                });
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Text("Book Now"),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  DateTime dateTime = DateTime.now();
  TextEditingController subCon = TextEditingController();
  TextEditingController queryCon = TextEditingController();
  TextEditingController dateCon = TextEditingController();
  bool isSend = false;

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        initialDate: dateTime,
      );
  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;
    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      dateCon.text = DateFormat("MMM,dd yyyy hh:mm:a").format(dateTime);
      this.dateTime = dateTime;
    });
  }

  _onUrlClicked(LinkableElement link) async {
    String msg = link.url;
    bool _validURL = Uri.parse(msg).isAbsolute;
    //log("URL=>$_validURL");
    if (_validURL) {
      var status = await Permission.bluetooth.status;

      debugPrint(status.toString());

      if (status.isDenied) {
        Permission.bluetooth.request();
      } else {
        bool isUrl = isZoomUrl(msg);
        if (isUrl) {
        } else {
          //url launcher
          (await canLaunch(link.url))
              ? await launch(link.url)
              : throw 'Could not launch ${link.url}';
        }
      }
    }
  }

  Widget meetingLinkSend() {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              0.0,
              30.0,
              0.0,
              8.0,
            ),
            child: Text(
              'Meeting Link',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.only(bottom: 15.0),
            child: Text(
              "Are you want to send meeting link?",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  // width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('No'),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: SizedBox(
                  // width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      onSendMessage("Please join meeting with this link", 3)
                          .then((value) {
                        Get.back();
                      });
                    },
                    child: const Text('Yes'),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> joinRoom(String chanelName) async {
    final input = <String, dynamic>{
      'channelName': chanelName,
      'expiryTime': 3600, // 1 hour
    };
    try {
      final response = await FirebaseFunctions.instance
          .httpsCallable('generateToken')
          .call(input);
      final token = response.data as String?;
      if (token != null) {
        if (context.mounted) {
          ZBotToast.showToastSuccess(message: "Meeting created successfully");
        }
      }
    } catch (e) {
      ZBotToast.showToastError(message: 'Error generating token: $e');
    } finally {}
  }
}
