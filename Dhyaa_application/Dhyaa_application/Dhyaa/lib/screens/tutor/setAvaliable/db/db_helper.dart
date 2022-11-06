import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/models/task.dart';

import '../../../../provider/firestore.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = 'tasks';
  static final Future<UserData> _userData = getUserData();

  static final FirebaseFirestore db = FirebaseFirestore.instance;

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
          print(value.docs.first.data().values);
          UserData userrr = UserData.fromMap(value.docs.first.data());
          userDataa = userrr;
        }
      });
    });
    return userDataa;
  }

  static Future<void> initDb() async {
    if (_db != null) {
      debugPrint("not null db");
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      debugPrint("in database path");
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          debugPrint("creating a new one");
          return db.execute(
            "CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            // "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            " repeat STRING, "
            "color INTEGER, "
            "isCompleted INTEGER)",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task task) async {
    print("insert function called" + task.startTime.toString());
    UserData userDataa = await getUserData();
    try {
      db
          .collection('Users')
          .doc(userDataa.userId)
          .collection('availability')
          .add(task.toJson());
      return 1;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  static Future<int> delete(Task task) async {
    UserData userDataa = await getUserData();
    try {
      db
          .collection('Users')
          .doc(userDataa.userId)
          .collection('availability')
          .doc(task.id.toString())
          .delete();
      return 1;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    UserData userDataa = await getUserData();
    List<Map<String, dynamic>> tasks = [];
    await db
        .collection('Users')
        .doc(userDataa.userId)
        .collection('availability')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        tasks.add(Task(
          element.id,
          element.data()['isCompleted'] ?? 0,
          'date',
          element.data()['startTime'],
          element.data()['endTime'],
          element.data()['color'],
          element.data()['day'],
        ).toJson());
      });
    });
    print(tasks);
    return tasks;
  }

  static Future<int> update(Task task) async {
    print("update function called");
    UserData userDataa = await getUserData();
    print(task.toJson());

    try {
      db
          .collection('Users')
          .doc(userDataa.userId)
          .collection('availability')
          .doc(task.id)
          .update(task.toJson());

      return 1;
    } catch (e) {
      print(e);
      return 0;
    }
  }
}
