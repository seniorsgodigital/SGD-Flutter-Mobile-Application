import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentM {
  AppointmentM({
      this.date, 
      this.queryTo, 
      this.subject, 
      this.query, 
      this.queryBy, 
      this.createdAt, 
      this.id, 
      this.status,});

  AppointmentM.fromJson(dynamic json) {
    date = json['date'];
    queryTo = json['query_to'];
    subject = json['subject'];
    query = json['query'];
    queryBy = json['query_by'];
    createdAt = json['created_at'];
    id = json['id'];
    status = json['status'];
  }
  Timestamp? date;
  String? queryTo;
  String? subject;
  String? query;
  String? queryBy;
  Timestamp? createdAt;
  String? id;
  num? status;
AppointmentM copyWith({  Timestamp? date,
  String? queryTo,
  String? subject,
  String? query,
  String? queryBy,
  Timestamp? createdAt,
  String? id,
  num? status,
}) => AppointmentM(  date: date ?? this.date,
  queryTo: queryTo ?? this.queryTo,
  subject: subject ?? this.subject,
  query: query ?? this.query,
  queryBy: queryBy ?? this.queryBy,
  createdAt: createdAt ?? this.createdAt,
  id: id ?? this.id,
  status: status ?? this.status,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = date;
    map['query_to'] = queryTo;
    map['subject'] = subject;
    map['query'] = query;
    map['query_by'] = queryBy;
    map['created_at'] = createdAt;
    map['id'] = id;
    map['status'] = status;
    return map;
  }

}