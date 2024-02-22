import 'package:cloud_firestore/cloud_firestore.dart';

class LikeM {
  LikeM({
      this.createdAt, 
      this.id, 
      this.postId, 
      this.by, 
      this.status,});

  LikeM.fromJson(dynamic json) {
    createdAt = json['created_at'];
    id = json['id'];
    postId = json['post_id'];
    by = json['by'];
    status = json['status'];
  }
  Timestamp? createdAt;
  String? id;
  String? postId;
  String? by;
  num? status;
LikeM copyWith({  Timestamp? createdAt,
  String? id,
  String? postId,
  String? by,
  num? status,
}) => LikeM(  createdAt: createdAt ?? this.createdAt,
  id: id ?? this.id,
  postId: postId ?? this.postId,
  by: by ?? this.by,
  status: status ?? this.status,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['created_at'] = createdAt;
    map['id'] = id;
    map['post_id'] = postId;
    map['by'] = by;
    map['status'] = status;
    return map;
  }

}