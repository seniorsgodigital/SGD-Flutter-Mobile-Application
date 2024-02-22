import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniors_go_digital/AppStrings/app_routes.dart';
import 'package:seniors_go_digital/AppStrings/asset_images.dart';
import 'package:seniors_go_digital/AppStrings/utils.dart';
import 'package:seniors_go_digital/Screens/add_Question.dart';
import 'package:seniors_go_digital/Screens/auth/auth_main.dart';
import 'package:seniors_go_digital/Screens/onboard_view.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
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
    super.initState();
    Timer(const Duration(seconds: 5), () async{
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.offAll(const OnBoardingScreen());
        //Navigator.pushReplacementNamed(context, AppRoutes.getStarted);
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF57AFEF),
              Color.fromRGBO(70, 66, 253, 0.93),
              Color(0xFF4983F3),
              Color(0xFF1271FF),
            ],
            stops: [-0.0674, 0.1948, 0.5634, 0.9512],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            transform: GradientRotation(2.22), // Adjust the angle as needed
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Image(
                image: AssetImage(AssetImages.logoMain),
                height: 400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

