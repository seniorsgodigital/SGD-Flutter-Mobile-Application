import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seniors_go_digital/AppStrings/Textstyle.dart';
import 'package:seniors_go_digital/AppStrings/app_routes.dart';
import 'package:seniors_go_digital/AppStrings/asset_images.dart';
import 'package:seniors_go_digital/AppStrings/media_querie_extention.dart';
import 'package:seniors_go_digital/Widget/AppBar/customAppBar.dart';
import 'package:timer_count_down/timer_count_down.dart';
class SuccessFull extends StatefulWidget {
  const SuccessFull({super.key});

  @override
  State<SuccessFull> createState() => _SuccessFullState();
}

class _SuccessFullState extends State<SuccessFull> {
  int _secondsLeft = 3;
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
        Navigator.pushReplacementNamed(context, AppRoutes.selectCategory);
      } else {
        setState(() {
          _secondsLeft--;
          _progress = _secondsLeft / 3.0; // Adjust the total time as needed
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(height: context.height*0.04,),
              CustomAppBar(),
              SizedBox(height: context.height*0.03,),
              Image.asset(AssetImages.successIcon,width: 145,height: 145,),
              SizedBox(height: context.height*0.04,),
              Text("Account Created\n\t Successfully!",style: CustomTextStyles.customTextStyle26,),
              SizedBox(height: context.height*0.06,),
              Text("Congratulations, You’re now a part of\n Senior Go Digital! ",
                style: CustomTextStyles.customTextStyle700,),
              SizedBox(height: context.height*0.01,),
             Stack(
               alignment: Alignment.center,
               children: [
                 Image.asset(AssetImages.polygonIcon,
                 ),
                 Container(
                   height: context.height*0.08,
                   width: context.height*0.08,
                   child: CircularProgressIndicator(

                     value: _progress, // The progress value based on time
                     valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF282EC7)), // Unfilled color
                     backgroundColor: Colors.grey, // Filled color
                   ),
                 ),
                 Text(
                   "00:${_secondsLeft.toString().padLeft(2, '0')}",
                   style: CustomTextStyles.customTextStyle600,
                 ),
                 // Countdown(
                 //   seconds: 3, // 3 seconds countdown
                 //   build: (BuildContext context, double time) {
                 //     final seconds = time.toInt();
                 //     final countdownText = seconds == 3
                 //         ? "00:03"
                 //         : seconds == 2
                 //         ? "00:02"
                 //         : seconds == 1
                 //         ? "00:01"
                 //         : "00:00";
                 //     return Text(
                 //       countdownText,
                 //       style: CustomTextStyles.customTextStyle600,
                 //     );
                 //   },
                 //   interval: Duration(milliseconds: 1000),
                 //   onFinished: () {
                 //     Navigator.pushReplacementNamed(context, AppRoutes.selectCategory);
                 //     // Handle countdown completion, e.g., navigate to the next screen
                 //   },
                 // ),
               ],
             ),
            ],
          ),
        ),
      ),
    );
  }
}
