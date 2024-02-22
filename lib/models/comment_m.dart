import 'package:cloud_firestore/cloud_firestore.dart';

class CommentM {
  CommentM({
    this.comment,
    this.by,
    this.createdAt,
    this.status,
    this.id,
  });

  CommentM.fromJson(dynamic json) {
    comment = json['comment'];
    by = json['by'];
    createdAt = json['created_at'];
    status = json['status'];
    id = json['id'];
  }
  String? comment;
  String? by;
  Timestamp? createdAt;
  num? status;
  String? id;
  CommentM copyWith({
    String? comment,
    String? by,
    Timestamp? createdAt,
    num? status,
    String? id,
  }) =>
      CommentM(
        comment: comment ?? this.comment,
        by: by ?? this.by,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
        id: id ?? this.id,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['comment'] = comment;
    map['by'] = by;
    map['created_at'] = createdAt;
    map['status'] = status;
    map['id'] = id;
    return map;
  }
}
