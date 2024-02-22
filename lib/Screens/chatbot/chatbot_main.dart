import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniors_go_digital/AppStrings/asset_images.dart';
import 'package:seniors_go_digital/Screens/chatbot/chatBotDiscussion.dart';
import 'package:seniors_go_digital/Widget/AppBar/app_bar_specific_title.dart';
import 'package:seniors_go_digital/constants/firebase_Collection.dart';
import 'package:seniors_go_digital/constants/user_data.dart';
import 'package:seniors_go_digital/models/post_m.dart';
import 'package:seniors_go_digital/utils/zbtoast.dart';

class ChatMessage {
  final String question;
  final String answer;
  final int type;

  ChatMessage(
      {required this.question, required this.answer, required this.type});
}

class ChatBotMain extends StatefulWidget {
  const ChatBotMain({super.key});

  @override
  State<ChatBotMain> createState() => _ChatBotMainState();
}

class _ChatBotMainState extends State<ChatBotMain> {
  final TextEditingController _textController = TextEditingController();

  final List<ChatMessage> messages = [];
  final List<ChatMessage> messagesResult = [];
  ChatMessage? chatMessage;

  Future<void> getData() async {
    FBCollections.qa.get().then((value) {
      var docs = value.docs;
      for (var element in docs) {
        messages.add(ChatMessage(
            question: element["qus"], answer: element["ans"], type: 0));
      }
      setState(() {});
    }).then((value) {
      FBCollections.discussions.get().then((value) {
        var docs = value.docs;
        for (var element in docs) {
          messages.add(ChatMessage(
              question: element["description"],
              answer: element["id"],
              type: 1));
          setState(() {});
        }
      });
    });
  }

  Future<void> getSearch() async {
    int count = 0;
    int temp = 0;
    for (var element in messages) {
      temp = countMatchingWords(element.question, _textController.text);
      debugPrint(temp.toString());
      if (temp > count) {
        count = temp;
        chatMessage = element;
      }
    }
    if (chatMessage == null) {
      ZBotToast.showToast("Sorry not found 😢");
    }
    _textController.clear();
    setState(() {});
  }

  int countMatchingWords(String str1, String str2) {
    List<String> words1 = str1.split(" ");
    List<String> words2 = str2.split(" ");
    words1 = words1.map((word) => word.toLowerCase()).toList();
    words2 = words2.map((word) => word.toLowerCase()).toList();
    int matchingWords = 0;
    for (String word in words1) {
      if (words2.contains(word)) {
        matchingWords++;
      }
    }
    return matchingWords;
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70), // Set the width and height
        child: AppBarTitle(
          title: 'Chat bot',
          leadingWidget: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF2456D8),
              size: 22,
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              itemCount: messagesResult.length,
              itemBuilder: (BuildContext context, int index) {
                final message = messagesResult[index];
                if (message.type == 0) {
                  return _buildMessage(message);
                } else {
                  return newMessage(message);
                }
              }, separatorBuilder: (BuildContext context, int index) {  return const Divider(thickness: 2,indent: 20,endIndent: 20,);},
            ),
          ),
          if (chatMessage != null && chatMessage!.type == 0)
            newMessage2(chatMessage!),
          if (chatMessage != null && chatMessage!.type == 1)
            newMessage(chatMessage!),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  // Expanded(
                  //   child: TextFormField(
                  //     controller: _textController,
                  //
                  //     decoration: const InputDecoration(
                  //       floatingLabelBehavior: FloatingLabelBehavior.always,
                  //
                  //       labelStyle: TextStyle(
                  //           fontSize: 14, fontWeight: FontWeight.w600),
                  //       hintText: 'Send a message',
                  //       hintStyle: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w300,
                  //           color: Colors.black),
                  //       filled: true,
                  //      // fillColor: Color(0xFF9BA8CA),
                  //       enabledBorder: UnderlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: Colors.transparent,
                  //           width: 3,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(child: TextField(
                    textAlign: TextAlign.start,
                    controller: _textController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Send a message',
                      hintStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.all(16),

                    ),
                  ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle

                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send,color: Colors.white,),
                      onPressed: () {
                        if (_textController.text.isEmpty) {
                          ZBotToast.showToastError(
                              message: "Please type your question",
                              title: "Question Missing");
                        } else {
                          if (chatMessage != null) {
                            ZBotToast.loadingShow(color: Colors.blue);
                            messagesResult.add(chatMessage!);
                            chatMessage = null;
                          }
                          Future.delayed(const Duration(seconds: 1), () {
                            ZBotToast.loadingClose();
                            getSearch();
                          });
                          setState(() {});
                        }
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

  Widget _buildMessage(ChatMessage message) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: Get.width * 0.8,
              child: Text(
                message.question,
                style: const TextStyle(
                  color: Color(0xFF000000), // Text color
                  fontFamily: 'Poppins', // Font family
                  fontSize: 14.0, // Font size
                  fontStyle: FontStyle.normal, // Font style
                  fontWeight: FontWeight.w300, // Font weight
                ),
              ),
            ),
            // Add your user image here
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                AssetImages.userIcon, // Replace with your user image path
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: const Color(0xFF9BA8CA),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message.answer,
              style: const TextStyle(
                color: Color(0xFF000000), // Text color
                fontFamily: 'Poppins', // Font family
                fontSize: 14.0, // Font size
                fontStyle: FontStyle.normal, // Font style
                fontWeight: FontWeight.w300, // Font weight
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget newMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "Showing results for ",
                  style: TextStyle(
                    color: Colors.blue, // Text color
                    fontFamily: 'Poppins', // Font family
                    fontSize: Get.width * 0.04, // Font size
                    fontStyle: FontStyle.normal, // Font style
                    fontWeight: FontWeight.w300, // Font weight
                  )),
              TextSpan(
                  text: message.question,
                  style: TextStyle(
                    color: const Color(0xFF000000),
                    fontFamily: 'Poppins', // Font family
                    fontSize: Get.width * 0.035, // Font size
                    fontStyle: FontStyle.italic, // Font style
                    fontWeight: FontWeight.w300, // Font weight
                  )),
              TextSpan(
                  text: " in Discussion Form.",
                  style: TextStyle(
                    color: Colors.blue, // Text color
                    fontFamily: 'Poppins', // Font family
                    fontSize: Get.width * 0.04, // Font size
                    fontStyle: FontStyle.normal, // Font style
                    fontWeight: FontWeight.w300, // Font weight
                  )),
            ]),
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: (){
              FBCollections.discussions.doc(message.answer).get().then((value) {
                DiscussionM discussion = DiscussionM.fromJson(value.data());
                Get.to( ChatBotDiscussionPage(discussion: discussion,));
              });
              
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "Do you want to open",
                    style: TextStyle(
                      color: Colors.black, // Text color
                      fontFamily: 'Poppins', // Font family
                      fontSize: Get.width * 0.04, // Font size
                      fontStyle: FontStyle.normal, // Font style
                      fontWeight: FontWeight.w300, // Font weight
                    )),
                TextSpan(
                    text: " Discussion Form",
                    style: TextStyle(
                      color: Colors.blue, // Text color
                      fontFamily: 'Poppins', // Font family
                      fontSize: Get.width * 0.04, // Font size
                      fontStyle: FontStyle.italic, // Font style
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold, // Font weight
                    )),
                TextSpan(
                    text: " ?",
                    style: TextStyle(
                      color: Colors.black, // Text color
                      fontFamily: 'Poppins', // Font family
                      fontSize: Get.width * 0.035, // Font size
                      fontStyle: FontStyle.normal, // Font style
                      fontWeight: FontWeight.w300, // Font weight
                    )),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget newMessage2(ChatMessage message) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: Get.width * 0.8,
              child: Text(
                message.question,
                style: const TextStyle(
                  color: Color(0xFF000000), // Text color
                  fontFamily: 'Poppins', // Font family
                  fontSize: 14.0, // Font size
                  fontStyle: FontStyle.normal, // Font style
                  fontWeight: FontWeight.w300, // Font weight
                ),
              ),
            ),
            // Add your user image here
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProfileAvatar(
                "",
                radius: 20,
                elevation: 2,
                child: Image.network(
                  UserData.userProfile.imageUrl!, // Replace with your user image path
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProfileAvatar(
                "",
                radius: 20,
                elevation: 2,
                child: Image.asset(
                  "assets/images/icon/bot.png", // Replace with your user image path
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: Get.width*0.75,
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFA1CAF1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(message.answer,
                        speed: const Duration(milliseconds: 50)),
                  ],
                  pause: const Duration(seconds: 1),
                  repeatForever: false,

                  totalRepeatCount: 1,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
