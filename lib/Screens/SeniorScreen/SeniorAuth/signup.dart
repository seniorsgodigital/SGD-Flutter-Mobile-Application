import 'package:flutter/material.dart';
import 'package:seniors_go_digital/AppStrings/Textstyle.dart';
import 'package:seniors_go_digital/AppStrings/app_routes.dart';
import 'package:seniors_go_digital/AppStrings/media_querie_extention.dart';
import 'package:seniors_go_digital/Widget/AppBar/customAppBar.dart';
import 'package:seniors_go_digital/Widget/buton/auth_button.dart';
import 'package:seniors_go_digital/Widget/text_field/signupField.dart';
import 'package:sign_in_button/sign_in_button.dart';
class SeniorSignup extends StatefulWidget {
  const SeniorSignup({super.key});

  @override
  State<SeniorSignup> createState() => _SeniorSignupState();
}

class _SeniorSignupState extends State<SeniorSignup> {
// Create controllers and focus nodes for each field
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode cityFocusNode = FocusNode();

  bool _isObscured = true; // Initially, the password is obscured
  bool _isObscured1 = true; // Initially, the password is obscured

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              CustomAppBar(),
              SizedBox(height: 5,),
              Text('Signup', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30,),),
              SizedBox(height: context.height*0.05,),
SignupField(label: "Name", hint: "Enter your name",
    controller: nameController, focusNode: nameFocusNode, onFieldSubmitted: (value){
    FocusScope.of(context).requestFocus(usernameFocusNode);

  },),
              SignupField(label: "Username", hint: "Enter your user name",
                controller: usernameController, focusNode: usernameFocusNode, onFieldSubmitted: (value){
                  FocusScope.of(context).requestFocus(emailFocusNode);

                },),
              SignupField(label: "Email ID", hint: "Enter your Email ID",
                controller: emailController, focusNode: emailFocusNode, onFieldSubmitted: (value){
                  FocusScope.of(context).requestFocus(passwordFocusNode);
                },),
              SignupField(label: "Password", hint: "Enter your Password ",
                obscure: _isObscured,
                prefixWidget: IconButton(
                  icon: Icon(
                    _isObscured
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Color(0xFF282EC7),
                  ),
                  onPressed: (){
                    setState(() {
                      _isObscured = !_isObscured; // Toggle password visibility
                    });
                  },),
                controller: passwordController, focusNode: passwordFocusNode, onFieldSubmitted: (value){
                  FocusScope.of(context).requestFocus(confirmPasswordFocusNode);

                },),
              SignupField(
                label: "Re-enter Password", hint: "Enter your Re-enter Password ",
               obscure: _isObscured1,
                prefixWidget: IconButton(
                  icon: Icon(
                    _isObscured1
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Color(0xFF282EC7),
                  ),
                  onPressed: (){
                    setState(() {
                      _isObscured1 = !_isObscured1; // Toggle password visibility
                    });
                  },),
                controller: confirmPasswordController, focusNode: confirmPasswordFocusNode, onFieldSubmitted: (value){
                  FocusScope.of(context).requestFocus(cityFocusNode);

                },),
              SignupField(label: "City", hint: "Enter your city ",
                controller: cityController, focusNode: cityFocusNode, onFieldSubmitted: (value){

                },),
SizedBox(height: 10,),
AuthButton(title: "Create Account", onPressed: (){
  Navigator.pushNamed(context, AppRoutes.login);
}),
              SizedBox(height: 10,),

              Text('Or', style: TextStyle(fontWeight: FontWeight.w600),),
SignInButton(Buttons.facebook,
    text: "Login With Facebook",
    onPressed: (){
Navigator.pushNamed(context, AppRoutes.seniorProfile);
    }),
              SignInButton(Buttons.google,
                  text: "Login With Google",
                  onPressed: (){
                    Navigator.pushNamed(context, AppRoutes.seniorProfile);
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const   Text(
                    'Already have an account?',
                    style: CustomTextStyles.customTextStyle700
                  ),
                  const  SizedBox(width: 7),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.seniorLogin);
                    },
                    child:const Text(
                      'Log In',
                      style: CustomTextStyles.customTextStyle600
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
