// ignore_for_file: non_constant_identifier_names

class ChatRoomModel {
  ChatRoomModel({
      this.roomId,
      this.createdAt, 
      this.lastMessage, 
      this.createdBy, 
      this.delete, 
      this.users, 
      this.peerId});

  ChatRoomModel.fromJson(dynamic json) {
    roomId = json['room_id'];
    createdAt = json['created_at'];
    lastMessage = json['last_message'] != null ? LastMessage.fromJson(json['last_message']) : null;
    createdBy = json['created_by'];
    if (json['delete'] != null) {
      delete = [];
      json['delete'].forEach((v) {
        delete?.add(Delete.fromJson(v));
      });
    }
    users = json['users'] != null ? json['users'].cast<String>() : [];
    peerId = json['peer_id'];
  }
  String? roomId;
  dynamic createdAt;
  LastMessage? lastMessage;
  String? createdBy;
  List<Delete>? delete;
  List<String>? users;
  String? peerId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['room_id'] = roomId;
    map['created_at'] = createdAt;
    if (lastMessage != null) {
      map['last_message'] = lastMessage?.toJson();
    }
    map['created_by'] = createdBy;
    if (delete != null) {
      map['delete'] = delete?.map((v) => v.toJson()).toList();
    }
    map['users'] = users;
    map['peer_id'] = peerId;
    return map;
  }

}

class Delete {
  Delete({
      this.mesgId, 
      this.email, 
      this.isDelete,});

  Delete.fromJson(dynamic json) {
    mesgId = json['mesg_id'];
    email = json['email'];
    isDelete = json['is_delete'];
  }
  String? mesgId;
  String? email;
  bool? isDelete;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mesg_id'] = mesgId;
    map['email'] = email;
    map['is_delete'] = isDelete;
    return map;
  }

}

class LastMessage {
  LastMessage({
    this.receiverId,
      this.createdAt, 
      this.message, 
      this.type,
    this.senderId,
    this.id,
      this.seen,});

  LastMessage.fromJson(dynamic json) {

    receiverId = json['receiver_id'];
    senderId = json['sender_id'];
    createdAt = json['created_at'];
    message = json['message'];
    type = json['type'];
    id = json['id'];
    seen = json['seen'];
  }
  String? receiverId;
  String? senderId;
  String? id;
  dynamic createdAt;
  String? message;
  int? type;
  bool? seen;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sender_id'] = senderId;
    map['id'] = id;
    map['receiver_id'] = receiverId;
    map['created_at'] = createdAt;
    map['message'] = message;
    map['type'] = type;
    map['seen'] = seen;
    return map;
  }

}