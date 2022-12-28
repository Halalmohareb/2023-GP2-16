import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Dhyaa/models/task.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/controllers/task_controller.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/db/db_helper.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/widgets/button.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/widgets/input_field.dart';
import 'package:intl/intl.dart';

class EditAvilability extends StatefulWidget {
  const EditAvilability({Key? key, required this.editTask}) : super(key: key);
  final Task? editTask;
  @override
  _EditAvilability createState() => _EditAvilability();
}

class _EditAvilability extends State<EditAvilability> {
  final TaskController _taskController = Get.put(TaskController());

  DateTime _selectedDate = DateTime.now();
  // String? _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  // String? _endTime = "9:30 AM";
  int _selectedColor = 0;
  String? _selectedTimeStart = "1:00";
  String? _selectedTimeEnd = "3:00";
  String? _selectedRepeat = 'الاحد';
  String? _selecteddaystart = 'PM';
  String? _selecteddayend = 'PM';

  List<String> repeatList = [
    'الاحد',
    'الاثنين',
    'الثلاثاء',
    'الاربعاء',
    'الخميس',
    'الجمعه',
    'السبت',
  ];

  List<String> repeatList1 = [
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
  ];

  List<String> timeList = [
    "1:00",
    "2:00",
    "3:00",
    "4:00",
    "5:00",
    "6:00",
    "7:00",
    "8:00",
    "9:00",
    "10:00",
    "11:00",
    "12:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00",
    "19:00",
    "20:00",
    "21:00",
    "22:00",
    "23:00",
    "24:00",
  ];
  List<String> dayList = [
    "PM",
    "AM",
  ];
  @override
  void initState() {
    _selectedTimeStart = widget.editTask!.startTime;
    _selectedTimeEnd = widget.editTask!.endTime;
    _selectedRepeat = widget.editTask!.day;
    _selecteddaystart = widget.editTask!.startTime.contains("AM") ? "AM" : "PM";
    _selecteddayend = widget.editTask!.endTime.contains("AM") ? "AM" : "PM";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Below shows the time like Sep 15, 2021
    //print(new DateFormat.yMMMd().format(new DateTime.now()));
    // print(" starttime " + _startTime!);
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, now.minute, now.second);
    final format = DateFormat.jm();
    print(format.format(dt));
    print("add Task date: " + DateFormat.yMd().format(_selectedDate));
    // _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          //  'Edit Avilability',
          'تحديث الوقت المضاف',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: InputField(
                    textDirection: TextDirection.RTL,
                    //   title: "start time",
                    title: "وقت البداية",
                    hint: _selectedTimeStart,
                    widget: Row(
                      children: [
                        Container(
                          child: DropdownButton<String>(
                              dropdownColor: Colors.white,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                              iconSize: 32,
                              elevation: 4,
                              style: subTitleTextStle,
                              underline: Container(
                                height: 6,
                              ),
                              onChanged: (String? newValue) {
                                print(newValue);
                                setState(() {
                                  _selectedTimeStart = newValue;
                                });
                              },
                              items: timeList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        const TextStyle(color: Colors.black54),
                                  ),
                                );
                              }).toList()),
                        ),
                        const SizedBox(width: 6),
                      ],
                    ),
                  ),
                ),
                // Expanded(
                //   child: InputField(
                //     textDirection: TextDirection.RTL,
                //     title: "PM/AM",
                //     hint: _selecteddaystart,
                //     widget: Row(
                //       children: [
                //         Container(
                //           child: DropdownButton<String>(
                //               dropdownColor: Colors.white,
                //               //value: _selectedRemind.toString(),
                //               icon: const Icon(
                //                 Icons.keyboard_arrow_down,
                //                 color: Colors.grey,
                //               ),
                //               iconSize: 32,
                //               elevation: 4,
                //               style: subTitleTextStle,
                //               underline: Container(
                //                 height: 6,
                //               ),
                //               onChanged: (String? newValue) {
                //                 setState(() {
                //                   _selecteddaystart = newValue;
                //                 });
                //               },
                //               items: dayList.map<DropdownMenuItem<String>>(
                //                   (String value) {
                //                 return DropdownMenuItem<String>(
                //                   value: value,
                //                   child: Text(
                //                     value,
                //                     style:
                //                         const TextStyle(color: Colors.black45),
                //                   ),
                //                 );
                //               }).toList()),
                //         ),
                //         const SizedBox(width: 6),
                //       ],
                //     ),
                //   ),
                // )
              ]),
              Row(children: [
                Expanded(
                  child: InputField(
                    textDirection: TextDirection.RTL,
                    //   title: "end time",
                    title: "وقت النهاية",
                    hint: _selectedTimeEnd,
                    widget: Row(
                      children: [
                        Container(
                          child: DropdownButton<String>(
                              dropdownColor: Colors.white,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                              iconSize: 32,
                              elevation: 4,
                              style: subTitleTextStle,
                              underline: Container(
                                height: 6,
                              ),
                              onChanged: (String? newValue) {
                                print(newValue);
                                setState(() {
                                  _selectedTimeEnd = newValue;
                                });
                              },
                              items: timeList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        const TextStyle(color: Colors.black54),
                                  ),
                                );
                              }).toList()),
                        ),
                        const SizedBox(width: 6),
                      ],
                    ),
                  ),
                ),
                // Expanded(
                //   child: InputField(
                //     textDirection: TextDirection.RTL,
                //     title: "PM/AM",
                //     hint: _selecteddayend,
                //     widget: Row(
                //       children: [
                //         Container(
                //           child: DropdownButton<String>(
                //               dropdownColor: Colors.white,
                //               //value: _selectedRemind.toString(),
                //               icon: const Icon(
                //                 Icons.keyboard_arrow_down,
                //                 color: Colors.grey,
                //               ),
                //               iconSize: 32,
                //               elevation: 4,
                //               style: subTitleTextStle,
                //               underline: Container(
                //                 height: 6,
                //               ),
                //               onChanged: (String? newValue) {
                //                 setState(() {
                //                   _selecteddayend = newValue;
                //                 });
                //               },
                //               items: dayList.map<DropdownMenuItem<String>>(
                //                   (String value) {
                //                 return DropdownMenuItem<String>(
                //                   value: value,
                //                   child: Text(
                //                     value,
                //                     style:
                //                         const TextStyle(color: Colors.black45),
                //                   ),
                //                 );
                //               }).toList()),
                //         ),
                //         const SizedBox(width: 6),
                //       ],
                //     ),
                //   ),
                // )
              ]),
              // InputField(
              //   textDirection: TextDirection.RTL,
              //   title: "day",
              //   hint: _selectedRepeat,
              //   widget: Row(
              //     children: [
              //       Container(
              //         child: DropdownButton<String>(
              //             dropdownColor: Colors.white,
              //             //value: _selectedRemind.toString(),
              //             icon: const Icon(
              //               Icons.keyboard_arrow_down,
              //               color: Colors.grey,
              //             ),
              //             iconSize: 32,
              //             elevation: 4,
              //             style: subTitleTextStle,
              //             underline: Container(
              //               height: 6,
              //             ),
              //             onChanged: (String? newValue) {
              //               setState(() {
              //                 _selectedRepeat = newValue;
              //               });
              //             },
              //             items: repeatList
              //                 .map<DropdownMenuItem<String>>((String value) {
              //               return DropdownMenuItem<String>(
              //                 value: value,
              //                 child: Text(
              //                   value,
              //                   style: const TextStyle(color: Colors.black45),
              //                 ),
              //               );
              //             }).toList()),
              //       ),
              //       const SizedBox(width: 6),
              //     ],
              //   ),
              // ),
              const SizedBox(
                height: 18.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 // _colorChips(),
                  MyButton(
                    //  label: "Edit ",
                    label: "تحديث ",
                    onTap: () {
                      _showBottomdelet(context);
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  _validateInputs() async {
    var sameDatExist = false;
    if (timeList.indexOf(_selectedTimeStart.toString()) >
        timeList.indexOf(_selectedTimeEnd.toString())) {
      _showBottomwarnning(context, 'وقت البداية اكبر من وقت النهايه');
    } else {
      if (timeList
          .indexOf(_selectedTimeStart.toString())
          .isEqual(timeList.indexOf(_selectedTimeEnd.toString()))) {
        _showBottomwarnning(context, 'وقت البداية و وقت النهايه متساوي');
      } else {
        await FirestoreHelper.getMyTasks().then((value) {
          value.forEach((element) async {
            if (element.startTime == _selectedTimeStart.toString() &&
                element.endTime == _selectedTimeEnd.toString() &&
                element.day == _selectedRepeat.toString()) {
              sameDatExist = true;
            } else {
              print(element.id == widget.editTask!.id);
              print(widget.editTask!.id);
              if ((timeList.indexOf(element.startTime)) <=
                      (timeList.indexOf(_selectedTimeStart.toString())) &&
                  (timeList.indexOf(element.endTime)) >=
                      (timeList.indexOf(_selectedTimeEnd.toString())) &&
                  element.id == widget.editTask!.id &&
                  element.day == _selectedRepeat.toString()) {
                sameDatExist = false;
                // _showBottomwarnning(context, 'تمت اضافة هذا الوقت مسبقا');
                // Navigator.pop(context);

              } else {
                if ((timeList.indexOf(element.startTime)) <=
                        (timeList.indexOf(_selectedTimeStart.toString())) &&
                    (timeList.indexOf(element.endTime)) >=
                        (timeList.indexOf(_selectedTimeEnd.toString())) &&
                    element.day == _selectedRepeat.toString()) {
                  sameDatExist = true;
                  // _showBottomwarnning(context, 'تمت اضافة هذا الوقت مسبقا');
                  // Navigator.pop(context);

                } else {
                  // sameDatExist = false;
                }
                //  sameDatExist = false;
              }
            }
          });
        });
        if (sameDatExist == true) {
          _showBottomwarnning(context, 'تمت اضافة هذا الوقت مسبقا');
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: const Text('تمت اضافه الوقت مسبقا'),
          // ));

        } else {
          _addTaskToDB();
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // content: const Text('Data updated successfully'),
          // ));
          // Navigator.pop(context);
        }
      }
    }
  }

  _showBottomwarnning(BuildContext context, String massage) {
    Get.bottomSheet(
      Container(
          padding: const EdgeInsets.only(top: 4),
          height: MediaQuery.of(context).size.height * 0.32,
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          margin: const EdgeInsets.only(
            left: 25,
            right: 25,
            bottom: 150,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 5,
                width: 30,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                massage,
                style: headingTextStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.redAccent,
                  size: 80,
                ),
              ),
              Spacer(),
              const SizedBox(
                height: 1,
              ),
              _buildBottomSheetButton(
                label: "حسنا",
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
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: clr!),
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

  _showBottomdelet(BuildContext context) {
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
                "هل انت متاكد ؟",
                style: headingTextStyle,
              ),
              Spacer(),
              const SizedBox(
                height: 1,
              ),
              _buildBottomSheetButton(
                label: "تحديث ",
                onTap: () {
                  _validateInputs();
                  // Get.back();
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

  _addTaskToDB() async {
    await _taskController.updateTask(
        task: Task(
            widget.editTask!.id,
            0,
            _selectedTimeStart.toString(),
            _selectedTimeStart.toString(),
            _selectedTimeEnd.toString(),
            _selectedColor,
            _selectedRepeat.toString()));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('تم تحديث الوقت بنجاح.'),
    ));
    Navigator.pop(context);
    Navigator.pop(context);
  }

  // _colorChips() {
  //   return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //     Text(
  //       // "Color",
  //       "اللون",
  //       style: titleTextStle,
  //     ),
  //     const SizedBox(
  //       height: 8,
  //     ),
  //     Wrap(
  //       children: List<Widget>.generate(
  //         3,
  //         (int index) {
  //           return GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 _selectedColor = index;
  //               });
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.only(right: 8.0),
  //               child: CircleAvatar(
  //                 radius: 14,
  //                 backgroundColor: index == 0
  //                     ? primaryClr
  //                     : index == 1
  //                         ? pinkClr
  //                         : yellowClr,
  //                 child: index == _selectedColor
  //                     ? const Center(
  //                         child: Icon(
  //                           Icons.done,
  //                           color: Colors.white,
  //                           size: 18,
  //                         ),
  //                       )
  //                     : Container(),
  //               ),
  //             ),
  //           );
  //         },
  //       ).toList(),
  //     ),
  //   ]);
  // }
}
