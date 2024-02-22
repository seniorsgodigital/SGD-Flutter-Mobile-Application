import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniors_go_digital/chat/model/appointment_m.dart';
import 'package:seniors_go_digital/constants/date_formate_service.dart';
import 'package:seniors_go_digital/constants/enum.dart';
import 'package:seniors_go_digital/constants/firebase_Collection.dart';
import 'package:seniors_go_digital/models/userDataModel.dart';

class ShowAppointmentsSeniors extends StatefulWidget {
  const ShowAppointmentsSeniors({super.key});

  @override
  State<ShowAppointmentsSeniors> createState() => _ShowAppointMentsState();
}

class _ShowAppointMentsState extends State<ShowAppointmentsSeniors> {
  Color calculateTextColor(Color backgroundColor) {
    final double relativeLuminance = (0.299 * backgroundColor.red +
            0.587 * backgroundColor.green +
            0.114 * backgroundColor.blue) /
        255;

    return relativeLuminance > 0.5 ? Colors.black : Colors.white;
  }

  UserProfile? product;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> getUserData() async {
    await FBCollections.userData
        .where("email", isEqualTo: _firebaseAuth.currentUser!.email)
        .get()
        .then((value) {
      product =
          UserProfile.fromMap(value.docs.first.data() as Map<String, dynamic>?);
      debugPrint(product!.email);
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
        title: const Text("Appointments",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back,
          color: Colors.black,)),

      ),
      body: product == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: FBCollections.appointments
                  .where("query_to", isEqualTo: product!.email)
                  .orderBy("created_at", descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }
                else if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("Appointment Not Found",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),));
                }
                else {
                  return SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.02,
                          vertical: Get.height * 0.01),
                      child: Column(
                        children:
                            List.generate(snapshot.data!.docs.length, (index) {
                          AppointmentM appointmentM = AppointmentM.fromJson(
                              snapshot.data!.docs[index].data());
                          return showAppointment(appointmentM);
                        }),
                      ),
                    ),
                  );
                }
              }),
    );
  }

  Widget showAppointment(AppointmentM appointmentM) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(.20),spreadRadius: 3,blurRadius: 5)
          ]
      ),
      child: Column(
        children: [
          FutureBuilder(
              future: FBCollections.userData
                  .where("email", isEqualTo: appointmentM.queryBy)
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }else if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Appointment Not Found",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),));
                } else {
                  UserProfile user = UserProfile.fromMap(
                      snapshot.data!.docs.first.data()! as Map<String, dynamic>?);
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor:
                        Colors.red, // Set a transparent background
                        backgroundImage: user.imageUrl!.isNotEmpty
                            ? NetworkImage(
                            user.imageUrl!) // Use the provided image URL
                            : null, // Set to null if no image URL is provided
                        child: user.imageUrl!.isNotEmpty
                            ? null // No child if an image is present
                            : Text(
                          user.name!.isNotEmpty
                              ? user.name!.substring(0, 1).toUpperCase()
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
                            user.name!.toString().capitalizeFirst!,
                            style: TextStyle(
                              color: Colors.black, // Text color
                              fontSize: Get.width * 0.04, // Font size
                              fontStyle: FontStyle.normal, // Font style
                              fontWeight: FontWeight.bold,

                              // Font weight
                            ),
                          ),
                          Text(
                            user.email!,
                            style: TextStyle(
                              color: Colors.black,  // Text color
                              fontSize: Get.width * 0.03, // Font size
                              fontStyle: FontStyle.normal, // Font style
                              fontWeight: FontWeight.w400,
                              // Font weight
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }
              }),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Subject : ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0, // Font size
                  fontStyle: FontStyle.normal, // Font style
                  fontWeight: FontWeight.bold, // Font weight
                ),
              ),
              Container(
                width: Get.width,
                child: Text(
                  "${appointmentM.subject}",
                  style: TextStyle(
                    color: Colors.black,
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
                  color: Colors.black,
                  fontSize: 14.0, // Font size
                  fontStyle: FontStyle.normal, // Font style
                  fontWeight: FontWeight.bold, // Font weight
                ),
              ),
              Container(
                width: Get.width,
                child: Text(
                  "${appointmentM.query}",
                  style: TextStyle(
                    color: Colors.black,
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
                  color: Colors.black,
                  fontSize: 14.0, // Font size
                  fontStyle: FontStyle.normal, // Font style
                  fontWeight: FontWeight.bold, // Font weight
                ),
              ),
              Container(
                width: Get.width,
                child: Text(
                  DateFormatService.dateFormatWithMonthNameTime(appointmentM.date!.toDate()),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0, // Font size
                    fontStyle: FontStyle.normal, // Font style
                    fontWeight: FontWeight.w300, // Font weight
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (appointmentM.status == 0) {
                      FBCollections.appointments
                          .doc(appointmentM.id)
                          .update({
                        "status": AppointmentEnum.cancel.index
                      }).whenComplete(() {
                        appointmentM.status = AppointmentEnum.cancel.index;
                        setState(() {});
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: appointmentButtonColorSender(
                          AppointmentEnum
                              .values[appointmentM.status!.toInt()]),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 5),
                    child: Text(appointmentButtonSender(
                        AppointmentEnum
                            .values[appointmentM.status!.toInt()])),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
