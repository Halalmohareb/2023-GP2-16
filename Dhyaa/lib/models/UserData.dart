import 'dart:convert';

import 'package:Dhyaa/constant.dart';

class UserData {
  late String id;
  late String email;
  late String majorSubjects;
  late String degree;
  late String location;
  late String phone;
  late String userId;
  late String username;
  late String type;
  late String address;
  late bool isOnlineLesson;
  late bool isStudentHomeLesson;
  late bool isTutorHomeLesson;
  late String onlineLessonPrice;
  late String studentsHomeLessonPrice;
  late String tutorsHomeLessonPrice;
  late String bio;
  late String avatar;
  late String averageRating;
  late String active_status;

  UserData(
    this.email,
    this.majorSubjects,
    this.degree,
    this.location,
    this.phone,
    this.userId,
    this.username,
    this.type,
    this.address,
    this.isOnlineLesson,
    this.isStudentHomeLesson,
    this.isTutorHomeLesson,
    this.onlineLessonPrice,
    this.studentsHomeLessonPrice,
    this.tutorsHomeLessonPrice,
    this.bio,
    this.avatar,
    this.averageRating,
    this.active_status,
  );
  UserData.fromMap(dynamic obj) {
    userId = obj['userId'];
    username = obj['username'];
    email = obj['email'];
    phone = obj['phone'];
    majorSubjects = obj['majorSubjects'];
    degree = jsonEncode(obj['degree']);
    location = obj['location'];
    type = obj['type'];
    address = obj['address'] ?? '';
    isOnlineLesson = obj['isOnlineLesson'] ?? false;
    isStudentHomeLesson = obj['isStudentHomeLesson'] ?? false;
    isTutorHomeLesson = obj['isTutorHomeLesson'] ?? false;
    onlineLessonPrice = obj['onlineLessonPrice'] ?? '';
    studentsHomeLessonPrice = obj['studentsHomeLessonPrice'] ?? '';
    tutorsHomeLessonPrice = obj['tutorsHomeLessonPrice'] ?? '';
    bio = obj['bio'] ?? '';
    avatar = obj['avatar'] ?? defaultAvatar;
    averageRating = obj['averageRating'] ?? '0.0';
    active_status = obj['active_status'] ?? 'مفعل';
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['email'] = this.email;
      map['majorSubjects'] = this.majorSubjects;
      map['degree'] = jsonDecode(this.degree);
      map['location'] = this.location;
      map['phone'] = this.phone;
      map['userId'] = this.userId;
      map['username'] = this.username;
      map['type'] = this.type;
      map['address'] = this.address;
      map['isOnlineLesson'] = this.isOnlineLesson;
      map['isStudentHomeLesson'] = this.isStudentHomeLesson;
      map['isTutorHomeLesson'] = this.isTutorHomeLesson;
      map['onlineLessonPrice'] = this.onlineLessonPrice;
      map['studentsHomeLessonPrice'] = this.studentsHomeLessonPrice;
      map['tutorsHomeLessonPrice'] = this.tutorsHomeLessonPrice;
      map['bio'] = this.bio;
      map['avatar'] = this.avatar;
      map['averageRating'] = this.averageRating;
      map['active_status'] = this.active_status;
    }
    return map;
  }
}
