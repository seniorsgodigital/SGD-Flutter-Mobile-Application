import 'package:cloud_firestore/cloud_firestore.dart';

class DiscussionM {
  DiscussionM({
    this.image,
    this.subject,
    this.createdAt,
    this.id,
    this.description,
    this.createdBy,
    this.status,
    this.likes,
  });

  DiscussionM.fromJson(dynamic json) {
    image = json['image'];
    subject = json['subject'];
    createdAt = json['created_at'];
    id = json['id'];
    description = json['description'];
    createdBy = json['created_by'];
    status = json['status'];
    likes = json['likes'];
  }
  String? image;
  String? subject;
  Timestamp? createdAt;
  String? id;
  String? description;
  String? createdBy;
  num? status;
  num? likes;
  DiscussionM copyWith({
    String? image,
    String? subject,
    Timestamp? createdAt,
    String? id,
    String? description,
    String? createdBy,
    num? status,
    num? likes,
  }) =>
      DiscussionM(
        image: image ?? this.image,
        subject: subject ?? this.subject,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        description: description ?? this.description,
        createdBy: createdBy ?? this.createdBy,
        status: status ?? this.status,
        likes: likes ?? this.likes,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = image;
    map['subject'] = subject;
    map['created_at'] = createdAt;
    map['id'] = id;
    map['description'] = description;
    map['created_by'] = createdBy;
    map['status'] = status;
    map['likes'] = likes;
    return map;
  }
}
