import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seniors_go_digital/constants/firebase_Collection.dart';
import 'package:seniors_go_digital/constants/providers.dart';
import 'package:seniors_go_digital/constants/user_data.dart';
import 'package:seniors_go_digital/utils/mytext.dart';
import 'package:seniors_go_digital/utils/zbtoast.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController descriptionCon = TextEditingController();
  TextEditingController titleCon = TextEditingController();

  File? imageUrl;
  String? imageLink;
  final ImagePicker _picker = ImagePicker();
  void getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageUrl = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              left: Get.width * 0.04,
              right: Get.width * 0.04,
              top: Get.height * 0.01),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  MyText(
                    text: "Enter you title and query",
                    textcolor: Colors.black,
                    fontSize: Get.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        NetworkImage(UserData.userProfile.imageUrl! == ""
                            ? UserData.avatar: UserData.userProfile.imageUrl!),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text:
                            "${UserData.userProfile.name.toString().capitalizeFirst}",
                        textcolor: Colors.black.withOpacity(.70),
                        fontSize: 15,
                      ),
                      MyText(
                        text: UserData.userProfile.email.toString(),
                        textcolor: Colors.black.withOpacity(.70),
                        fontSize: 15,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleCon,
                      decoration: const InputDecoration(
                          hintText: 'Write Subject...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400)
                          // Other decoration properties
                          ),
                    ),
                    TextFormField(
                      controller: descriptionCon,
                      maxLines: 4,
                      decoration: const InputDecoration(
                          hintText: 'Write query...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400)
                          // Other decoration properties
                          ),
                    ),
                    if (imageUrl != null)
                      Container(
                        height: Get.height * 0.28,
                        width: Get.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(imageUrl!), fit: BoxFit.fill)),
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      getImage();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.20),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Row(
                        children: [
                          Text("Select Image"),
                          SizedBox(width: Get.width*0.01,),
                          const Icon(Icons.image),

                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      // Navigator.pop(context);

                      if (titleCon.text.isEmpty) {
                        ZBotToast.showToastError(
                            message: "Please write subject",
                            title: "Subject Missing");
                      } else if (descriptionCon.text.isEmpty) {
                        ZBotToast.showToastError(
                            message: "Please write description",
                            title: "Description Missing");
                      } else {
                        ZBotToast.loadingShow();
                        String url = "";
                        if (imageUrl != null) {
                          url = await MainVM.userVM(context)
                              .uploadFile(XFile(imageUrl!.path));
                        }
                        var id =
                            Timestamp.now().millisecondsSinceEpoch.toString();
                        FBCollections.discussions.doc(id).set({
                          "subject": titleCon.text,
                          "description": descriptionCon.text,
                          "id": id,
                          "created_at": Timestamp.now(),
                          "status": 1,
                          "image": url,
                          "created_by": UserData.userProfile.uid
                        }).whenComplete(() {
                          Get.back();
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: Get.width * 0.2,
                      height: Get.height * 0.048,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(25)),
                      child: MyText(
                        text: "Post",
                        textcolor: Colors.white,
                        fontSize: Get.width * 0.035,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
