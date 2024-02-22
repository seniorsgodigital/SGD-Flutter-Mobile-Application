import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniors_go_digital/AppStrings/app_routes.dart';
import 'package:seniors_go_digital/AppStrings/utils.dart';
import 'package:seniors_go_digital/Screens/add_Question.dart';
import 'package:seniors_go_digital/Widget/AppBar/customAppBar.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  Future<String?> fetchUserRole(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('userData').doc(userId).get();
      if (userDoc.exists) {
        return userDoc['role']; // Assuming 'role' is the field where the user's role is stored
      }
    } catch (error) {
      print('Error fetching user role: $error');
    }
    return null; // Return null if there's an error or no role found
  }

  @override
  void initState() {
    // TODO: implement initState
    Timer(const Duration(seconds: 5), () async{
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.pushReplacementNamed(context, AppRoutes.getStarted);
      } else {
        // User is authenticated, fetch their role from Firestore
        final role = await fetchUserRole(user.uid);

        if (role == "Admin") {
          Get.offAll(const AddQuestionAdmin());

        }
        else if (role == "User") {
          Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.selectCategory, (Route<dynamic> route) => false);
        } else if (role == "senior") {
          Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.seniorSelectCategory, (Route<dynamic> route) => false);
        } else {
          Utils.showErrorMessage("Error", context);
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(),
        ],
      ),
    );
  }
}
