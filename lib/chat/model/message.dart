class MessageM {
  MessageM({
      this.receiverId, 
      this.createdAt, 
      this.type,
      this.id,
      this.message, 
      this.senderId, 
      this.seen,});

  MessageM.fromJson(dynamic json) {
    receiverId = json['receiver_id'];
    createdAt = json['created_at'];
    type = json['type'];
    message = json['message'];
    id = json['id'];
    senderId = json['sender_id'];
    seen = json['seen'];
  }
  String? receiverId;
  dynamic createdAt;
  int? type;
  String? message;
  String? id;
  String? senderId;
  bool? seen;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['receiver_id'] = receiverId;
    map['created_at'] = createdAt;
    map['id'] = id;
    map['type'] = type;
    map['message'] = message;
    map['sender_id'] = senderId;
    map['seen'] = seen;
    return map;
  }

}