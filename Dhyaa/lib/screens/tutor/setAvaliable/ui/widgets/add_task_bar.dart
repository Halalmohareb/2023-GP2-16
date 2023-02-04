import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:Dhyaa/models/task.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/controllers/task_controller.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/widgets/button.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/widgets/input_field.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
//import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  DateTime _selectedDate = DateTime.now();
  // String? _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  //int endday= DateFormat.MMMMEEEEd().format(DateTime.now()).indexOf(",");
  int _selectedColor = 0;
  String? _selectedTimeStart = "1:00";
  String? _selectedTimeEnd = "3:00";
  String? _selectedrepeatday = " مطلقا";
 // String? _selectedRepeat = DateTime.now().toString().substring(0,10);
  DateTime _selectedRepeat = DateTime.now();
  // String? _selectedday = DateFormat.MMMMEEEEd().format(DateTime.now()).substring(0,DateFormat.MMMMEEEEd()
  //  .format(DateTime.now()).indexOf(',')).toLowerCase();
  String? _selectedday = DateFormat.MMMMEEEEd().format(DateTime.now()).substring(0,DateFormat.MMMMEEEEd()
      .format(DateTime.now()).indexOf(',')).toLowerCase();
 // String? _selectedday =  repeatList[(repeatList1.indexOf(_selectedday!))];
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
  final dateController = TextEditingController();
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

  List<String> repeatdayList = [
    'مطلقا',
   ' اسبوعين',
  ' ثلاث اسابيع',
  ' شهر',
 ];
  List<int> repeattimeList = [
    1,
    14,
    21,
    31,
  ];


  DateTime days = DateTime.now();
  int day = DateTime.now().weekday;

  // for (int i= 0; i<7;i++){
  // print(today.add(Duration(days:i)));
  // }
 //int repeatTime = repeattimeList[(repeatdayList.indexOf(_selectedrepeatday))];
  int repeatTime = 1;
  @override
  Widget build(BuildContext context) {
    //Below shows the time like Sep 15, 2021
    //print(new DateFormat.yMMMd().format(new DateTime.now()));
     print( "today");
     print(days.add(Duration(days:1)));
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
          "اضافةاتاحة ",
          style: headingTextStyle,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: InputField(
                        textDirection: TextDirection.RTL,
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
                                        style: const TextStyle(
                                            color: Colors.black54),
                                      ),
                                    );
                                  }).toList()),
                            ),

                            const SizedBox(width: 6),
                          ],
                        ),
                      ),
                    )
                  ]),
                  Row(children: [
                    Expanded(
                      child: InputField(
                        textDirection: TextDirection.RTL,
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
                                        style: const TextStyle(
                                            color: Colors.black54),
                                      ),
                                    );
                                  }).toList()),
                            ),
                            const SizedBox(width: 6),
                          ],
                        ),
                      ),
                    )
                  ]),
                  // InputField(
                  //   textDirection: TextDirection.RTL,
                  //   title: "اليوم",
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
                  //             items: repeatList.map<DropdownMenuItem<String>>(
                  //                 (String value) {
                  //               return DropdownMenuItem<String>(
                  //                 value: value,
                  //                 child: Text(
                  //                   value,
                  //                   style:
                  //                       const TextStyle(color: Colors.black45),
                  //                 ),
                  //               );
                  //             }).toList()),
                  //       ),
                  //       const SizedBox(width: 6),
                  //     ],
                  //   ),
                  // ),
      Container(
        margin: const EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "اليوم",
              style: titleTextStle,
            ),
        Container(
          padding: const EdgeInsets.only(left: 14.0),
          height: 52,

          decoration: BoxDecoration(
              border: Border.all(
                width: 0.6,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(24)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child:
                  TextField(
                   // textDirection:TextDirection.RTL,
                    readOnly: true,
                    controller: dateController,
                    decoration: InputDecoration(
                     // hintTextDirection:TextDirection.RTL,
                    hintText:_selectedRepeat.toString().substring(0,10) ,
                      icon: const Icon(
                      Icons.calendar_month,
                      color: Colors.black54,
                        //  hintTextDirection:TextDirection.RTL,
                    ),

                    ),
                    onTap: () async {
                      var date =  await
                      showDatePicker(
                          context: context,
                          initialDate:DateTime.now(),
                          firstDate:DateTime.now(),
                          lastDate: DateTime(2100),
                          locale: Locale('ar', ''),

                      );
                      dateController.text = date.toString().substring(0,10);
                     // _selectedRepeat = date.toString().substring(0,10);
                      _selectedRepeat = date!;
                      day = _selectedRepeat.weekday;
                      print("it" );
                      print(repeatTime);
                      print(_selectedRepeat.weekday);
                      setState(() {
                        _selectedday = DateFormat.MMMMEEEEd().format( date!).substring(0,DateFormat.MMMMEEEEd()
                            .format( date).indexOf(',')).toLowerCase();

                      });

                    },),),],),),],),),
                  Row(children: [
                    Expanded (
                      child: InputField (
                        textDirection: TextDirection.RTL,
                        title: "تكرار كل يوم "+ repeatList[(repeatList1.indexOf(_selectedday!))]!+" لمده:",
                        hint: _selectedrepeatday,
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
                                      _selectedrepeatday = newValue;
                                      repeatTime = repeattimeList[(repeatdayList.indexOf(_selectedrepeatday!))];
                                      print("it" );
                                      print(repeatTime);
                                    });
                                  },
                                  items: repeatdayList.map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: const TextStyle(
                                                color: Colors.black54),
                                          ),
                                        );
                                      }).toList()),
                            ),
                            const SizedBox(width: 6),
                          ],
                        ),
                      ),
                    )
                  ]),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyButton(
                        label: "اضافة",
                        onTap: () {
                          _validateInputs();
                        },
                      ),
                      //_colorChips(),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_ios, size: 24, color: primaryClr),
      ),
    );
  }

  _validateInputs() async {
    //int repeatTime = repeattimeList[(repeatdayList.indexOf(_selectedrepeatday))];

    for (int i = 0; i < repeatTime; i++) {
      //  print(_selectedRepeat.add(Duration(days: i)));
      print("repeatTime");
      print(repeatTime);
      print(_selectedRepeat.weekday);
      if (i > 0) {
        _selectedRepeat = _selectedRepeat.add(Duration(days: 1));
        print(_selectedRepeat);
      }
      var sameDatExist = false;
      if (day == _selectedRepeat.weekday) {
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
                    element.day == _selectedRepeat.toString().substring(0,10)) {
                  sameDatExist = true;
                } else {
                  //  (timeList.indexOf(_selectedTimeEnd.toString())
                  if ((timeList.indexOf(element.startTime)) <=
                      (timeList.indexOf(_selectedTimeStart.toString())) &&
                      (timeList.indexOf(element.endTime)) >=
                          (timeList.indexOf(_selectedTimeEnd.toString())) &&
                      element.day == _selectedRepeat.toString().substring(0,10)) {
                    sameDatExist = true;
                    // _showBottomwarnning(context, 'تمت اضافة هذا الوقت مسبقا');
                    // Navigator.pop(context);

                  } else {
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

  _addTaskToDB() async {
    await _taskController.addTask(
        task: Task(
            '0',
            0,
            _selectedTimeStart.toString(),
            _selectedTimeStart.toString(),
            _selectedTimeEnd.toString(),
            _selectedColor,
            _selectedRepeat.toString().substring(0,10)));
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: const Text('Time edited Successfully.'),
    // ));
    Navigator.pop(context);
  }

  //   var sameDatExist = false;
  //   await FirestoreHelper.getMyTasks().then((value) {
  //     value.forEach((element) async {
  //       if (element.startTime ==
  //               _selectedTimeStart.toString() +
  //                   "" +
  //                   _selecteddaystart.toString() &&
  //           element.endTime ==
  //               _selectedTimeEnd.toString() + "" + _selecteddayend.toString() &&
  //           element.day == _selectedRepeat.toString()) {
  //         sameDatExist = true;
  //       }
  //     });
  //   });
  //   if (sameDatExist == true) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: const Text('You cannot add same time'),
  //     ));
  //   } else {
  //     await _taskController.addTask(
  //         task: Task(
  //             '0',
  //             0,
  //             _selectedTimeStart.toString(),
  //             _selectedTimeStart.toString() + "" + _selecteddaystart.toString(),
  //             _selectedTimeEnd.toString() + "" + _selecteddayend.toString(),
  //             _selectedColor,
  //             _selectedRepeat.toString()));
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: const Text('Time edited Successfully.'),
  //     ));
  //     Navigator.pop(context);
  //   }
  //

  _colorChips() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "اللون",
        style: titleTextStle,
      ),
      const SizedBox(
        height: 8,
      ),
      Wrap(
        children: List<Widget>.generate(
          3,
          (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  child: index == _selectedColor
                      ? const Center(
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 18,
                          ),
                        )
                      : Container(),
                ),
              ),
            );
          },
        ).toList(),
      ),
    ]);
  }

}
