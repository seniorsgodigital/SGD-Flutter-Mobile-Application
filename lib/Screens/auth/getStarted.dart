import 'package:flutter/material.dart';
import 'package:seniors_go_digital/AppStrings/Textstyle.dart';
import 'package:seniors_go_digital/AppStrings/app_routes.dart';
import 'package:seniors_go_digital/AppStrings/media_querie_extention.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/Home.dart';
import 'package:seniors_go_digital/Widget/AppBar/customAppBar.dart';
import 'package:seniors_go_digital/Widget/buton/auth_button.dart';
import 'package:seniors_go_digital/constants/providers.dart';

import '../../AppStrings/utils.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  int selectedOption = 0; // Store the selected option's index
  bool _backButtonPressedOnce = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      MainVM.userVM(context).onInit();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if (_backButtonPressedOnce) {
          // If the back button is pressed again, exit the screen
          return true;
        } else {
          // Show a popup message on the first back button press
          Utils.showErrorMessage("Press back again to exit the screen.", context);

          // Set a flag to indicate the back button was pressed once
          _backButtonPressedOnce = true;

          // Prevent exiting the screen
          return false;
        }

      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(38.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: context.height*0.02,),
              CustomAppBar(),
              SizedBox(height: context.height*0.04,),
              Align(
                alignment: Alignment.topLeft,
                child: Text("Get started", style: CustomTextStyles.customTextStyle26),
              ),
              SizedBox(height: context.height * 0.02,),
              Align(
                alignment: Alignment.topLeft,
                child: Text("Please Select", style: CustomTextStyles.customTextStyle600),
              ),
              SizedBox(height: context.height * 0.03,),
              buildRadioButton(0, "Consultation"),
              SizedBox(height: context.height * 0.02,),
              buildRadioButton(1, "Chatbot"),
              SizedBox(height: context.height * 0.02,),
              buildRadioButton(2, "Discussion Forum"),
              SizedBox(height: context.height * 0.02,),
            AuthButton(title: "Continue",
                onPressed: (){
                          navigateToSelectedPage();
                })
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRadioButton(int value, String label) {
    return GestureDetector(
        onTap: () {
          setState(() {
            selectedOption = value;
          });
        },
      child: Container(
        color: Color(0xFFF3F8FF),
        child: Row(
          children: [
            Radio(
              activeColor: Color(0xFF699BF7),
              value: value,
              groupValue: selectedOption,
              onChanged: (newValue) {
                setState(() {
                  selectedOption = newValue ?? 0;
                });
              },
            ),
            SizedBox(width: 12,),
            Text(
              label,
              style: CustomTextStyles.customTextStyle700,
            ),
          ],
        ),
      ),
    );
  }

  void navigateToSelectedPage() {
    switch (selectedOption) {
      case 0:
      // Navigate to the "Book An Appointment" page
        Navigator.pushReplacementNamed(
          context,
    AppRoutes.bottomNav
    );
        break;
      case 1:
      // Navigate to the "Chatbot" page
        Navigator.pushNamed(
          context,
          AppRoutes.chatBot,
        );
        break;
      case 2:
      // Navigate to the "Discussion Forum" page
      // Navigator.push(context, MaterialPageRoute(builder: (builder)=>HomeNav()));
        Navigator.pushNamed(
          context,
         AppRoutes.discussion
        );
        break;
    }
  }
}
