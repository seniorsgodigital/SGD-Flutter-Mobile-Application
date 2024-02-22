import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
class FBCollections
{
  static CollectionReference chatRoom = db.collection("chat");
  static CollectionReference appointments = db.collection("appointments");
  static CollectionReference userData = db.collection("userData");
  static CollectionReference discussions = db.collection("discussion");
  static CollectionReference likes = db.collection("likes");
  static CollectionReference comments = db.collection("comments");
  static CollectionReference qa = db.collection("QA");
  static CollectionReference chat(chatRoomId) => db.collection("chat").doc(chatRoomId).collection("conversation");
}