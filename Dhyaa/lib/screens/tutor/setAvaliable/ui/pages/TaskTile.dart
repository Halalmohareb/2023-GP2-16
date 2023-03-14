import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Dhyaa/models/task.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/controllers/task_controller.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/widgets/button.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/widgets/input_field.dart';
import 'package:flutter/src/widgets/basic.dart';

import '../../controllers/task_controller.dart';
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
          color: _getBGClr(task.color),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  task.day!,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'cb',
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
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
                      style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(fontSize: 13, color: Colors.grey[100]),
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
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      default:
        return bluishClr;
    }
  }

  _showBottomSheet(BuildContext context, Task task) {
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
                label: "edit availability",
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
                label: "delete availability",
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
                label: "Close",
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
                "are you sure?",
                style: headingTextStyle,
              ),
              Spacer(),
              const SizedBox(
                height: 1,
              ),
              _buildBottomSheetButton(
                label: "delete ",
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
                label: "cancel",
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
            borderRadius: BorderRadius.circular(20),
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
