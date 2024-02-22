import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seniors_go_digital/AppStrings/asset_images.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/privacyPolicy.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/user_profile.dart';
import 'package:seniors_go_digital/Screens/auth/auth_main.dart';
import 'package:seniors_go_digital/Screens/auth/login.dart';
import 'package:seniors_go_digital/constants/providers.dart';

import '../../AppStrings/app_routes.dart';
import '../../models/userDataModel.dart';
import '../auth/fetch_data.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Query<UserProfile> userQuery = FirebaseFirestore.instance
        .collection('userData')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .withConverter(
          fromFirestore: (snapshot, _) => UserProfile.fromMap(snapshot.data()!),
          toFirestore: (job, _) => job.toMap(),
        );
    return Drawer(
      child: Container(
        color: Colors.white, // Change the background color as needed

        child: ListView(
          children: <Widget>[
            Container(
              color: Color(0xFF282EC7).withOpacity(0.19),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Image.asset(
                        AssetImages.crossIcon,
                        height: 70,
                        width: 70,
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Close the drawer
                      },
                    ),
                  ),
                  CustomFirestoreQueryBuilder<UserProfile>(
                      pageSize: 2,
                      widget: Container(),
                      query: userQuery,
                      builder: (builder, snapshot) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.docs.length,
                            itemBuilder: (itemBuilder, index) {
                              final product = snapshot.docs[index].data();
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, bottom: 8.0),
                                child: Column(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 30,
                                      child: Text(
                                        product.name!
                                            .substring(0, 1)
                                            .toUpperCase(),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      product.name ??
                                          "", // Replace with the user's name
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            });
                      }),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const UserProfileScreen()));
                // Handle drawer item tap
              },
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.chat_bubble),
              title: Text('Chatbot'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.chatBot,
                ); // Handle drawer item tap
              },
            ),

            SizedBox(
              height: 10,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.chat_outlined),
              title: Text('Discussion Form'),
              onTap: () {
                Get.back();
                Navigator.pushNamed(
                  context,
                  AppRoutes.discussion,
                );
                // Handle drawer item tap
              },
            ),

            SizedBox(
              height: 10,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacy Policy'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => PrivacyPolicyScreen()));
                // Handle drawer item tap
              },
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('SignOut'),
              onTap: () async {
                MainVM.userVM(context).userLogout();
              },
            ),
            // Add more drawer items as needed
          ],
        ),
      ),
    );
  }
}
