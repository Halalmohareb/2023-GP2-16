import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import '../globalWidgets/textWidget/text_widget.dart';
import '../globalWidgets/toast.dart';
import '../models/UserData.dart';
import '../provider/firestore.dart';
import '../responsiveBloc/size_config.dart';
import '../singlton.dart';
import 'package:Dhyaa/theme/theme.dart';
class policy extends StatefulWidget {
  policy({Key? key,}) : super(key: key);
  @override
  State<policy> createState() => _policy();
}

class _policy extends State<policy> {
  Widget build(BuildContext context) {
    var screenWidth = SizeConfig.widthMultiplier;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            margin: EdgeInsets.only(right: 20),
            child: Image.asset(
              'assets/icons/DhyaaLogo.png',
              height: 40,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            //textDirection: TextDirection.rtl,

            children: [
              SizedBox(
                height: 25,
              ),
              Text(
                  "سياسة ضياء للمعلمين والطلاب ",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.normal,
                  )
              ),
              SizedBox(
                height: 40,
              ),

          Text(" لايتم استرجاع المبلغ عند الغاء الدرس قبل أقل من ٢٤ ساعة من-"),
              Text("موعد الدرس"),

          Text("اذا تم الغاء الدرس من قبل المعلم/الطالب أكثر من ثلاث مرات -"),
              Text(" متتالية يحق لضياء ايقاف الحساب "),

              Text("اذا تم استقبال شكاوي او تعليقات سيئة او حصلت على تقييمات-"),
              Text(" سيئة سيتم ايقاف حسابك"),

            ],
          ),
        ),
      ),
    );
  }


}