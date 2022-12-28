import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Dhyaa/models/task.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/pages/TaskTile.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/widgets/add_task_bar.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/widgets/button.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/widgets/editavilability.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/task_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.parse(DateTime.now().toString());
  // DateTime jHijri = DateTime.parse(JHijri.now().toString());


  final _taskController = Get.put(TaskController());

  // late var notifyHelper;
  bool animate = false;
  double left = 630;
  double top = 900;
  Timer? _timer;

  List<String> repeatList = [
    'الاحد',
    'الاثنين',
    'الثلاثاء',
    'الاربعاء',
    'الخميس',
    'الجمعه',
    'السبت',
  ];
  List<String> repeatList2 = [
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
  ];
  CalendarFormat format =CalendarFormat.month;
  int index = 0;
  final screens = [
    Center(child: Text('uuuuu1u')),
    Center(child: Text('uuuu2uu')),
    Center(child: Text('uuuu3uu')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "اوقاتك المتاحة",
          style: headingTextStyle,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _addTaskBar(),
            _dateBar(),
            const SizedBox(
              height: 12,
            ),
           _showTasks(),
          ],
        ),
      ),
    );
  }

  _dateBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child:
      TableCalendar(
        locale: "ar",
        firstDay: DateTime.now(),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
          calendarFormat: format ,

        onFormatChanged: (CalendarFormat _format){
         setState(() {
           format = _format;
         });
        },
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDate, day);
        },
        onDaySelected: (selectedDay, _focusedDay) {
          setState(() {
            _selectedDate = selectedDay;
            _selectedDate = _focusedDay; // update `_focusedDay` here as well
          });
        },
      ),
      // DatePicker(
      //   locale: "ar",
      //   DateTime.now(),
      //   height: 130,
      //   width: 80,
      //   initialSelectedDate: DateTime.now(),
      //   selectionColor: primaryClr,
      //   //selectedTextColor: primaryClr,
      //   selectedTextColor: Colors.white,
      //   dateTextStyle: GoogleFonts.lato(
      //     textStyle: const TextStyle(
      //       fontSize: 20.0,
      //       fontWeight: FontWeight.w600,
      //       color: Colors.grey,
      //       //   locale: const Locale("ar","AR"),
      //     ),
      //   ),
      //   dayTextStyle: GoogleFonts.lato(
      //     textStyle: const TextStyle(
      //       fontSize: 16.0,
      //       color: Colors.grey,
      //       //  locale: const Locale("ar","AR"),
      //     ),
      //   ),
      //   monthTextStyle: GoogleFonts.lato(
      //     textStyle: const TextStyle(
      //       fontSize: 15.0,
      //       color: Colors.grey,
      //       //  locale: const Locale("ar","AR"),
      //     ),
      //   ),
      //   onDateChange: (date) {
      //     // New date selected
      //     setState(
      //       () {
      //         _selectedDate = date;
      //         print("dedededed" );
      //         print( _selectedDate.toString().substring(0,10));
      //       },
      //     );
      //   },
      // ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyButton(
            label: "+ اضافةاتاحه ",
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTaskPage(),
                ),
              );
              _taskController.getTasks();
            },
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "تاريخ اليوم",
                  style: headingTextStyle,
                ),
                Text(
                  DateFormat('yyyy-MM-dd ').format(DateTime.now()),
                  style: subHeadingTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showTasks() {
    bool i = false;
    return Expanded(
      child: Obx(() {

        // for (int j = 0; j < _taskController.taskList.length; j++) {
        //   print(_taskController.taskList[j].day);
        //   if (_taskController.taskList[j].day ==
        //       (repeatList[(repeatList2.indexOf(
        //           DateFormat('EEEE').format(_selectedDate).toLowerCase()))]))
        //     i = true;
        // }
        // print(i);

        // if (!i) {
        //   return Container(child: Text("لايوجد وقت متاح "));
        // } else {
          return ListView.builder(

              itemCount: _taskController.taskList.length,
              itemBuilder: (_, index) {
                Task task = _taskController.taskList[index];
                // print("task.toJson()");
                int v = (repeatList2.indexOf(
                    DateFormat('EEEE').format(_selectedDate).toLowerCase()));

                 if (( _selectedDate.toString().substring(0,10))==task.day){
              //  if (task.day == repeatList[v]) {
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                          child: FadeInAnimation(
                              child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      print("tapped");
                                      _showBottomSheet(context, task);
                                    },
                                    child: TaskTile(task))
                              ],
                            ),
                          ),
                        ],
                      ))));
                  // } else {
                  //   if (i) {
                  //     print("hi");
                  //     return Container(
                  //       child: Text("hi")
                  //     );
                } else {
                  return Container();
                }
                //   }
              });
      //  }
      }),
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

display(String s) {
  Center(
      child: Text(
    s,
  ));
}
