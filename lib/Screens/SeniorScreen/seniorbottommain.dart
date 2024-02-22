import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/BookAppointmentMain.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/messageStudent.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/message_home.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/profile.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/user_profile.dart';
import 'package:seniors_go_digital/Screens/SeniorScreen/seniorappointment.dart';
import 'package:seniors_go_digital/constants/providers.dart';

class SeniorBottomNav extends StatefulWidget {
  @override
  _SeniorBottomNavState createState() => _SeniorBottomNavState();
}

class _SeniorBottomNavState extends State<SeniorBottomNav> {
  int _currentIndex = 0;
  final List<Widget> _pages =const [
    SeniorAppointment(),
    MessageHome(),
    Profile(),
  ];
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
    return Scaffold(
      body:    IndexedStack(
        index: _currentIndex,  //Your Current Index
        children: _pages,                       //List Of Pages
      ),
      bottomNavigationBar: SalomonBottomBar(

        selectedItemColor: Colors.black,
        unselectedItemColor: Color(0xFFBCC3C5),
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),

          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.message_outlined),
            title: Text("Messages"),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
          ),
        ],
      ),
    );
  }
}
