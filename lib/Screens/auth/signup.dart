import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:seniors_go_digital/AppStrings/Textstyle.dart';
import 'package:seniors_go_digital/AppStrings/app_routes.dart';
import 'package:seniors_go_digital/AppStrings/media_querie_extention.dart';
import 'package:seniors_go_digital/Widget/AppBar/customAppBar.dart';
import 'package:seniors_go_digital/Widget/buton/auth_button.dart';
import 'package:seniors_go_digital/Widget/text_field/signupField.dart';
import 'package:seniors_go_digital/provider/google.dart';
import 'package:seniors_go_digital/provider/myconsumer.dart';
import 'package:seniors_go_digital/provider/seniorLogin.dart';
import 'package:sign_in_button/sign_in_button.dart';

class Signup extends StatefulWidget {
  final String? role;
  const Signup({super.key, this.role});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
// Create controllers and focus nodes for each field
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode cityFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool _isObscured = true; // Initially, the password is obscured
  bool _isObscured1 = true; // Initially, the password is obscured

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
            padding: const EdgeInsets.all(50.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomAppBar(),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Signup',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: context.height * 0.05,
                  ),
                  SignupField(
                    label: "Name",
                    hint: "Enter your name",
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Name is required"),
                      MinLengthValidator(3,
                          errorText: "Minimum 3 character required "),
                    ]),
                    controller: nameController,
                    focusNode: nameFocusNode,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(usernameFocusNode);
                    },
                  ),
                  SignupField(
                    label: "Username",
                    hint: "Enter your user name",
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Username is required"),
                      MinLengthValidator(3,
                          errorText: "Minimum 3 character required "),
                      PatternValidator(
                        r'^(?=.*[a-zA-Z])(?=.*[0-9])',
                        errorText:
                            "Username must contain at least one letter and one number",
                      ),
                    ]),
                    controller: usernameController,
                    focusNode: usernameFocusNode,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(emailFocusNode);
                    },
                  ),
                  SignupField(
                    label: "Email ID",
                    hint: "Enter your Email ID",
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Email is required"),
                      EmailValidator(errorText: "Please enter valid email"),
                    ]),
                    controller: emailController,
                    focusNode: emailFocusNode,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(passwordFocusNode);
                    },
                  ),
                  SignupField(
                    label: "Password",
                    hint: "Enter your Password ",
                    obscure: _isObscured,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Password is required"),
                      MinLengthValidator(6,
                          errorText: "Minimum 6 digit required")
                    ]),
                    prefixWidget: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                        color: Color(0xFF282EC7),
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured =
                              !_isObscured; // Toggle password visibility
                        });
                      },
                    ),
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context)
                          .requestFocus(confirmPasswordFocusNode);
                    },
                  ),
                  SignupField(
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: "Re-enter Password is required"),
                      MinLengthValidator(6,
                          errorText: "Minimum 6 digit required"),
                    ]),
                    label: "Re-enter Password",
                    hint: "Enter your Re-enter Password ",
                    obscure: _isObscured1,
                    prefixWidget: IconButton(
                      icon: Icon(
                        _isObscured1 ? Icons.visibility : Icons.visibility_off,
                        color: Color(0xFF282EC7),
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured1 =
                              !_isObscured1; // Toggle password visibility
                        });
                      },
                    ),
                    controller: confirmPasswordController,
                    focusNode: confirmPasswordFocusNode,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(cityFocusNode);
                    },
                  ),
                  SignupField(
                    label: "City",
                    hint: "Enter your city ",
                    validator: MultiValidator([
                      RequiredValidator(errorText: "City is required"),
                      MinLengthValidator(3,
                          errorText: "Minimum 6 digit required")
                    ]),
                    controller: cityController,
                    focusNode: cityFocusNode,
                    onFieldSubmitted: (value) {},
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyConsumer<LoginLoadingProvider>(builder: (builder, value) {
                    return AuthButton(
                        title:
                            value.isLoading ? "Loading..." : "Create Account",
                        onPressed: () {
                          value.signUpUser(
                            context: context,
                            formKey: _formKey,
                            emailController: emailController,
                            passwordController: passwordController,
                            rePasswordController: confirmPasswordController,
                            nameController: nameController,
                            usernameController: usernameController,
                            cityController: cityController,
                            role: widget.role ?? "",
                          );
                        });
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Or',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SignInButton(Buttons.facebook, text: "Login With Facebook",
                      onPressed: () {
                    if (widget.role == "User") {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.success);
                    } else if (widget.role == "senior") {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.seniorProfile);
                    }
                  }),
                  MyConsumer<GoogleLoginLoading>(builder: (builder, value) {
                    return SignInButton(Buttons.google,
                        text: "Login With Google", onPressed: () {
                      value.signInWithGoogle(context, widget.role ?? "");
                      if (widget.role == "User") {
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.success);
                      } else if (widget.role == "senior") {
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.seniorProfile);
                      }
                    });
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?',
                          style: CustomTextStyles.customTextStyle700),
                      const SizedBox(width: 7),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                        child: const Text('Log In',
                            style: CustomTextStyles.customTextStyle600),
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
