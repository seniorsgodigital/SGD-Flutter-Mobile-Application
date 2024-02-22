// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_zoom_sdk/zoom_options.dart';
// import 'package:flutter_zoom_sdk/zoom_view.dart';
// import 'package:get/get.dart';
// import 'package:seniors_go_digital/modules/zoom_service.dart';
//
// class MeetingMain extends StatefulWidget {
//  final String ?meetingUrl;
//   const MeetingMain({super.key, required this.meetingUrl});
//   @override
//   MeetingMainState createState() => MeetingMainState();
// }
//
// class MeetingMainState extends State<MeetingMain> {
//   TextEditingController meetingIdController = TextEditingController();
//   TextEditingController meetingPasswordController = TextEditingController();
//   Timer ?timer;
//   var formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//
//   joinWithLink() {
//     if (widget.meetingUrl == null) {
//       return;
//     }
//     if (widget.meetingUrl!.isNotEmpty) {
//       try {
//         var meetingCreds = widget.meetingUrl!.split("/").last;
//         String mId = meetingCreds.split("?").first;
//         String pass = meetingCreds.split("?").last.replaceAll("pwd=", "");
//         //print("MEETING ID = $mId");
//         //print("MEETING Pass = $pass");
//         meetingIdController.text = mId;
//         meetingPasswordController.text = pass;
//         loader();
//         ZoomService.joinMeetingWithIdAndPassword(
//             meetingIdController.text, meetingPasswordController.text);
//       } catch (e) {
//         //log(e.toString());
//       }
//     }
//   }
//
//   validator(String v) {
//     if (v.isEmpty) {
//       return "Field is required";
//     } else {
//       return null;
//     }
//   }
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       joinWithLink();
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // new page needs scaffolding!
//
//     var fieldDecoration = InputDecoration(
//       isDense: false,
//       contentPadding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
//       //fillColor: textFieldFill,
//       filled: true,
//       labelText: "Meeting ID",
//       prefixIcon: const Icon(Icons.verified_user_outlined),
//       errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(
//             width: 0.5,
//             color: Colors.red,
//           )),
//       focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(
//             width: 0.5,
//             //color: themeColor,
//           )),
//       enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(
//             width: 1,
//             //color: textFilledBorder2,
//           )),
//       disabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(
//             width: 1,
//             //color: textFilledBorder2,
//           )),
//       focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(
//             width: 0.5,
//             color: Colors.red,
//           )),
//     );
//     return Scaffold(
//       appBar: AppBar(title: const Text("Zoom Meeting"),centerTitle: true,),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(
//           vertical: 8.0,
//           horizontal: 16.0,
//         ),
//         child: Form(
//           key: formKey,
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           child: ListView(
//             padding: EdgeInsets.only(top: Get.height * 0.04),
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 8.0),
//                 child: TextFormField(
//                   controller: meetingIdController,
//                   validator: (v) => validator(v!),
//                   decoration: InputDecoration(
//                     isDense: false,
//                     contentPadding: const EdgeInsets.only(
//                         top: 10, right: 10, left: 10, bottom: 10),
//                   //  fillColor: textFieldFill,
//                     filled: true,
//                     labelText: "Meeting ID",
//                     // hintStyle: stylesPoppin(
//                     //     lightBlack, Get.width * 0.035, FontWeight.normal),
//                     prefixIcon: const Icon(Icons.verified_user_outlined),
//                     errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(
//                           width: 0.5,
//                           color: Colors.red,
//                         )),
//                     focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(
//                           width: 0.5,
//                          // color: themeColor,
//                         )),
//                     enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(
//                           width: 1,
//                           //color: textFilledBorder2,
//                         )),
//                     disabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(
//                           width: 1,
//                          /// color: textFilledBorder2,
//                         )),
//                     focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(
//                           width: 0.5,
//                           color: Colors.red,
//                         )),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 8.0),
//                 child: TextFormField(
//                   controller: meetingPasswordController,
//                   validator: (v) => validator(v!),
//                   decoration: fieldDecoration.copyWith(
//                       labelText: "Meeting Password",
//                       prefixIcon: const Icon(
//                         Icons.vpn_key_outlined,
//                         size: 20,
//                       )),
//                 ),
//               ),
//               SizedBox(
//                 height: Get.height * 0.1,
//               ),
//               _isLoading
//                   ? const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircularProgressIndicator(),
//                       ],
//                     )
//                   : Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: button(
//                               color: Colors.blue,
//                               icon: Icon(
//                                 Icons.add_box_rounded,
//                                 color: Colors.orange,
//                                 size: Get.height * 0.05,
//                               ),
//                               title: "Create Meeting",
//                               onPressed: () {
//                                 // ZoomService.createMeeting(context);
//                                 loader();
//                                 startMeeting(context);
//                                 // startMeetingNormal(context);
//                               }),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: button(
//                               color: Colors.blue,
//                               icon: Icon(
//                                 Icons.photo_camera_front,
//                                 color: Colors.orange,
//                                 size: Get.height * 0.05,
//                               ),
//                               title: "Join Meeting",
//                               onPressed: () {
//                                 // ZoomService.joinMeetingWithIdAndPassword(
//                                 //     meetingIdController.text,
//                                 //     meetingPasswordController.text);
//                                 loader();
//                                 joinMeeting(context);
//                               }),
//                         )
//                       ],
//                     )
//               // Padding(
//               //   padding: const EdgeInsets.all(16.0),
//               //   child: Builder(
//               //     builder: (context) {
//               //       // The basic Material Design action button.
//               //       return ElevatedButton(
//               //         style: ElevatedButton.styleFrom(
//               //           primary: Colors.blue, // background
//               //           onPrimary: Colors.white, // foreground
//               //         ),
//               //         onPressed: () => startMeetingNormal(context),
//               //         child: Text('Start Meeting With Meeting ID'),
//               //       );
//               //     },
//               //   ),
//               // )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget button({Color ?color, Icon? icon, String ?title, Function? onPressed}) {
//     return GestureDetector(
//       onTap: () => onPressed!(),
//       child: Container(
//           // margin: EdgeInsets.symmetric(horizontal: 5),
//           height: Get.width * 0.2,
//           width: Get.width * 0.74,
//           decoration: BoxDecoration(boxShadow: [
//             BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 10)
//           ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   width: Get.width * 0.025,
//                 ),
//                 icon!,
//                 SizedBox(
//                   width: Get.width * 0.08,
//                 ),
//                 Text(
//                   title!,
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//               ],
//             ),
//           )),
//     );
//   }
//
//   loader() {
//     setState(() {
//       _isLoading = true;
//     });
//     Future.delayed(const Duration(seconds: 3), () {
//       setState(() {
//         _isLoading = false;
//       });
//     });
//   }
//
//   startMeeting(BuildContext context) {
//     bool isMeetingEnded(String status) {
//       var result = false;
//
//       if (Platform.isAndroid) {
//         result = status == "MEETING_STATUS_DISCONNECTING" ||
//             status == "MEETING_STATUS_FAILED";
//       } else {
//         result = status == "MEETING_STATUS_IDLE";
//       }
//
//       return result;
//     }
//
//     ZoomOptions zoomOptions = ZoomOptions(
//       domain: "zoom.us",
//       appKey: "XKE4uWfeLwWEmh78YMbC6mqKcF8oM4YHTr9I", //API KEY FROM ZOOM
//       appSecret: "bT7N61pQzaLXU6VLj9TVl7eYuLbqAiB0KAdb", //API SECRET FROM ZOOM
//     );
//     var meetingOptions = ZoomMeetingOptions(
//         userId: 'admin@inlancing.com', //pass host email for zoom
//         userPassword: 'Admin2021!', //pass host password for zoom
//         disableDialIn: "false",
//         disableDrive: "false",
//         disableInvite: "false",
//         disableShare: "false",
//         disableTitlebar: "false",
//         viewOptions: "false",
//         noAudio: "false",
//         noDisconnectAudio: "false");
//
//     var zoom = ZoomView();
//     zoom.initZoom(zoomOptions).then((results) {
//       if (results[0] == 0) {
//         zoom.onMeetingStatus().listen((status) {
//           //print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
//           if (isMeetingEnded(status[0])) {
//             //print("[Meeting Status] :- Ended");
//             timer!.cancel();
//           }
//
//           if (status[0] == "MEETING_STATUS_INMEETING") {
//             zoom.meetinDetails().then((meetingDetailsResult) {
//               //print("[MeetingDetailsResult] :- " +
//               // meetingDetailsResult.toString());
//             });
//           }
//         });
//         zoom.startMeeting(meetingOptions).then((loginResult) {
//           //print("[LoginResult] :- " + loginResult[0] + " - " + loginResult[1]);
//           if (loginResult[0] == "SDK ERROR") {
//             //SDK INIT FAILED
//             //print((loginResult[1]).toString());
//           } else if (loginResult[0] == "LOGIN ERROR") {
//             //LOGIN FAILED - WITH ERROR CODES
//             //print((loginResult[1]).toString());
//           } else {
//             //LOGIN SUCCESS & MEETING STARTED - WITH SUCCESS CODE 200
//             //print((loginResult[0]).toString());
//           }
//         });
//       }
//     }).catchError((error) {
//       //print("[Error Generated] : " + error);
//     });
//   }
//
//   joinMeeting(BuildContext context) {
//     bool isMeetingEnded(String status) {
//       var result = false;
//
//       if (Platform.isAndroid) {
//         result = status == "MEETING_STATUS_DISCONNECTING" ||
//             status == "MEETING_STATUS_FAILED";
//       } else {
//         result = status == "MEETING_STATUS_IDLE";
//       }
//
//       return result;
//     }
//
//     if (meetingIdController.text.isNotEmpty &&
//         meetingPasswordController.text.isNotEmpty) {
//       ZoomOptions zoomOptions = ZoomOptions(
//         domain: "zoom.us",
//         appKey: "XKE4uWfeLwWEmh78YMbC6mqKcF8oM4YHTr9I", //API KEY FROM ZOOM
//         appSecret:
//             "bT7N61pQzaLXU6VLj9TVl7eYuLbqAiB0KAdb", //API SECRET FROM ZOOM
//       );
//       var meetingOptions = ZoomMeetingOptions(
//           userId: 'admin@inlancing.com', //pass host email for zoom
//           userPassword:
//               'Admin2021!', //pass host password for zoom //pass username for join meeting only --- Any name eg:- EVILRATT.
//           meetingId:
//               meetingIdController.text, //pass meeting id for join meeting only
//           meetingPassword: meetingPasswordController
//               .text, //pass meeting password for join meeting only
//           disableDialIn: "true",
//           disableDrive: "true",
//           disableInvite: "true",
//           disableShare: "true",
//           disableTitlebar: "false",
//           viewOptions: "true",
//           noAudio: "false",
//           noDisconnectAudio: "false");
//
//       var zoom = ZoomView();
//       zoom.initZoom(zoomOptions).then((results) {
//         if (results[0] == 0) {
//           zoom.onMeetingStatus().listen((status) {
//             //print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
//             if (isMeetingEnded(status[0])) {
//               //print("[Meeting Status] :- Ended");
//               timer!.cancel();
//             }
//           });
//           //print("listen on event channel");
//           zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
//             timer = Timer.periodic(const Duration(seconds: 2), (timer) {
//               zoom.meetingStatus(meetingOptions.meetingId!).then((status) {
//                 //print("[Meeting Status Polling] : " +
//                 //     status[0] +
//                 //     " - " +
//                 //     status[1]);
//               });
//             });
//           });
//         }
//       }).catchError((error) {
//         //print("[Error Generated] : " + error);
//       });
//     } else {
//       if (meetingIdController.text.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text("Enter a valid meeting id to continue."),
//         ));
//       } else if (meetingPasswordController.text.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text("Enter a meeting password to start."),
//         ));
//       }
//     }
//   }
// }
