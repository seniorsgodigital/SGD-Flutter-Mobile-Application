import 'package:flutter/material.dart';
import 'package:seniors_go_digital/AppStrings/Textstyle.dart';
import 'package:seniors_go_digital/AppStrings/asset_images.dart';
import 'package:seniors_go_digital/AppStrings/media_querie_extention.dart';
import 'package:seniors_go_digital/Widget/AppBar/customAppBar.dart';
import 'package:seniors_go_digital/Widget/buton/auth_button.dart';
import 'package:seniors_go_digital/Widget/text_field/login_field.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../../../AppStrings/app_routes.dart';

class SeniorLogin extends StatefulWidget {
  const SeniorLogin({super.key});

  @override
  State<SeniorLogin> createState() => _SeniorLoginState();
}

class _SeniorLoginState extends State<SeniorLogin> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(47.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomAppBar(),
              SizedBox(height: 10,),
              Text('Login', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30,),),
              SizedBox(height: context.height*0.05,),
LoginField(label: "Email ID",

    hint: "jonny@gmail.com", controller: emailController,
    focusNode: emailFocusNode,
onFieldSubmitted: (value){
  FocusScope.of(context).requestFocus(passwordFocusNode);
},

),
              SizedBox(height: 10,),
              LoginField(
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
                label: "Password",
    hint: "*********",
    controller: passwordController, focusNode: passwordFocusNode,
onFieldSubmitted: (value){
  FocusScope.of(context).unfocus();
},
),
              SizedBox(height: 10,),
              Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                      onTap: (){
Navigator.pushNamed(context, AppRoutes.seniorForgot);
                      },
                      child: Text("Forgot password?",style: CustomTextStyles.customTextStyle600,))),
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
                    Text(
                      "Remember Me",
                      style:CustomTextStyles.customTextStyle700
                    ),
                  ],
                ),
              ),
AuthButton(title: "Login",
    onPressed: (){
      Navigator.pushNamed(context, AppRoutes.seniorProfile);

    }),
              SizedBox(height: 10,),
              Text('Or', style: TextStyle(fontWeight: FontWeight.w600),),
              SignInButton(Buttons.facebook,
                  elevation: 4,
                  text: "Login With Facebook",

                  onPressed: (){
                    Navigator.pushNamed(context, AppRoutes.seniorProfile);
                  }),
              SignInButton(Buttons.google,
                  text: "Login With Google",
                  onPressed: (){

                  }),
              SizedBox(height: 10,),
              //already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const   Text(
                    'Don\'t have an account?',
                    style: CustomTextStyles.customTextStyle700
                  ),
                  const  SizedBox(width: 7),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.seniorSignup);
                    },
                    child:const Text(
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
    );
  }
}
