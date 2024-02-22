import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniors_go_digital/AppStrings/app_routes.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _controller;
  int selectedIndex = 0;
  bool selected = false;
  int _currentPage = 0;
  PageController pageController = PageController();
  List<IntroDataModel> introData = [
    IntroDataModel("assets/images/icon/consultation.png", "Consultation",
        "You can consult with each other via chatting, and book an appointment for video call consultation"),
    IntroDataModel("assets/images/icon/chatbot.png", "Chat bot",
        "Assists users by providing step-by-step instructions on setting up accounts, connecting with others, and scheduling video calls."),
    IntroDataModel("assets/images/icon/discussion.png", "Discussion forum",
        "A platform where users can engage in conversations, share experiences, and exchange ideas on various topics. It allows users to connect with peers, seek advice, and participate in meaningful discussions")
  ];

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          color: Color(0xFFB5B5B5),
        ),
        margin: const EdgeInsets.only(right: 5),
        height: 10,
        curve: Curves.easeIn,
        width: _currentPage == index ? 30 : 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _controller,
              onPageChanged: (value) => setState(() => _currentPage = value),
              itemCount: introData.length,
              itemBuilder: (context, i) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: Get.height * 0.06),
                      Image.asset("${introData[i].image}",
                          height: Get.height * 0.3),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "${introData[i].title}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: Get.width * 0.06),
                      ),
                      SizedBox(height: Get.height * 0.03),
                      Text(
                        "${introData[i].description}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: Get.width * 0.045),
                      ),
                      SizedBox(
                        height: Get.height * 0.07,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              introData.length,
              (int index) => _buildDots(
                index: index,
              ),
            ),
          ),
          SizedBox(height: Get.height * 0.03),
          _currentPage + 1 == introData.length
              ? SizedBox(
                  height: Get.height * 0.05,
                  width: Get.width * 0.5,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.getStarted);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xFF1273C4),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ))),
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                          color: Colors.white, fontSize: Get.width * 0.04),
                    ),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.05,
                      width: Get.width * 0.5,
                      child: ElevatedButton(
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                          );
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF1273C4),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ))),
                        child: Text(
                          "Next",
                          style: TextStyle(
                              color: Colors.white, fontSize: Get.width * 0.04),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.getStarted);
                      },
                      style: TextButton.styleFrom(
                        elevation: 0,
                        textStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: Get.width * 0.03),
                      ),
                      child: const Text(
                        "SKIP",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
          SizedBox(height: Get.height * 0.05),
        ],
      ),
    );
  }
}

class IntroDataModel {
  String? image;
  String? title;
  String? description;

  IntroDataModel(this.image, this.title, this.description);
}
