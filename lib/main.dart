import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/BookAppointmentMain.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/bottomnavmain.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/message_home.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/profile.dart';
import 'package:seniors_go_digital/Screens/SeniorScreen/SeniorAuth/forgot.dart';
import 'package:seniors_go_digital/Screens/SeniorScreen/SeniorAuth/getStarted.dart';
import 'package:seniors_go_digital/Screens/SeniorScreen/SeniorAuth/login.dart';
import 'package:seniors_go_digital/Screens/SeniorScreen/SeniorAuth/signup.dart';
import 'package:seniors_go_digital/Screens/auth/auth_main.dart';
import 'package:seniors_go_digital/Screens/auth/getStarted.dart';
import 'package:seniors_go_digital/Screens/auth/success_full.dart';
import 'package:seniors_go_digital/Screens/chatbot/chatbot_main.dart';
import 'package:seniors_go_digital/Screens/discussionPage/discussionPage.dart';
import 'package:seniors_go_digital/Screens/BookAppointment/Home.dart';
import 'package:seniors_go_digital/Screens/splash.dart';
import 'package:seniors_go_digital/agura/create_channel_page.dart';
import 'package:seniors_go_digital/provider/user_vm.dart';
import 'package:seniors_go_digital/provider/cnic.dart';
import 'package:seniors_go_digital/provider/document.dart';
import 'package:seniors_go_digital/provider/google.dart';
import 'package:seniors_go_digital/provider/image_pick.dart';
import 'package:seniors_go_digital/provider/seniorLogin.dart';
import 'package:seniors_go_digital/provider/senior_signup.dart';
import 'AppStrings/app_routes.dart';
import 'Screens/SeniorScreen/seniorbottommain.dart';
import 'Screens/auth/forgot.dart';
import 'Screens/auth/login.dart';
import 'Screens/auth/signup.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (_) => LoginLoadingProvider()),
        ChangeNotifierProvider(create: (_) => SignupLoadingProvider()),
        ChangeNotifierProvider(create: (_) => GoogleLoginLoading()),
        ChangeNotifierProvider(create: (_) => ImagePickerProvider()),
        ChangeNotifierProvider(create: (_) => CNIC()),
        ChangeNotifierProvider(create: (_) => documentPicker()),
        ChangeNotifierProvider(create: (_) => UserVM()),

      ],
      child: GetMaterialApp(
        builder: BotToastInit(), //1. call BotToastInit
        navigatorObservers: [BotToastNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Splash(),
        //home: const CreateChannelPage(),
       // home: const TestingZoom(),
        routes: {
          AppRoutes.signup:(context)=>const Signup(),
          AppRoutes.login:(context)=>const Login(),
          AppRoutes.forgot:(context)=>const Forgot(),
          AppRoutes.splash:(context)=>const Splash(),
          AppRoutes.getStarted:(context)=>const AuthMain(),
          AppRoutes.selectCategory:(context)=>const SelectCategory(),
          AppRoutes.success:(context)=>const SuccessFull(),
          AppRoutes.bookAppointment:(context)=>const BookAppointmentMain(),
          AppRoutes.chatBot:(context)=> ChatBotMain(),
          AppRoutes.discussion:(context)=>const DiscussionPage(),
          AppRoutes.home:(context)=>const HomeNav(),
          AppRoutes.messageHome:(context)=>const MessageHome(),
          AppRoutes.bottomNav:(context)=> BottomNavMain(),


          AppRoutes.seniorProfile:(context)=>const Profile(),
          AppRoutes.seniorSignup:(context)=>const SeniorSignup(),
          AppRoutes.seniorLogin:(context)=>const SeniorLogin(),
          AppRoutes.seniorForgot:(context)=>const SeniorForgot(),
          AppRoutes.seniorSelectCategory:(context)=>const SeniorSelectCategory(),
          AppRoutes.seniorBottomNav:(context)=> SeniorBottomNav(),

          // Add more routes as needed
        },
      ),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}



