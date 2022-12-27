import 'package:Dhyaa/models/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/models/task.dart';

UserData emptyUserData = UserData(
    '', '', '', '', '', '', '', '', '', false, false, false, '', '', '', '');

class FirestoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final Future<UserData> _userData = getUserData();

  static Future<UserData> getUserData() async {
    UserData userDataa = emptyUserData;
    await SharedPreferences.getInstance().then((value) async {
      var data = value.getString('user');
      await db
          .collection('Users')
          .where('email', isEqualTo: data)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          UserData userrr = UserData.fromMap(value.docs.first.data());
          userDataa = userrr;
        }
      });
    });
    return userDataa;
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
    UserData userDataa = emptyUserData;
    SharedPreferences value = await SharedPreferences.getInstance();

    var data = value.getString('user');
    await db.collection('Users').where('email', isEqualTo: data).get().then(
      (value) {
        if (value.docs.isNotEmpty) {
          UserData userrr = UserData.fromMap(value.docs.first.data());
          userDataa = userrr;
        }
      },
    );

    return userDataa;
  }

  static Future<bool> updateUserData(id, updateData) async {
    var data = await db.collection('Users').doc(id).update(updateData);
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
            element.data()['degree'],
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
            element.data()['degree'],
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

  // ===============================================
  // Appointment Booking ===== By Hasnain Elahi ====
  // ===============================================

  static Future<Appointment> bookAppointment(Appointment appointment) async {
    var data = await db.collection('appointments').add({
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
        .where('status', isEqualTo: 'Confirmed')
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
        .where('status', isNotEqualTo: 'Confirmed')
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
    var data = await db.collection('appointments').doc(id).update({
      'status': status,
    });
    return true;
  }
}
