import 'package:flutter/material.dart';
import 'package:seniors_go_digital/AppStrings/Textstyle.dart';
class AppBarTitle extends StatelessWidget {
  final String title;
  final Widget? leadingWidget;
  final Widget? actionWidget;

  const AppBarTitle(
      {super.key, required this.title, this.leadingWidget, this.actionWidget});

  @override
  Widget build(BuildContext context) {
    return  AppBar(
        backgroundColor: Colors.white,
        // Make the background transparent
        elevation: 1,
        // Shadow elevation
        leading: leadingWidget,
        actions: [
          actionWidget ?? Container()
        ],
        shape: const RoundedRectangleBorder(

          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            // Adjust the curve radius as needed
            bottomRight: Radius.circular(
                30.0), // Adjust the curve radius as needed
          ),
        ),
        toolbarHeight: 150,
        // Set the height to 150px
        title: Text(title, style: CustomTextStyles.customTextStyle600),
        centerTitle: true,
      );
  }

}