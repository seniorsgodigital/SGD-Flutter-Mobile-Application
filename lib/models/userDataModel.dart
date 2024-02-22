import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final Timestamp? dateTime;
  final String? role;
  final String? email;
  final String? name;
  final String? password;
  final String? uid;
  final String? userName;
  final String? city;
  final String? id;
  final String? label;
  final String? country;
  final String? gender;
  final String? phone;
  final String? address;
  final String? seniorUserName; // New field
  final String? domain; // New field
  final String? specialization; // New field
  final String? experience; // New field
  final String? seniorPhoneNumber; // New field
  final String? imageUrl; // New field
  final String? cnicUrl; // New field
  final String? documentUrl; // New field
  final String? webUrl; // New field
  UserProfile( {
    this.dateTime,
    this.role,
    this.email,
    this.name,
    this.password,
    this.uid,
    this.userName,
    this.city,
    this.id,
    this.label,
    this.country,
    this.gender,
    this.phone,
    this.address,
    this.seniorUserName,
    this.domain,
    this.specialization,
    this.experience,
    this.seniorPhoneNumber,
    this.imageUrl,
    this.webUrl,
    this.cnicUrl,
    this.documentUrl,
  });

  factory UserProfile.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw ArgumentError("data cannot be null");
    }
    return UserProfile(
      dateTime: data['dateTime'] as Timestamp?,
      role: data['role'] as String?,
      email: data['email'] as String?,
      name: data['name'] as String?,
      password: data['password'] as String?,
      uid: data['uid'] as String?,
      userName: data['userName'] as String?,
      city: data['city'] as String?,
      id: data['id'] as String?,
      label: data['label'] as String?,
      country: data['country'] as String?,
      gender: data['gender'] as String?,
      phone: data['phone'] as String?,
      address: data['Address'] as String?,
      seniorUserName: data['seniorUserName'] as String?, // Map the new fields
      domain: data['domain'] as String?,
      specialization: data['specialization'] as String?,
      experience: data['experience'] as String?,
      seniorPhoneNumber: data['seniorPhoneNumber'] as String?,
      imageUrl: data['imageUrl'] as String?,
      cnicUrl: data['cnicUrl'] as String?,
      documentUrl: data['documentUrl'] as String?,
      webUrl: data['webUrl'] as String?,

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'role': role,
      'email': email,
      'name': name,
      'userName': userName,
      'password': password,
      'uid': uid,
      'city': city,
      'id': id,
      'label': label,
      'country': country,
      'gender': gender,
      'phone': phone,
      'Address': address,
      'seniorUserName': seniorUserName, // Include the new fields in the map
      'domain': domain,
      'specialization': specialization,
      'experience': experience,
      'seniorPhoneNumber': seniorPhoneNumber,
      'imageUrl': imageUrl,
      'cnicUrl': cnicUrl,
      'documentUrl': documentUrl,
      'webUrl':webUrl,
    };
  }
}

