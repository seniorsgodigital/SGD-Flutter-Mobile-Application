import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:seniors_go_digital/AppStrings/app_routes.dart';
import 'package:seniors_go_digital/AppStrings/media_querie_extention.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/bottomnavmain.dart';
import 'package:seniors_go_digital/Screens/SeniorScreen/SeniorAuth/getStarted.dart';

import '../../AppStrings/Textstyle.dart';
import '../../AppStrings/asset_images.dart';
class ProfileCheck extends StatefulWidget {
  const ProfileCheck({super.key});

  @override
  State<ProfileCheck> createState() => _ProfileCheckState();
}

class _ProfileCheckState extends State<ProfileCheck> {
  int _secondsLeft = 10;
  double _progress = 1.0;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    const oneSecond = const Duration(seconds: 1);
    Timer.periodic(oneSecond, (Timer timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
Navigator.pushReplacementNamed(context,AppRoutes.seniorSelectCategory);
      } else {
        setState(() {
          _secondsLeft--;
          _progress = _secondsLeft / 10.0; // Adjust the total time as needed
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: OvalBottomBorderClipper(),
    child: Container(
    height: 320,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
    color: Color(0xFFEBF0F0),
    ),
    child: Center(child:              Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(AssetImages.polygonIcon,
            ),
            Container(
              height: context.height*0.08,
              width: context.height*0.08,
              child: CircularProgressIndicator(
strokeWidth: 6,
                value: _progress, // The progress value based on time
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF282EC7)), // Unfilled color
                backgroundColor: Colors.grey, // Filled color
              ),
            ),
            Text(
              "00:${_secondsLeft.toString().padLeft(2, '0')}",
              style: CustomTextStyles.customTextStyle600,
            ),
         
          ],
    ),
    ),
    ),
    ),
          Text("\nChecking! Please wait...\n\n",style: CustomTextStyles.customTextStyle26,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              child: Text("Your account is being checked before getting",style:
                CustomTextStyles.customTextStyle600
                ,),
            ),
          ),
          Center(child: Text("started.",style:
          CustomTextStyles.customTextStyle600
            ,))
          
        ],
      )
    );
  }
}
