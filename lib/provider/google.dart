import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seniors_go_digital/constants/providers.dart';
import '../AppStrings/app_routes.dart';
import '../AppStrings/utils.dart';

class GoogleLoginLoading with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signInWithGoogle(BuildContext context, String role) async {
    try {
      setLoading(true); // Set loading to true

      // Show a loading dialog

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      await googleSignIn.signOut();
      await _firebaseAuth.signOut();

      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;

      // Check if the user exists in Firestore
      final userDataSnapshot = await FirebaseFirestore.instance
          .collection("userData")
          .doc(user?.uid)
          .get();

      if (userDataSnapshot.exists) {
        // User data already exists, navigate to the appropriate screen
        if (userDataSnapshot.data()!["role"] == "User") {
         await Navigator.pushReplacementNamed(context, AppRoutes.success);
        } else if (userDataSnapshot.data()!["role"] == "senior") {
        await  Navigator.pushReplacementNamed(context, AppRoutes.seniorProfile);
        }
      } else {
        // User data doesn't exist, store user data in Firestore
        await FirebaseFirestore.instance.collection("userData").doc(user?.uid).set({
          "dateTime": DateTime.now(),
          "role": role,
          "email": user?.email,
          "name": user?.displayName,
          "password": "",
          "uid":user?.uid,
          "userName": "userName",
          "city": "city",
          "id": user?.uid,
          "label": "",
          "country": "",
          "gender": "",
          "phone": "",
          "Address": "",
          // Include the new fields for senior
          'seniorUserName': "",
          'domain': role=="User"?"Student":"",
          'specialization': "",
          'experience': "",
          'seniorPhoneNumber': "",
          'imageUrl': "",
          'cnicUrl': "",
          'documentUrl': "",
          'webUrl': "",
        });
        if (role == "User") {
          Navigator.pushReplacementNamed(context, AppRoutes.success);
        } else if (role == "senior") {
          Navigator.pushReplacementNamed(context, AppRoutes.seniorProfile);
        }
      }

      // Dismiss the loading dialog

    } catch (error) {
      // Handle the error here, e.g., show an error message to the user.

      // Dismiss the loading dialog in case of an error
    } finally {
      setLoading(false); // Set loading back to false
    }
  }
}
