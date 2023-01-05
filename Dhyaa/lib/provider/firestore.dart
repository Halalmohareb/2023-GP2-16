import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Dhyaa/models/bookedLesson.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/models/task.dart';

UserData emptyUserData = UserData('', '', '', '', '', '', '', '', '', '', '');

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
            element.data()['address'],
            element.data()['price'],
            element.data()['lessonType'],
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
            element.data()['address'],
            element.data()['price'],
            element.data()['lessonType'],
          ),
        );
      });
    });
    return Future.value(tutors);
  }

  static Future<List<BookedLesson>> getMyBookedList() async {
    List<BookedLesson> details = [];
    var data = await db
        .collection('bookedLessons')
        .where('tutorMail', isEqualTo: 'tutor@gmail.com')
        .orderBy("time", descending: true)
        .get();
    if (data != null) {
      details =
          data.docs.map((document) => BookedLesson.fromMap(document)).toList();
    }
    int i = 0;
    details.forEach((detail) {
      detail.id = data.docs[i].id;
      i++;
    });

    return details;
  }

  static Future<bool> changeBookedLessonStatus(String id, String status) async {
    var data = await db.collection('bookedLessons').doc(id).update({
      'status': status,
    });
    return true;
  }

  static Future<BookedLesson> addNewBookedLesson(
      BookedLesson bookedLesson) async {
    var data = await db.collection('bookedLessons').add({
      'tutorMail': bookedLesson.tutorMail,
      'studentMail': bookedLesson.studentMail,
      'subject': bookedLesson.subject,
      'time': bookedLesson.time,
      'level': bookedLesson.level,
      'status': bookedLesson.status,
      'studentName': bookedLesson.studentName,
      'tutorName': bookedLesson.tutorName,
    });
    return bookedLesson;
  }
}
