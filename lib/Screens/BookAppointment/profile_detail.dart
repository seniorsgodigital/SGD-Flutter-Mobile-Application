import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seniors_go_digital/AppStrings/Textstyle.dart';
import 'package:seniors_go_digital/Widget/buton/auth_button.dart';
import 'package:seniors_go_digital/chat/init_chat.dart';
import 'package:seniors_go_digital/chat/model/chat_room_model.dart';
import 'package:seniors_go_digital/constants/firebase_Collection.dart';
import 'package:seniors_go_digital/constants/user_data.dart';
import 'package:seniors_go_digital/models/userDataModel.dart';

import '../../AppStrings/asset_images.dart';
import 'message.dart';

class ProfileDetail extends StatelessWidget {
  final String image;
  final Timestamp appointment;
  final String domain;
  final String specialization;
  final String experience;
  final String name;
 final UserProfile? userProfile;
  const ProfileDetail({
    Key? key,
    required this.image,
    required this.appointment,
    required this.domain,
    required this.specialization,
    required this.experience,
    required this.name,
    required this.userProfile
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedAppointment =
        DateFormat.yMMMMd('en_US').format(appointment.toDate());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Detail',
          style: CustomTextStyles.customTextStyle26,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture (with fallback to initials)
              CircleAvatar(
                radius: 50,
                backgroundColor:
                    Colors.grey, // Background color when image is null
                child: image.isNotEmpty
                    ? Image.network(
                        image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Text(
                        name
                            .substring(0, 1)
                            .toUpperCase(), // Initials or first letter of the name
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),

              const SizedBox(height: 10), // Spacing

              // User Name
              Text(
                'Full Name:  $name',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5), // Spacing

              // Appointment Date

              const SizedBox(height: 20), // Spacing

              // Domain (if available)
              if (domain.isNotEmpty)
                Text(
                  'Domain: $domain',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),

              // Specialization (if available)
              if (specialization.isNotEmpty)
                Text(
                  'Specialization: $specialization',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),

              // Experience (if available)
              if (experience.isNotEmpty)
                Text(
                  'Experience: $experience',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              AuthButton(
                  title: "Send Message",
                  onPressed: () {
                    InitiateChat(
                      to: userProfile!.email,
                      by: UserData.userProfile.email,
                      peerId: userProfile!.email,
                    ).now().then((value) {
                      FBCollections.chatRoom
                          .doc(value.roomId)
                          .get()
                          .then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) =>
                                    MessageRoom(
                                      name:
                                      userProfile!.name ??
                                          "",
                                      assetImage: userProfile!
                                          .imageUrl ??
                                          "",
                                      chatRoomModel:
                                      ChatRoomModel
                                          .fromJson(value
                                          .data()),
                                      myProfile:
                                      UserData.userProfile,
                                      otherProfile:
                                      userProfile,
                                    )));
                      });
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
