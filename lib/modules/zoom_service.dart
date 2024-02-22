// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_zoom_sdk/zoom_options.dart';
// import 'package:flutter_zoom_sdk/zoom_view.dart';
// import 'package:get/get.dart';
// import 'package:seniors_go_digital/constants/user_data.dart';
// import 'package:seniors_go_digital/modules/keys.dart';
//
//
// class ZoomService {
//   static Future<void> joinMeetingWithIdAndPassword(
//       String id, String pass) async {
//     Timer ?timer;
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
//     if (id.isNotEmpty && pass.isNotEmpty) {
//       ZoomOptions zoomOptions = ZoomOptions(
//         domain: "zoom.us",
//         appKey: ZoomKeys.apiKey, //API KEY FROM ZOOM
//         appSecret: ZoomKeys.apiSecret,
//       );
//       var meetingOptions = ZoomMeetingOptions(
//           userId: UserData.userProfile.name,
//           meetingId: id, //pass meeting id for join meeting only
//           meetingPassword: pass, //pass meeting password for join meeting only
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
//             timer = Timer.periodic( const Duration(seconds: 2), (timer) {
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
//       if (id.isEmpty) {
//         ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
//           content: Text("Enter a valid meeting id to continue."),
//         ));
//       } else if (pass.isEmpty) {
//         ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
//           content: Text("Enter a meeting password to start."),
//         ));
//       }
//     }
//   }
//
//   static Future<void> createMeeting(BuildContext context) async {
//     Timer? timer;
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
//       userId: 'admin@seniorgo.com', //pass host email for zoom
//       userPassword: 'Admin2023!', //pass host password for zoom
//       disableDialIn: "false",
//       disableDrive: "false",
//       disableInvite: "false",
//       disableShare: "false",
//       disableTitlebar: "false",
//       viewOptions: "false",
//       noAudio: "false",
//       noDisconnectAudio: "false",
//     );
//
//     var zoom = ZoomView();
//     zoom.initZoom(zoomOptions).then((results) async {
//       if (results[0] == 0) {
//         zoom.onMeetingStatus().listen((status) {
//           //print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
//           if (isMeetingEnded(status[0])) {
//             //print("[Meeting Status] :- Ended");
//             timer!.cancel();
//           }
//           if (status[0] == "MEETING_STATUS_INMEETING") {
//             zoom.meetinDetails().then((meetingDetailsResult) {
//               //print("[MeetingDetailsResult] :- " +
//               //     meetingDetailsResult.toString());
//             });
//           }
//         });
//         var getDetails = await zoom.meetinDetails();
//         //print("details ${getDetails.toString()}");
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
//       //print("[Error Generated] : " + "${error.toString()}");
//     });
//   }
//
//
// }
