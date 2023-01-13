import 'dart:convert';
import 'dart:math';

import 'package:Dhyaa/models/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/models/task.dart';

import '../singlton.dart';

UserData emptyUserData = UserData(
    '', '', '', '', '', '', '', '', '', false, false, false, '', '', '', '');

class FirestoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final Future<UserData> _userData = getUserData();

  static Future<UserData> getUserData() async {
    UserData userData = emptyUserData;
    await SharedPreferences.getInstance().then((value) async {
      var data = value.getString('user');
      await db
          .collection('Users')
          .where('email', isEqualTo: data)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          userData = UserData.fromMap(value.docs.first.data());
        }
      });
    });
    return userData;
  }

  static Future<List<Task>> getMyTasks() async {
    List<Task> tasks = [];
    UserData userData = await _userData;
    await db
        .collection('Users')
        .doc(userData.userId)
        .collection('availability')
        .get()
        .then(
      (value) {
        value.docs.forEach(
          (element) {
            element.data()['id'] = element.id;
            tasks.add(
              Task.fromJson(
                element.data(),
              ),
            );
          },
        );
      },
    );
    return tasks;
  }

  static Future<List<Task>> getTutorTasks(UserData user) async {
    List<Task> tasks = [];
    await db
        .collection('Users')
        .doc(user.userId)
        .collection('availability')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.data()['id'] = element.id;
        tasks.add(
          Task.fromJson(
            element.data(),
          ),
        );
      });
    });
    return tasks;
  }

  static Future<UserData> getMyUserData() async {
    UserData userData = emptyUserData;
    SharedPreferences value = await SharedPreferences.getInstance();

    var data = value.getString('user');
    await db.collection('Users').where('email', isEqualTo: data).get().then(
      (value) {
        if (value.docs.isNotEmpty) {
          userData = UserData.fromMap(value.docs.first.data());
        }
      },
    );

    return userData;
  }

  static Future<bool> updateUserData(id, updateData) async {
    await db.collection('Users').doc(id).update(updateData);
    return true;
  }

  static Future<String> getUserType() async {
    String userType = '';
    await SharedPreferences.getInstance().then(
      (value) async {
        var data = value.getString('user');
        if (data != null) {
          await db
              .collection('Users')
              .where('email', isEqualTo: data)
              .get()
              .then(
            (value) {
              if (value.docs.isNotEmpty) {
                userType = value.docs.first.data()['type'];
              }
            },
          );
        }
      },
    );
    return userType;
  }

  static Future<List<UserData>> getTopTutors() async {
    List<UserData> tutors = [];
    await db
        .collection('Users')
        .where("type", isEqualTo: "Tutor")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        tutors.add(
          UserData(
            element.data()['email'],
            element.data()['majorSubjects'],
            jsonEncode(element.data()['degree']),
            element.data()['location'],
            element.data()['phone'],
            element.data()['userId'],
            element.data()['username'],
            element.data()['type'],
            element.data()['address'] ?? '',
            element.data()['isOnlineLesson'] ?? false,
            element.data()['isStudentHomeLesson'] ?? false,
            element.data()['isTutorHomeLesson'] ?? false,
            element.data()['onlineLessonPrice'] ?? '',
            element.data()['studentsHomeLessonPrice'] ?? '',
            element.data()['tutorsHomeLessonPrice'] ?? '',
            element.data()['bio'] ?? '',
          ),
        );
      });
    });
    return tutors;
  }

  static Future<List<UserData>> getTutorUsers() {
    List<UserData> tutors = [];
    db
        .collection('Users')
        .where("type", isEqualTo: "Tutor")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        tutors.add(
          UserData(
            element.data()['email'],
            element.data()['majorSubjects'],
            jsonEncode(element.data()['degree']),
            element.data()['location'],
            element.data()['phone'],
            element.data()['userId'],
            element.data()['username'],
            element.data()['type'],
            element.data()['address'] ?? '',
            element.data()['isOnlineLesson'] ?? false,
            element.data()['isStudentHomeLesson'] ?? false,
            element.data()['isTutorHomeLesson'] ?? false,
            element.data()['onlineLessonPrice'] ?? '',
            element.data()['studentsHomeLessonPrice'] ?? '',
            element.data()['tutorsHomeLessonPrice'] ?? '',
            element.data()['bio'] ?? '',
          ),
        );
      });
    });
    return Future.value(tutors);
  }

  static Future<List> getRecommendedTutors(UserData data) async {
    List<UserData> tutors = [];
    await getAllRecommendedTutors(data).then((response) {
      for (var item in response) {
        tutors.add(item['tutor']);
      }
    });
    return Future.value(tutors);
  }

  static Future getAllRecommendedTutors(UserData user) async {
    List<UserData> tutors = [];
    List temp = [];
    await db
        .collection('Users')
        .where("userId", isNotEqualTo: user.userId)
        .where("type",
            isEqualTo:
                "Tutor") // revoming the tutor its self from the recommendations
        .get()
        .then((value) {
      value.docs.forEach((element) {
        tutors.add(
          UserData(
            element.data()['email'],
            element.data()['majorSubjects'],
            jsonEncode(element.data()['degree']),
            element.data()['location'],
            element.data()['phone'],
            element.data()['userId'],
            element.data()['username'],
            element.data()['type'],
            element.data()['address'] ?? '',
            element.data()['isOnlineLesson'] ?? false,
            element.data()['isStudentHomeLesson'] ?? false,
            element.data()['isTutorHomeLesson'] ?? false,
            element.data()['onlineLessonPrice'] ?? '',
            element.data()['studentsHomeLessonPrice'] ?? '',
            element.data()['tutorsHomeLessonPrice'] ?? '',
            element.data()['bio'] ?? '',
          ),
        );
      });
    });
    tutors.shuffle(); // To make tutors list random
    for (var tutor in tutors) {
      dynamic cosineSimilarity = 0.0;

      double subjectCount = 0.0;
      double locationCount = 0.0;
      double addressCount = 0.0;
      double sessionTypeCount = 0.0;
      double priceCount = 0.0;

      // =============================== Subject ======================
      List userDegree = jsonDecode(user.degree); // active profile tutor
      List itemDegree = jsonDecode(tutor.degree); // compared tutor
      for (var ud in userDegree) {
        for (var it in itemDegree) {
          if (it.toString().toLowerCase() == ud.toString().toLowerCase()) {
            subjectCount = 0.3;
          }
        }
      }
      if (subjectCount != 0.0) {
        // at least one subject has to match
        // =============================== Location/City, Address/Area  ======================
        if (tutor.location == user.location) {
          locationCount = 0.175;
        }

        if (tutor.address == user.address) {
          addressCount = 0.175;
        }

        // =============================== Session type ================================
        if (locationCount == 0.175) {
          if ((tutor.isOnlineLesson == user.isOnlineLesson) &&
              tutor.isOnlineLesson) {
            sessionTypeCount += 0.058;
          } // we want to show the tutors in same city only , if not they give online lessons
          if ((tutor.isStudentHomeLesson == user.isStudentHomeLesson) &&
              tutor.isStudentHomeLesson) {
            sessionTypeCount += 0.058;
          }
          if ((tutor.isTutorHomeLesson == user.isTutorHomeLesson) &&
              tutor.isTutorHomeLesson) {
            sessionTypeCount += 0.058;
          }
        } else {
          if ((tutor.isOnlineLesson == user.isOnlineLesson) &&
              tutor.isOnlineLesson) {
            sessionTypeCount = 0.058;
          }
        }

        // =============================== Price =================================
        // minimum price rates for the current tutor

        var userPriceList = [
          int.parse(
              user.onlineLessonPrice == '' ? '0' : user.onlineLessonPrice),
          int.parse(user.studentsHomeLessonPrice == ''
              ? '0'
              : user.studentsHomeLessonPrice),
          int.parse(user.tutorsHomeLessonPrice == ''
              ? '0'
              : user.tutorsHomeLessonPrice)
        ];
        // excluding (0)
        userPriceList.removeWhere((element) => element == 0);

        // minimum price rates of compared tutor
        var tutorPriceList = [
          int.parse(
              tutor.onlineLessonPrice == '' ? '0' : tutor.onlineLessonPrice),
          int.parse(tutor.studentsHomeLessonPrice == ''
              ? '0'
              : tutor.studentsHomeLessonPrice),
          int.parse(tutor.tutorsHomeLessonPrice == ''
              ? '0'
              : tutor.tutorsHomeLessonPrice)
        ];
        // excluding (0)
        tutorPriceList.removeWhere((element) => element == 0);

        // matching minimum price rates
        if (userPriceList.length > 0 && tutorPriceList.length > 0) {
          if (userPriceList.reduce(min) == tutorPriceList.reduce(min)) {
            priceCount = 0.175;
          }
        }

        // =============================== Cosine Similarity =========================
        // Levels list
        List<double> currentTutor = [0.3, 0.175, 0.175, 0.175, 0.175]; //Vector1
        List<double> iterationTutor = [
          subjectCount,
          locationCount,
          addressCount,
          sessionTypeCount,
          priceCount,
        ]; // Vector2

        // Cosine Similarity algorithm
        cosineSimilarity = await cosineAlgorithm(
            currentTutor, iterationTutor); // sending cs param

        print(
            "UserName is: ${tutor.username} - and - CosineSimilarity is: $cosineSimilarity"); // Testing similarty for each tutor

        // unsorted array
        temp.add({
          'cosineSimilarity': cosineSimilarity,
          'tutor': tutor,
        });
      } 
    } //loop ends 
    // sorting based on Similarity Level
    //https://api.flutter.dev/flutter/dart-core/List/sort.html
    temp.sort((b, a) => a['cosineSimilarity'].compareTo(b[
        'cosineSimilarity'])); // sorting is from most similar (max similarty (1)) to less similar (0)

    // Returning top 5 most similar tutors
    return temp.take(5);
  }

  // Cosine Similarity algorithm
  // https://pub.dev/documentation/document_analysis/latest/document_analysis/cosineDistance.html
  static Future cosineAlgorithm(List<double> a, List<double> b) async {
    double top = 0;
    double bottomA = 0;
    double bottomB = 0;
    int len = min(a.length, b.length);
    for (int i = 0; i < len; i++) {
      top += a[i] * b[i];
      bottomA += a[i] * a[i];
      bottomB += b[i] * b[i];
    }
    double divisor = sqrt(bottomA) * sqrt(bottomB);
    return (divisor != 0 ? (top / divisor) : 0);
  }

  // ===============================================
  //  Booking Lessons
  // ===============================================

 static Future<Appointment> bookAppointment(Appointment appointment) async {
    await db.collection('appointments').add({
      'tutorId': appointment.tutorId,
      'tutorName': appointment.tutorName,
      'studentId': appointment.studentId,
      'studentName': appointment.studentName,
      'degree': appointment.degree,
      'lessonType': appointment.lessonType,
      'date': appointment.date,
      'time': appointment.time,
      'amount': appointment.amount,
      'createdAt':
          DateFormat('yyyy-MM-dd HH:mm:ss').format(appointment.createdAt),
      'status': appointment.status,
      'paymentId': appointment.paymentId,
    });
    return appointment;
  }

  static Future getUpcomingAppointmentList(_key, _value) async {
    List<Appointment> myAppointmentList = [];
    QuerySnapshot<Map<String, dynamic>> value = await db
        .collection('appointments')
        .where(_key, isEqualTo: _value)
        .where('status', isEqualTo: 'مؤكد')
        .get();
    value.docs.forEach((element) {
      myAppointmentList.add(
        Appointment(
          element.id,
          element.data()['tutorId'],
          element.data()['tutorName'],
          element.data()['studentId'],
          element.data()['studentName'],
          element.data()['degree'],
          element.data()['lessonType'],
          element.data()['date'],
          element.data()['time'],
          element.data()['amount'],
          DateTime.parse(element.data()['createdAt']),
          element.data()['status'],
          element.data()['paymentId'],
        ),
      );
    });
    return myAppointmentList;
  }

  static Future getPreviousAppointmentList(_key, _value) async {
    List<Appointment> myAppointmentList = [];
    QuerySnapshot<Map<String, dynamic>> value = await db
        .collection('appointments')
        .where(_key, isEqualTo: _value)
        .where('status', isNotEqualTo: 'مؤكد')
        .get();
    value.docs.forEach((element) {
      myAppointmentList.add(
        Appointment(
          element.id,
          element.data()['tutorId'],
          element.data()['tutorName'],
          element.data()['studentId'],
          element.data()['studentName'],
          element.data()['degree'],
          element.data()['lessonType'],
          element.data()['date'],
          element.data()['time'],
          element.data()['amount'],
          DateTime.parse(element.data()['createdAt']),
          element.data()['status'],
          element.data()['paymentId'],
        ),
      );
    });
    return myAppointmentList;
  }

  static Future<bool> changeAppointmentStatus(String id, String status) async {
    await db.collection('appointments').doc(id).update({
      'status': status,
    });
    return true;
  }

  static Future<bool> isAppointmentExist(timeObj, date, tutorId) async {
    QuerySnapshot<Map<String, dynamic>> value = await db
        .collection('appointments')
        .where('tutorId', isEqualTo: tutorId)
        .where('status', isEqualTo: 'مؤكد')
        .where('date', isEqualTo: date)
        .where('time', arrayContains: timeObj)
        .get();
    return value.docs.isEmpty;
  }
}

