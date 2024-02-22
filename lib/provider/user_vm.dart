import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seniors_go_digital/Screens/auth/auth_main.dart';
import 'package:seniors_go_digital/constants/user_data.dart';
import 'package:seniors_go_digital/models/userDataModel.dart';
import 'package:seniors_go_digital/services/user_service.dart';

class UserVM extends ChangeNotifier {
  String? selectedCountry;
  String? selectedGender;
  StreamSubscription<UserProfile>? userDataStream;

  void updateCountry(String? country) {
    selectedCountry = country;
    notifyListeners();
  }

  void updateGender(String? gender) {
    selectedGender = gender;
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    debugPrint("fetch user data");
    debugPrint(FirebaseAuth.instance.currentUser!.uid);
    debugPrint("${FirebaseAuth.instance.currentUser!.email}");
    var res =
    await UserServices.streamUsers(FirebaseAuth.instance.currentUser!.uid);
    userDataStream ??= res.listen((event) {
      UserData.userProfile = event;
      notifyListeners();
      Get.forceAppUpdate();
    });
  }

  void onInit() async {
    await fetchUserData();
    notifyListeners();

    // updateFCM();
  }

  Future<String> uploadFile(XFile image) async {
    Reference reference =
    FirebaseStorage.instance.ref().child('Images/queries/${image.name}');
    UploadTask uploadTask = reference.putFile(File(image.path));
    TaskSnapshot snapshot = await uploadTask;
    var imageUrl = await snapshot.ref.getDownloadURL();
    notifyListeners();
    return imageUrl;
  }

  userLogout() async {
    try {

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      await googleSignIn.signOut();
      await _firebaseAuth.signOut();
      userDataStream?.cancel();
      userDataStream = null;
      notifyListeners();
      Get.offAll((const AuthMain()), transition: Transition.leftToRightWithFade);
    } catch (e) {
      Get.offAll((const AuthMain()), transition: Transition.leftToRightWithFade);
    }
  }


}
