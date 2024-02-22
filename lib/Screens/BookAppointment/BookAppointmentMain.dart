import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/help.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/message.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/profile.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/profile_detail.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/search.dart';
import 'package:seniors_go_digital/Screens/SeniorScreen/seniorappointment.dart';
import 'package:seniors_go_digital/Widget/AppBar/Drawer.dart';
import 'package:seniors_go_digital/Widget/auth/fetch_data.dart';
import 'package:seniors_go_digital/chat/init_chat.dart';
import 'package:seniors_go_digital/chat/model/chat_room_model.dart';
import 'package:seniors_go_digital/chat/show_appointments.dart';
import 'package:seniors_go_digital/constants/firebase_Collection.dart';
import 'package:seniors_go_digital/constants/user_data.dart';
import 'package:seniors_go_digital/models/userDataModel.dart';

import '../../AppStrings/Textstyle.dart';
import '../../AppStrings/asset_images.dart';

class BookAppointmentMain extends StatefulWidget {
  const BookAppointmentMain({super.key});

  @override
  State<BookAppointmentMain> createState() => _BookAppointmentMainState();
}

class _BookAppointmentMainState extends State<BookAppointmentMain> {
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserProfile? profileProduct;

  @override
  Widget build(BuildContext context) {
    final Query<UserProfile> userQuery = FirebaseFirestore.instance
        .collection('userData')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .withConverter(
          fromFirestore: (snapshot, _) => UserProfile.fromMap(snapshot.data()!),
          toFirestore: (job, _) => job.toMap(),
        );

    final Query<UserProfile> doctorQuery = FirebaseFirestore.instance
        .collection('userData')
        .where("role", isEqualTo: "senior")
        .withConverter(
          fromFirestore: (snapshot, _) => UserProfile.fromMap(snapshot.data()!),
          toFirestore: (job, _) => job.toMap(),
        );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Image.asset(AssetImages.drawerIcon)),
        leadingWidth: 85,
        actions: [
          // IconButton(
          //     onPressed: () {
          //       Navigator.push(
          //           context, MaterialPageRoute(builder: (builder) => Search()));
          //     },
          //     icon: Image.asset(AssetImages.searchIcon)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (builder) => Help()));
              },
              icon: Image.asset(AssetImages.helpIcon)),
        ],
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            children: [
              CustomFirestoreQueryBuilder<UserProfile>(
                  pageSize: 2,
                  widget: Container(),
                  query: userQuery,
                  builder: (builder, snapshot) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.docs.length,
                        itemBuilder: (itemBuilder, index) {
                          profileProduct = snapshot.docs[index].data();

                          return Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 31),
                                child: Text(
                                  "Welcome ${UserData.userProfile.imageUrl}${profileProduct?.name ?? ""}",
                                  style: CustomTextStyles.customTextStyle600,
                                ),
                              ));
                        });
                  }),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(const ShowAppointments());
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 31),
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: Get.width * 0.13),
                    height: Get.height * 0.12,
                    decoration: BoxDecoration(
                        color: const Color(0xFFE8F3FB),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AssetImages.appointIcon,
                          scale: 4,
                          color: Colors.blue,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            StreamBuilder(
                                stream: FBCollections.appointments
                                    .where("query_by",
                                        isEqualTo: UserData.userProfile.email)
                                    .orderBy("created_at", descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return SizedBox();
                                  } else {
                                    return Text(
                                      "${snapshot.data!.docs.length}",
                                      style: CustomTextStyles
                                          .customTextStyle600
                                          .copyWith(
                                              fontSize: Get.width * 0.07,
                                              letterSpacing: 0),
                                    );
                                  }
                                }),
                            Text(
                              "APPOINTMENTS",
                              style: CustomTextStyles.customTextStyle600
                                  .copyWith(
                                fontSize: Get.width * 0.04,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Text(
                      "Available Seniors",
                      style: CustomTextStyles.customTextStyle600,
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              CustomFirestoreQueryBuilder<UserProfile>(
                  pageSize: 5000,
                  query: doctorQuery,
                  builder: (builder, snapshot) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: snapshot.docs.length,
                      itemBuilder: (context, index) {
                        final userProduct = snapshot.docs[index].data();
                        return Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => ProfileDetail(
                                            image: userProduct.imageUrl ?? "",
                                            appointment: userProduct.dateTime ??
                                                Timestamp.fromDate(
                                                    DateTime.now()),
                                            domain: userProduct.domain ?? "",
                                            specialization:
                                                userProduct.specialization ??
                                                    "",
                                            experience:
                                                userProduct.experience ?? "",
                                            name: userProduct.name ?? "",
                                            userProfile: userProduct,
                                          )));
                            },
                            leading: CircleAvatar(
                              backgroundImage: userProduct.imageUrl != null &&
                                      userProduct.imageUrl!.isNotEmpty
                                  ? NetworkImage(userProduct.imageUrl!)
                                      as ImageProvider<Object>
                                  : AssetImage(imagePath[1]),
                              radius: 25,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userProduct.name ?? "",
                                  style: CustomTextStyles.customTextStyle700
                                      .copyWith(fontSize: Get.width * 0.035),
                                ),
                                Text(
                                  "(${userProduct.domain ?? ""})",
                                  style: CustomTextStyles.customTextStyle700
                                      .copyWith(
                                          color: Colors.grey,
                                          fontSize: Get.width * 0.03),
                                ),
                              ],
                            ),
                            subtitle: const Divider(
                              height: 8.0,
                              color: Color(0xFFEEEEEE),
                              thickness: 1.0,
                            ),
                            trailing: InkWell(
                                onTap: () {
                                  InitiateChat(
                                    to: userProduct.email,
                                    by: profileProduct?.email ?? "",
                                    peerId: userProduct.email,
                                  ).now().then((value) {
                                    FBCollections.chatRoom
                                        .doc(value.roomId)
                                        .get()
                                        .then((value) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) => MessageRoom(
                                                    name:
                                                        userProduct.name ?? "",
                                                    assetImage:
                                                        userProduct.imageUrl ??
                                                            "",
                                                    chatRoomModel:
                                                        ChatRoomModel.fromJson(
                                                            value.data()),
                                                    myProfile: profileProduct,
                                                    otherProfile: userProduct,
                                                  )));
                                    });
                                  });
                                },
                                child: Image.asset(
                                  AssetImages.messageIcon2,
                                  scale: 4,
                                  color: Colors.blue,
                                )),
                          ),
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
