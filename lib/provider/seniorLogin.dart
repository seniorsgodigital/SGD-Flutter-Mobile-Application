import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../AppStrings/utils.dart';
import '../AppStrings/app_routes.dart';
import '../Screens/auth/login.dart';

class LoginLoadingProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Add a method for signing up a user
  Future<void> signUpUser({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController rePasswordController,
    required TextEditingController nameController,
    required TextEditingController usernameController,
    required TextEditingController cityController,
    required String role,
  }) async {
    if (formKey.currentState!.validate()) {
      setLoading(true); // Set loading to true

      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();
      final String confirmPassword = rePasswordController.text.trim();
      final String name = nameController.text.trim();
      final String userName = usernameController.text.trim();
      final String city = cityController.text.trim();
      if (password != confirmPassword) {
        Utils.showErrorMessage("Passwords do not match", context);
        setLoading(false); // Set loading back to false
        return;
      }

      try {
        // Create a Firebase user account
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance.collection("userData")
            .doc(FirebaseAuth.instance.currentUser?.uid).set({
          "dateTime": DateTime.now(),
          "role": role,
          "email": email,
          "name": name,
          "password": password,
          "uid": FirebaseAuth.instance.currentUser?.uid,
          "userName": userName,
          "city": city,
          "id": FirebaseAuth.instance.currentUser?.uid,
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
        Utils.showSuccessMessage("Success", context);

        if (role == "User") {
          Navigator.pushReplacementNamed(context, AppRoutes.success);
        } else if (role == "senior") {
          Navigator.pushReplacementNamed(context, AppRoutes.seniorProfile);
        } else {
          Utils.showErrorMessage("Error", context);
        }
      } catch (error) {
        if (error is FirebaseAuthException && error.code == 'email-already-in-use') {
          // Handle the specific error when email already exists
          Utils.showErrorMessage("Email already exists. Please use a different email.", context);
        } else {
          // Handle other errors
          Utils.showErrorMessage("Error creating user: ${error.toString()}", context);
        }
      } finally {
        setLoading(false);
        // Set loading back to false
      }
    } else {
      Utils.showErrorMessage("Form validation failed", context);
    }
  }

}
