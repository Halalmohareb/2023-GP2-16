import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Dhyaa/models/task.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/controllers/task_controller.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import '../widgets/editavilability.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  TaskTile(this.task);

  final _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
        left: 10,
        right: 10,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(0xff2d99cd),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  task.day,
                  style: TextStyle(
                      fontSize: 16, fontFamily: 'cb', color: Colors.white),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: [
                    Icon(
                      Icons.alarm,
                      color: Colors.grey[200],
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${task.startTime} - ${task.endTime}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[100],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textDirection: TextDirection.ltr,
                  children: [
                    Icon(
                      Icons.create_sharp,
                      color: Colors.grey[200],
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  _getBGClr(int? no) {
    switch (no) {
      case 0:
        return kBlueColor;
      case 1:
        return kOrangeColor;
      case 2:
        return kYellowColor;
      default:
        return kBlueColor;
    }
  }


  showCancelAlert(BuildContext context, Task task) {
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(10),
      titlePadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.all(0),
      insetPadding: EdgeInsets.all(20),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 180,
        child: Column(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 70,
            ),
            SizedBox(height: 10),
            Text('هل انت متأكد من إلغاء موعدك  ؟'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    side: BorderSide(color: kBlueColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('لا، تراجع'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    // doCancel(index);

                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    side: BorderSide(color: kBlueColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('نعم، إلغاء'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    print(task.toJson());
    Get.bottomSheet(
      Container(
          padding: const EdgeInsets.only(top: 4),
          height: MediaQuery.of(context).size.height * 0.32,
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Get.isDarkMode
                          ? Colors.grey[600]
                          : Colors.grey[300])),
              Spacer(),
              _buildBottomSheetButton(
                label: "تعديل الوقت",
                onTap: () async {
                  await Get.to(EditAvilability(
                    editTask: task,
                  ));
                  // _taskController.markTaskCompleted(task.id!);
                  Get.back();
                },
                clr: primaryClr,
                context: context,
              ),
              const SizedBox(
                height: 1,
              ),
              _buildBottomSheetButton(
                label: "حذف الوقت",
                onTap: () {
                  _showBottomdelet(context, task);
                },
                clr: Colors.red[300],
                context: context,
              ),
              const SizedBox(
                height: 10,
              ),
              _buildBottomSheetButton(
                label: "الغاء",
                onTap: () {
                  Get.back();
                },
                clr: Colors.grey,
                isClose: true,
                context: context,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }

  _showBottomdelet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
          padding: const EdgeInsets.only(top: 4),
          height: MediaQuery.of(context).size.height * 0.32,
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 150,
          ),
          child: Column(
            children: [
              Container(
                height: 5,
                width: 30,
              ),
              Text(
                "هل انت متاكد؟",
                style: headingTextStyle,
              ),
              Spacer(),
              const SizedBox(
                height: 1,
              ),
              _buildBottomSheetButton(
                label: "حذف ",
                onTap: () {
                  _taskController.deleteTask(task);
                  Get.back();
                  Get.back();
                },
                clr: Colors.red[300],
                context: context,
              ),
              const SizedBox(
                height: 10,
              ),
              _buildBottomSheetButton(
                label: "الغاء",
                onTap: () {
                  Get.back();
                  Get.back();
                },
                clr: Colors.grey,
                isClose: true,
                context: context,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }

  _buildBottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color? clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          height: 55,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            border: Border.all(
                width: 2,
                color: isClose == true
                    ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                    : clr!),
            borderRadius: BorderRadius.circular(24),
            color: isClose ? Colors.transparent : clr,
          ),
          child: Center(
              child: Text(
                label,
                style: isClose
                    ? titleTextStle
                    : titleTextStle.copyWith(color: Colors.white),
              )),
        ));
  }
}
