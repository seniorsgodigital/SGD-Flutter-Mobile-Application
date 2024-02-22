import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniors_go_digital/AppStrings/app_routes.dart';
import 'package:seniors_go_digital/constants/firebase_Collection.dart';
import 'package:seniors_go_digital/constants/user_data.dart';
import 'package:seniors_go_digital/models/userDataModel.dart';
import '../../AppStrings/utils.dart';
import '../Screens/add_Question.dart';

class SignupLoadingProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signUpUser({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required String role,
  }) async {
    if (formKey.currentState!.validate()) {
      setLoading(true); // Set loading to true

      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();
      try {
        // Create a Firebase user account
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        FirebaseAuth auth = FirebaseAuth.instance;
       DocumentSnapshot? doc = await FBCollections.userData.doc(auth.currentUser!.uid).get();

       if(doc.exists)
         {
           if (doc["role"] == "Admin") {
             Get.offAll(const AddQuestionAdmin());

           }
           else if (doc["role"] == "User") {
             Navigator.of(context).pushNamedAndRemoveUntil(
                 AppRoutes.selectCategory, (Route<dynamic> route) => false);
           } else if (doc["role"] == "senior") {
             Navigator.of(context).pushNamedAndRemoveUntil(
                 AppRoutes.seniorSelectCategory, (Route<dynamic> route) => false);
           } else {
             Utils.showErrorMessage("Error", context);
           }
         }
      } on FirebaseAuthException catch (error) {
        if (error.code == 'user-not-found') {
          Utils.showErrorMessage(
              "Email not found. Please register first.", context);
        } else if (error.code == 'wrong-password') {
          Utils.showErrorMessage(
              "Incorrect password. Please try again.", context);
        } else {
          Utils.showErrorMessage(
              "Error creating user: ${error.toString()}", context);
        }
      } catch (error) {
        Utils.showErrorMessage(
            "Error creating user: ${error.toString()}", context);
      } finally {
        setLoading(false);
        // Set loading back to false
      }
    } else {
      Utils.showErrorMessage("Form validation failed", context);
    }
  }
}
