import 'package:flutter/material.dart';
import 'package:Dhyaa/models/task.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/controllers/task_controller.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/widgets/button.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/widgets/input_field.dart';

class MyButton extends StatelessWidget {
  final Function? onTap;
  final String? label;
  final Color? colorr;

  const MyButton({Key? key, required this.label, required this.onTap,required this.colorr})
      : super(key: key);
  //   this.onTap,
  //   this.label,
  // });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        width: 130,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          color: colorr,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            label!,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
