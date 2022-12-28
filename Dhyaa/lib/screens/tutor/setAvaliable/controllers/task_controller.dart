import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Dhyaa/models/task.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/controllers/task_controller.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/db/db_helper.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/widgets/button.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/widgets/input_field.dart';

class TaskController extends GetxController {
  //this will hold the data and update the ui

  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  final RxList<Task> taskList = List<Task>.empty().obs;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // add data to table
  //second brackets means they are named optional parameters
  Future<void> addTask({required Task task}) async {
    print(task.day);
    await DBHelper.insert(task);
    getTasks();
  }

  // get all the data from table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  Future<void> updateTask({required Task task}) async {
    await DBHelper.update(task);
    getTasks();
  }

  // delete data from table
  void deleteTask(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }
}
