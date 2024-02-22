import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seniors_go_digital/AppStrings/asset_images.dart';
import 'package:seniors_go_digital/Screens/discussionPage/createpost_screen.dart';
import 'package:seniors_go_digital/constants/firebase_Collection.dart';
import 'package:seniors_go_digital/constants/providers.dart';
import 'package:seniors_go_digital/constants/user_data.dart';
import 'package:seniors_go_digital/models/comment_m.dart';
import 'package:seniors_go_digital/models/like_m.dart';
import 'package:seniors_go_digital/models/post_m.dart';
import 'package:seniors_go_digital/models/userDataModel.dart';
import 'package:seniors_go_digital/utils/mytext.dart';
import 'package:seniors_go_digital/utils/zbtoast.dart';
import 'package:timeago/timeago.dart' as timeago;

class DiscussionPage extends StatefulWidget {
  const DiscussionPage({super.key});

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  TextEditingController commentCon = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // MainVM.userVM(context).onInit();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEEF4),
      appBar: AppBar(
        title: const Text(
          "Discussion Forum",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(

              children: [
                CircularProfileAvatar(
                  "",
                  radius: 22,
                  elevation: 3,
                  child: Image.network(UserData.userProfile.imageUrl!),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Get.to(const CreatePostScreen());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.03, vertical: Get.height * 0.015),
                      //width: Get.width,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xFFD1D9ED),
                      ),
                      child: Text(
                        "Do you want to ask or share something?",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: Get.width * 0.035),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Get.to(const CreatePostScreen());
                  },
                  child: CircularProfileAvatar(
                    "",
                    radius: 22,
                    elevation: 3,
                    child: Image.asset("assets/images/icon/photo.png"),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: FBCollections.discussions
                    .where("status", isEqualTo: 1)
                    .orderBy("created_at", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    return ListView.separated(
                        itemBuilder: (context, index) {
                          DiscussionM disc = DiscussionM.fromJson(
                              snapshot.data!.docs[index].data());
                          return discussionWidget(disc);
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: snapshot.data?.docs.length ?? 0);
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget discussionWidget(DiscussionM discussionM) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.04, vertical: Get.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
              future: FBCollections.userData.doc(discussionM.createdBy).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  UserProfile user = UserProfile.fromMap(
                      snapshot.data!.data() as Map<String, dynamic>?);
                  return Row(
                    children: [
                      CircularProfileAvatar(
                        "",
                        radius: 25,
                        elevation: 3,
                        child: Image.network(
                          user.imageUrl == "" || user.imageUrl == null
                              ? UserData.avatar
                              : user.imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.03,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${user.name}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${user.email}",
                          )
                        ],
                      ),
                      Spacer(),
                      if (discussionM.createdBy == UserData.userProfile.uid)
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.red.withOpacity(.10),
                                borderRadius: BorderRadius.circular(7)),
                            child: IconButton(
                                onPressed: () {
                                  FBCollections.discussions
                                      .doc(discussionM.id)
                                      .delete()
                                      .then((value) {
                                    ZBotToast.showToastSuccess(
                                      message: "Form deleted successfully",
                                    );
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                )))
                    ],
                  );
                }
              }),
          SizedBox(
            height: Get.height * 0.02,
          ),
          SizedBox(
            width: Get.width * 0.85,
            child: Text(
              discussionM.subject.toString().capitalizeFirst ?? "",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: Get.width * 0.04),
            ),
          ),
          SizedBox(
            height: Get.height * 0.01,
          ),
          if (discussionM.image != "")
            Container(
              width: Get.width,
              height: Get.height * 0.3,
              margin: EdgeInsets.only(bottom: Get.height * 0.01),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    discussionM.image!,
                    fit: BoxFit.cover,
                  )),
            ),
          ExpandableText(
            discussionM.description.toString().capitalizeFirst ?? "",
            expandText: 'Show More',
            collapseText: 'Show Less',
            onExpandedChanged: (value) {},
            expandOnTextTap: true,
            expanded: false,
            animation: true,
            collapseOnTextTap: true,
            animationCurve: Curves.decelerate,
            animationDuration: const Duration(milliseconds: 700),
            maxLines: 3,
            linkColor: Colors.blue,
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: Get.width * 0.035),
            hashtagStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: Get.width * 0.035),
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder(
                  stream: FBCollections.likes
                      .where("post_id", isEqualTo: discussionM.id)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return SizedBox();
                    } else {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (snapshot.data!.docs
                              .map((e) => LikeM.fromJson(e))
                              .toList()
                              .any((element) =>
                                  element.by == UserData.userProfile.uid))
                            GestureDetector(
                              onTap: () {
                                LikeM like = snapshot.data!.docs
                                    .map((e) => LikeM.fromJson(e.data()))
                                    .toList()
                                    .firstWhere((element) =>
                                        element.by == UserData.userProfile.uid);
                                if (like.status == 1) {
                                  FBCollections.likes
                                      .doc(like.id)
                                      .update({"status": 0});
                                } else {
                                  FBCollections.likes
                                      .doc(like.id)
                                      .update({"status": 1});
                                }
                              },
                              child: GestureDetector(
                                  child: Icon(
                                Icons.thumb_up,
                                color: snapshot.data!.docs
                                        .map((e) => LikeM.fromJson(e.data()))
                                        .toList()
                                        .where((element) =>
                                            element.by ==
                                                UserData.userProfile.uid &&
                                            element.status == 1)
                                        .toList()
                                        .isEmpty
                                    ? Colors.grey
                                    : Colors.blue,
                              )),
                            )
                          else
                            GestureDetector(
                                onTap: () {
                                  String id = Timestamp.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                  FBCollections.likes.doc(id).set(LikeM(
                                          id: id,
                                          by: UserData.userProfile.uid,
                                          postId: discussionM.id,
                                          createdAt: Timestamp.now(),
                                          status: 1)
                                      .toJson());
                                },
                                child: const Icon(
                                  Icons.thumb_up,
                                  color: Colors.grey,
                                )),
                          SizedBox(
                            width: Get.width * 0.02,
                          ),
                          MyText(
                            text:
                                "${snapshot.data!.docs.map((e) => LikeM.fromJson(e.data())).toList().where((element) => element.status == 1).toList().length} Likes ",
                            textcolor: Colors.grey.withOpacity(.90),
                            fontSize: 14,
                          ),
                        ],
                      );
                    }
                  }),
              const Spacer(),
              InkWell(
                  onTap: () {
                    Get.bottomSheet(
                        _commentBottomSheet(context, discussionM.id));
                  },
                  child: StreamBuilder(
                      stream: FBCollections.comments
                          .where("id", isEqualTo: discussionM.id)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox();
                        } else {
                          return MyText(
                            text: "${snapshot.data!.docs.length} Comments ",
                            textcolor: Colors.grey.withOpacity(.90),
                            fontSize: 14,
                          );
                        }
                      })),
            ],
          ),
        ],
      ),
    );
  }

  Widget _commentBottomSheet(context, postID) {
    {
      return InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Get.forceAppUpdate();
          },
          child: StreamBuilder(
              stream: FBCollections.comments
                  .where("id", isEqualTo: postID)
                  .where("status", isEqualTo: 1)
                  .orderBy("created_at", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox();
                } else {
                  return Container(
                      height: Get.height * 0.59,
                      width: Get.width,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(),
                                  MyText(
                                    text:
                                        "${snapshot.data?.docs.length ?? 0} comments",
                                    textcolor: Colors.black,
                                    fontSize: Get.width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        size: 27,
                                        color: Colors.black,
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              height: Get.height * 0.39,
                              width: Get.width,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    CommentM comment = CommentM.fromJson(
                                        snapshot.data!.docs[index]);
                                    return GestureDetector(
                                        onTap: () {},
                                        child: FutureBuilder(
                                            future: FBCollections.userData
                                                .doc(comment.by)
                                                .get(),
                                            builder: (context,
                                                AsyncSnapshot<DocumentSnapshot>
                                                    snapshot) {
                                              if (!snapshot.hasData) {
                                                return SizedBox();
                                              } else {
                                                UserProfile profile =
                                                    UserProfile.fromMap(
                                                        snapshot.data!.data()
                                                            as Map<String,
                                                                dynamic>?);
                                                return Container(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: Get.width * 0.03,
                                                      ),
                                                      CircleAvatar(
                                                          radius: 20,
                                                          backgroundImage: NetworkImage(
                                                              profile.imageUrl ==
                                                                          "" ||
                                                                      profile.imageUrl ==
                                                                          null
                                                                  ? UserData
                                                                      .avatar
                                                                  : profile
                                                                      .imageUrl!)),
                                                      SizedBox(
                                                        width: Get.width * 0.02,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: Get.height *
                                                                0.03,
                                                          ),
                                                          MyText(
                                                            text: profile.name!,
                                                            textcolor:
                                                                Colors.grey,
                                                            fontSize:
                                                                Get.width *
                                                                    0.037,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          Container(
                                                            width:
                                                                Get.width * 0.8,
                                                            child: MyText(
                                                              text: comment
                                                                  .comment!,
                                                              textcolor:
                                                                  Colors.black,
                                                              fontSize:
                                                                  Get.width *
                                                                      0.036,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: Get.height *
                                                                0.004,
                                                          ),
                                                          MyText(
                                                            text:
                                                                "${timeago.format(comment.createdAt!.toDate(), locale: 'en_short')} ago",
                                                            textcolor: Colors
                                                                .grey
                                                                .withOpacity(
                                                                    .70),
                                                            fontSize:
                                                                Get.width *
                                                                    0.033,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }
                                            }));
                                  }),
                            ),
                            SizedBox(
                              height: Get.height * 0.01,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      textAlign: TextAlign.start,
                                      controller: commentCon,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Add Comment here...',
                                        hintStyle: TextStyle(fontSize: 16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
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
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        if (commentCon.text.isNotEmpty) {
                                          String id = Timestamp.now()
                                              .millisecondsSinceEpoch
                                              .toString();
                                          FBCollections.comments
                                              .doc(id)
                                              .set(CommentM(
                                                      id: postID,
                                                      by: UserData
                                                          .userProfile.uid,
                                                      comment: commentCon.text,
                                                      createdAt:
                                                          Timestamp.now(),
                                                      status: 1)
                                                  .toJson())
                                              .whenComplete(() {
                                            commentCon.clear();
                                          });
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Text required");
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                }
              }));
    }
  }
}
