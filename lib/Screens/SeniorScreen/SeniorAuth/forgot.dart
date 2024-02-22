import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:seniors_go_digital/AppStrings/Textstyle.dart';
import 'package:seniors_go_digital/Widget/AppBar/customAppBar.dart';
import 'package:seniors_go_digital/Widget/buton/auth_button.dart';

import '../../../AppStrings/utils.dart';
import '../../../Widget/text_field/login_field.dart';
class SeniorForgot extends StatefulWidget {
  const SeniorForgot({super.key});

  @override
  State<SeniorForgot> createState() => _SeniorForgotState();
}

class _SeniorForgotState extends State<SeniorForgot> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                SizedBox(height: 15,),
                Text("Forgot Password?",style: CustomTextStyles.customTextStyle26,),
                SizedBox(height: 15,),
FittedBox(
  child:   Text("No worries, you just need to type your email\n address and "
            "we will send Link for the\n\t\t\t reset password.",style: CustomTextStyles.customTextStyle600,),
),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LoginField(label: "Email ID",
                    validator: MultiValidator(
                        [
                          RequiredValidator(errorText: "Email is required"),
                          EmailValidator(errorText: "Please enter valid email"),
                        ]
                    ),
                    hint: "jonny@gmail.com", controller: emailController,
                    focusNode: emailFocusNode,
                    onFieldSubmitted: (value){

                    },

                  ),
                ),

                AuthButton(title: "Send Email", onPressed: (){
                if(_formKey.currentState!.validate()){
                  try{
                    FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.toString()).then((value){
                      Utils.showSuccessMessage("We have sent email to recover password,please check email", context);
                    }).catchError((e){
                      Utils.showErrorMessage("${e.message}", context);
                    });
                  }
                  catch(e){
                    Utils.showErrorMessage("${e.toString()}", context);
                  }
                }


                           })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
