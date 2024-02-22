import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:seniors_go_digital/AppStrings/Textstyle.dart';
import 'package:seniors_go_digital/AppStrings/asset_images.dart';
import 'package:seniors_go_digital/AppStrings/media_querie_extention.dart';
import 'package:seniors_go_digital/AppStrings/utils.dart';
import 'package:seniors_go_digital/Screens/auth/signup.dart';
import 'package:seniors_go_digital/Widget/AppBar/customAppBar.dart';
import 'package:seniors_go_digital/Widget/buton/auth_button.dart';
import 'package:seniors_go_digital/Widget/text_field/login_field.dart';
import 'package:seniors_go_digital/constants/firebase_Collection.dart';
import 'package:seniors_go_digital/provider/google.dart';
import 'package:seniors_go_digital/provider/myconsumer.dart';
import 'package:seniors_go_digital/provider/seniorLogin.dart';
import 'package:seniors_go_digital/provider/senior_signup.dart';
import 'package:sign_in_button/sign_in_button.dart';
import '../../AppStrings/app_routes.dart';

class Login extends StatefulWidget {
  final String? role;
  const Login({super.key, this.role});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool rememberMe = true; // Initial value for the checkbox
// Create TextEditingController for email
  final TextEditingController emailController = TextEditingController();

// Create FocusNode for email
  final FocusNode emailFocusNode = FocusNode();

// Create TextEditingController for password
  final TextEditingController passwordController = TextEditingController();
  bool _isObscured = true; // Initially, the password is obscured
// Create FocusNode for password
  final FocusNode passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  Future<bool> checkIfUserExists(String email, String role) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('userData')
          .where('email', isEqualTo: email)
          .where('role', isEqualTo: role)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle any errors or exceptions that may occur while querying the database.
      print('Error checking if user exists: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(47.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CustomAppBar(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  LoginField(
                    label: "Email ID",
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Email is required"),
                      EmailValidator(errorText: "Please enter valid email"),
                    ]),
                    hint: "jonny@gmail.com",
                    controller: emailController,
                    focusNode: emailFocusNode,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(passwordFocusNode);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  LoginField(
                    obscure: _isObscured,
                    prefixWidget: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF282EC7),
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured =
                              !_isObscured; // Toggle password visibility
                        });
                      },
                    ),
                    label: "Password",
                    hint: "*********",
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Password is required"),
                      MinLengthValidator(6,
                          errorText: "Minimum 6 digit required")
                    ]),
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.forgot);
                          },
                          child: const Text(
                            "Forgot password?",
                            style: CustomTextStyles.customTextStyle600,
                          ))),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.black,
                          value: rememberMe,
                          onChanged: (newValue) {
                            setState(() {
                              rememberMe = newValue!;
                            });
                          },
                        ),
                        const Text("Remember Me",
                            style: CustomTextStyles.customTextStyle700),
                      ],
                    ),
                  ),
                  SizedBox(height: Get.height*0.05,),
                  MyConsumer<SignupLoadingProvider>(builder: (builder, value) {
                    return AuthButton(
                        title: value.isLoading ? "Loading...." : "Login",
                        onPressed: () async {
                          value.signUpUser(
                            context: context,
                            formKey: _formKey,
                            emailController: emailController,
                            passwordController: passwordController,
                            role: widget.role ?? "",
                          );
                        });
                  }),

                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Or',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  // SignInButton(Buttons.facebook,
                  //     elevation: 4, text: "Login With Facebook", onPressed: () {
                  //   if (widget.role == "User") {
                  //     Navigator.pushReplacementNamed(
                  //         context, AppRoutes.selectCategory);
                  //   } else if (widget.role == "senior") {
                  //     Navigator.pushReplacementNamed(
                  //         context, AppRoutes.seniorSelectCategory);
                  //   }
                  // }),

                  MyConsumer<GoogleLoginLoading>(builder: (build, value) {
                    return SignInButton(Buttons.google,
                        text: "Login With Google", onPressed: () {

                      value.signInWithGoogle(context, widget.role ?? "");
                    });
                  }),

                  const SizedBox(
                    height: 10,
                  ),
                  //already have account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?',
                          style: CustomTextStyles.customTextStyle700),
                      const SizedBox(width: 7),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => Signup(
                                        role: widget.role,
                                      )));
                        },
                        child: const Text(
                          'Sign Up',
                          style: CustomTextStyles.customTextStyle600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
