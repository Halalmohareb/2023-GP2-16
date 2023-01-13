import 'dart:convert';

import 'package:Dhyaa/_helper/areas.dart';
import 'package:Dhyaa/_helper/cities.dart';
import 'package:Dhyaa/_helper/subject.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart'
    show Fluttertoast, Toast, ToastGravity;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'package:provider/provider.dart';
import 'package:Dhyaa/globalWidgets/appbars/appbar1.dart';
import 'package:Dhyaa/globalWidgets/common_functions/common_function.dart';
import 'package:Dhyaa/globalWidgets/sizedBoxWidget/sized_box_widget.dart';
import 'package:Dhyaa/globalWidgets/textWidget/text_widget.dart';
import 'package:Dhyaa/provider/auth_provider.dart';
import 'package:Dhyaa/responsiveBloc/size_config.dart';
import 'package:Dhyaa/screens/signinMethodScreen/loginScreen/login_screen.dart';
import 'package:Dhyaa/theme/theme.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  var screenWidth = SizeConfig.widthMultiplier;

  bool studentSelected = false;
  bool showTutorPassword = false;
  bool showStudentPassword = false;

  String tutorErrorTextUsername = '';
  String tutorErrorTextEmail = '';
  String tutorErrorTextPassword = '';
  String tutorErrorTextPhoneNumber = '';
  String tutorErrorTextDegree = '';
  String tutorErrorTextMajor = '';
  String tutorErrorTextLocation = '';
  final GlobalKey<FormFieldState> _tutorAddressKey =
      GlobalKey<FormFieldState>();
  String tutorErrorTextAddress = '';
  String tutorErrorTextOnlineLessonPrice = '';
  String tutorErrorTextStudentsHomeLessonPrice = '';
  String tutorErrorTextTutorsHomeLessonPrice = '';

  bool tutorUsernameValid = false;
  bool tutorEmailValid = false;
  bool tutorPasswordValid = false;
  bool tutorPhoneNumberValid = false;
  bool tutorDegreeValid = false;
  bool tutorMajorValid = false;
  bool tutorLocationValid = false;
  bool tutorAddressValid = false;
  bool onlineLessonPriceValid = false;
  bool studentsHomeLessonPriceValid = true;
  bool tutorsHomeLessonPriceValid = true;

  bool tutorAllFieldsValid = false;

  String studentErrorTextUserName = '';
  String studentErrorTextEmail = '';
  String studentErrorTextPassword = '';
  String studentErrorTextPhoneNumber = '';
  String studentErrorTextLocation = '';
  String studentErrorTextAddress = '';
  final GlobalKey<FormFieldState> _studentAddressKey =
      GlobalKey<FormFieldState>();

  bool studentUsernameValid = false;
  bool studentEmailValid = false;
  bool studentPasswordValid = false;
  bool studentPhoneNumberValid = false;
  bool studentLocationValid = false;
  bool studentAddressValid = false;

  bool studentAllFieldsValid = false;

  List values = [];
  var citiesList = [
    "الرياض",
    "جدة",
    "مكة",
    "المدينة",
    "الدمام",
    "الهفوف",
    "الطايف",
    "تبوك",
    "بريدة",
    "خميس مشيط",
    "الجبيل",
    "نجران",
    "المبرز",
    "حائل",
    "أبها",
    "ينبع",
    "عرعر",
    "عنيزة",
    "سكاكا",
    "جازان",
    "القريات",
    "الباحة",
    "بيشة",
    "الرس",
    "الشفا",
  ];
  List areasList = [];

  fieldValidation(AuthProvider authProvider) {
    if (studentSelected) {
      if (studentAllFieldsValid) {
        authProvider.register(context, "Student");
      } else {
        if (!studentUsernameValid) {
          showToast('اسم المستخدم المدخل غير صحيح');
        } else if (!studentEmailValid) {
          showToast('البريد الإلكتروني المدخل غير صحيح');
        } else if (!studentPasswordValid) {
          showToast(
              'يجب أن تحتوي كلمة المرور على 8 أحرف كبيرة وصغيرة وأرقام ورموز');
        } else if (!studentPhoneNumberValid) {
          showToast("الهاتف الذي تم إدخاله غير صحيح");
        } else if (!studentLocationValid) {
          showToast("المدينة التي تم إدخالها غير صحيحة");
        } else if (!studentAddressValid) {
          showToast('العنوان / الحي  المدخل غير صحيح');
        }
      }
    } else {
      if (tutorAllFieldsValid) {
        authProvider.register(context, "Tutor");
      } else {
        if (!tutorUsernameValid) {
          showToast('اسم المستخدم المدخل غير صحيح');
        } else if (!tutorEmailValid) {
          showToast('البريد الإلكتروني المدخل غير صحيح');
        } else if (!tutorPasswordValid) {
          showToast(
              'يجب أن تحتوي كلمة المرور على 8 أحرف كبيرة وصغيرة وأرقام ورموز');
        } else if (!tutorPhoneNumberValid) {
          showToast("الهاتف الذي تم إدخاله غير صحيح");
        } else if (!tutorDegreeValid) {
          showToast('المادة  الذي تم إدخاله غير صحيح');
        } else if (!tutorMajorValid) {
          showToast('التخصص المدخل غير صحيح');
        } else if (!tutorLocationValid) {
          showToast("المدينة التي تم إدخالها غير صحيحة");
        } else if (!tutorAddressValid) {
          showToast('العنوان / الحي  المدخل غير صحيح');
        } else if (!onlineLessonPriceValid ||
            !studentsHomeLessonPriceValid ||
            !tutorsHomeLessonPriceValid) {
          showToast('تأكد من إدخال السعر بشكل صحيح');
        }
      }
    }
  }

  showToast(msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: theme.appBackgroundColor,
      textColor: theme.darkTextColor,
      fontSize: screenWidth * 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.appBackgroundColor,
        appBar: appBar1('إنشاء حساب', screenWidth, context),
        body: Padding(
          padding: EdgeInsets.all(screenWidth * 8).copyWith(top: 0, bottom: 0),
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/DhyaaLogo.png',
                    height: screenWidth * 30,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: screenWidth * 8,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: screenWidth * 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.mainColor),
                      borderRadius: BorderRadius.circular(screenWidth),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            setState(() {
                              studentSelected = false;
                            });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              color: !studentSelected
                                  ? theme.blueColor
                                  : theme.whiteColor,
                              child: text(
                                  'معلم',
                                  screenWidth * 3.2,
                                  !studentSelected
                                      ? theme.whiteColor
                                      : theme.blueColor)),
                        )),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                studentSelected = true;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              color: studentSelected
                                  ? theme.blueColor
                                  : theme.whiteColor,
                              child: text(
                                'طالب',
                                screenWidth * 3.2,
                                studentSelected
                                    ? theme.whiteColor
                                    : theme.blueColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  !studentSelected
                      ? tutorBlock(screenWidth, authProvider)
                      : studentBlock(screenWidth, authProvider),
                  sizedBox(height: screenWidth * 4),
                  authProvider.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.blueColor,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            fieldValidation(authProvider);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin:
                                EdgeInsets.symmetric(vertical: screenWidth * 2)
                                    .copyWith(bottom: screenWidth),
                            padding: EdgeInsets.all(screenWidth * 4.3),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 50),
                                color: theme.blueColor),
                            child: text(
                              ' إنشاء حساب',
                              screenWidth * 3.4,
                              theme.whiteColor,
                            ),
                          ),
                        ),
                  sizedBox(height: screenWidth * 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text('إذا كان لديك حساب مسبقا  ', screenWidth * 3.1,
                          theme.lightTextColor),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: text(
                            'تسجيل الدخول', screenWidth * 3.2, theme.mainColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  sizedBox(height: screenWidth * 4)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget tutorBlock(screenWidth, AuthProvider authProvider) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          sizedBox(height: screenWidth * 4),
          Row(
            children: [
              text('اسم المستخدم', screenWidth * 3, theme.lightTextColor,
                  fontWeight: FontWeight.w500),
            ],
          ),
          sizedBox(height: screenWidth * 3),
          SizedBox(
            height: screenWidth * 12.5,
            width: double.infinity,
            child: TextFormField(
              controller: authProvider.tutorUsername,
              onChanged: (value) {
                setState(() {
                  if (//!authProvider.tutorUsername.text.contains(' ') &&
                      authProvider.tutorUsername.text.isNotEmpty) {
                    tutorUsernameValid = true;
                    tutorErrorTextUsername = '';
                    if (tutorPasswordValid &&
                        tutorEmailValid &&
                        tutorUsernameValid &&
                        tutorPhoneNumberValid &&
                        tutorDegreeValid &&
                        tutorLocationValid &&
                        tutorMajorValid &&
                        tutorAddressValid &&
                        onlineLessonPriceValid &&
                        studentsHomeLessonPriceValid &&
                        tutorsHomeLessonPriceValid) {
                      tutorAllFieldsValid = true;
                    }
                  } else {
                    tutorErrorTextUsername = 'اسم المستخدم غير صحيح';
                    //if (authProvider.tutorUsername.text.contains(' ')) {
                     // tutorErrorTextUsername =
                        //  'اسم المستخدم يجب أن لايحتوي على مسافات';
                   // }
                    tutorUsernameValid = false;
                    tutorAllFieldsValid = false;
                  }
                });
              },
              style: textStyle(screenWidth * 3.7, theme.mainColor),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 4, vertical: screenWidth * 4),
                hintText: 'اسم المستخدم',
                hintStyle: textStyle(screenWidth * 3.3, theme.lightTextColor),
                filled: true,
                fillColor: Colors.white24,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 200),
                    borderSide:
                        BorderSide(width: .3, color: theme.lightTextColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 200),
                    borderSide: BorderSide(
                        width: .6,
                        color: !tutorUsernameValid
                            ? theme.redColor
                            : theme.yellowColor)),
              ),
            ),
          ),
          authProvider.tutorUsername.text.length == 0 || tutorUsernameValid
              ? sizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 1, top: screenWidth * 1),
                  child: Row(
                    children: [
                      text(tutorErrorTextUsername, screenWidth * 2.7,
                          theme.redColor),
                    ],
                  ),
                ),
          sizedBox(height: screenWidth * 4),
          Row(
            children: [
              text('البريد الإلكتروني', screenWidth * 3, theme.lightTextColor,
                  fontWeight: FontWeight.w500),
            ],
          ),
          sizedBox(height: screenWidth * 3),
          SizedBox(
            height: screenWidth * 12.5,
            width: double.infinity,
            child: TextFormField(
              controller: authProvider.tutorEmail,
              onChanged: (value) {
                setState(() {
                  if (authProvider.tutorEmail.text.isNotEmpty &&
                      isEmail(value)
                      // (tutorEmail.text.contains('@gmail.com') ||
                      //     tutorEmail.text.contains('@hotmail.com') ||
                      //     tutorEmail.text.contains('@yahoo.com'))
                      &&
                      !authProvider.tutorEmail.text.contains(' ')) {
                    tutorEmailValid = true;
                    tutorErrorTextEmail = '';
                    if (tutorPasswordValid &&
                        tutorEmailValid &&
                        tutorUsernameValid &&
                        tutorPhoneNumberValid &&
                        tutorDegreeValid &&
                        tutorLocationValid &&
                        tutorMajorValid &&
                        tutorAddressValid &&
                        onlineLessonPriceValid &&
                        studentsHomeLessonPriceValid &&
                        tutorsHomeLessonPriceValid) {
                      tutorAllFieldsValid = true;
                    }
                  } else {
                    tutorErrorTextEmail = 'البريد الإلكتروني غير صحيح';
                    if (authProvider.tutorEmail.text.contains(' ')) {
                      tutorErrorTextEmail =
                          'يجب أن لا يحتوي البريد الإلكتروني على مساحات فارغة';
                    }
                    tutorEmailValid = false;
                    tutorAllFieldsValid = false;
                  }
                });
              },
              style: textStyle(screenWidth * 3.7, theme.mainColor),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 4, vertical: screenWidth * 4),
                hintText: 'abc@domain.com',
                hintStyle: textStyle(screenWidth * 3.3, theme.lightTextColor),
                filled: true,
                fillColor: Colors.white24,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 200),
                    borderSide:
                        BorderSide(width: .3, color: theme.lightTextColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 200),
                    borderSide: BorderSide(
                        width: .6,
                        color: !tutorEmailValid
                            ? theme.redColor
                            : theme.yellowColor)),
              ),
            ),
          ),
          authProvider.tutorEmail.text.length == 0 || tutorEmailValid
              ? sizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 1, top: screenWidth * 1),
                  child: Row(
                    children: [
                      text(tutorErrorTextEmail, screenWidth * 2.7,
                          theme.redColor),
                    ],
                  ),
                ),
          sizedBox(height: screenWidth * 4),
          Row(
            children: [
              text('كلمة المرور', screenWidth * 3, theme.lightTextColor,
                  fontWeight: FontWeight.w500),
            ],
          ),
          sizedBox(height: screenWidth * 3),
          SizedBox(
            height: screenWidth * 12.5,
            width: double.infinity,
            child: TextFormField(
              controller: authProvider.tutorPassword,
              onChanged: (value) {
                setState(() {
                  if (authProvider.tutorPassword.text.length > 7 &&
                      !authProvider.tutorPassword.text.contains(' ') &&
                      validatePassword(value)) {
                    tutorPasswordValid = true;
                    tutorErrorTextPassword = '';
                    if (tutorPasswordValid &&
                        tutorEmailValid &&
                        tutorUsernameValid &&
                        tutorPhoneNumberValid &&
                        tutorDegreeValid &&
                        tutorLocationValid &&
                        tutorMajorValid &&
                        tutorAddressValid &&
                        onlineLessonPriceValid &&
                        studentsHomeLessonPriceValid &&
                        tutorsHomeLessonPriceValid) {
                      tutorAllFieldsValid = true;
                    }
                  } else {
                    tutorErrorTextPassword =
                        'يجب أن تحتوي كلمة المرور على 8 أحرف كبيرة وصغيرة وأرقام ورموز';
                    if (authProvider.tutorPassword.text.contains(' ')) {
                      tutorErrorTextPassword =
                          'يجب أن لا تحتوي كلمة المرور على مسافات';
                    }
                    tutorPasswordValid = false;
                    tutorAllFieldsValid = false;
                  }
                });
              },
              obscureText: showTutorPassword ? false : true,
              style: textStyle(screenWidth * 3.7, theme.mainColor),
              decoration: InputDecoration(
                isDense: true,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      showTutorPassword = !showTutorPassword;
                    });
                  },
                  child: Icon(
                    showTutorPassword ? Icons.visibility : Icons.visibility_off,
                    color: theme.lightTextColor,
                    size: screenWidth * 5,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 4, vertical: screenWidth * 4),
                hintText: 'AB@123abc',
                hintStyle: textStyle(screenWidth * 3.3, theme.lightTextColor),
                filled: true,
                fillColor: Colors.white24,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 200),
                    borderSide:
                        BorderSide(width: .3, color: theme.lightTextColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 200),
                    borderSide: BorderSide(
                        width: .6,
                        color: !tutorPasswordValid
                            ? theme.redColor
                            : theme.yellowColor)),
              ),
            ),
          ),
          authProvider.tutorPassword.text.length == 0 || tutorPasswordValid
              ? sizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 1, top: screenWidth * 1),
                  child: Row(
                    children: [
                      text(tutorErrorTextPassword, screenWidth * 2.7,
                          theme.redColor),
                    ],
                  ),
                ),
          sizedBox(height: screenWidth * 4),
          Row(
            children: [
              text('رقم الجوال', screenWidth * 3, theme.lightTextColor,
                  fontWeight: FontWeight.w500),
            ],
          ),
          sizedBox(height: screenWidth * 3),
          SizedBox(
            height: screenWidth * 12.5,
            width: double.infinity,
            child: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                setState(() {
                  if (authProvider.tutorPhoneNumber.text.startsWith('5')) {
                    if (number.phoneNumber!.length > 10) {
                      tutorPhoneNumberValid = true;
                      tutorErrorTextPhoneNumber = '';
                      if (tutorPasswordValid &&
                          tutorEmailValid &&
                          tutorUsernameValid &&
                          tutorPhoneNumberValid &&
                          tutorDegreeValid &&
                          tutorLocationValid &&
                          tutorMajorValid &&
                          tutorAddressValid &&
                          onlineLessonPriceValid &&
                          studentsHomeLessonPriceValid &&
                          tutorsHomeLessonPriceValid) {
                        tutorAllFieldsValid = true;
                      }
                    } else {
                      tutorErrorTextPhoneNumber =
                          "الهاتف الذي تم إدخاله غير صحيح";
                      if (authProvider.tutorPhoneNumber.text.contains(' ')) {
                        tutorErrorTextPhoneNumber =
                            "يجب ألا يحتوي الهاتف على مسافات";
                      }
                      tutorPhoneNumberValid = false;
                      tutorAllFieldsValid = false;
                    }
                  } else {
                    tutorErrorTextPhoneNumber = "يجب أن يبدأ الهاتف بالرقم 5";
                    tutorPhoneNumberValid = false;
                    tutorAllFieldsValid = false;
                  }
                });
              },
              countries: ["SA"],
              maxLength: 9,
              inputBorder: InputBorder.none,
              onInputValidated: (bool value) {
                print(value);
              },
              selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.DROPDOWN,
                  trailingSpace: false,
                  // countryComparator:(valu,val){},
                  leadingPadding: 0.0,
                  showFlags: false),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: Colors.black),
              initialValue: PhoneNumber(
                dialCode: "+966",
                isoCode: "SA",
                phoneNumber: "5XXXXXXXX",
              ),
              textFieldController: authProvider.tutorPhoneNumber,
              formatInput: false,
              inputDecoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 4, vertical: screenWidth * 4),
                hintText: '5XXXXXXXX',
                hintStyle: textStyle(screenWidth * 3.3, theme.lightTextColor),
                filled: true,
                fillColor: Colors.white24,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 200),
                    borderSide:
                        BorderSide(width: .3, color: theme.lightTextColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 200),
                    borderSide: BorderSide(
                        width: .6,
                        color: !tutorPhoneNumberValid
                            ? theme.redColor
                            : theme.yellowColor)),
              ),
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              onSaved: (PhoneNumber number) {
                print('On Saved: $number');
              },
            ),
          ),
          authProvider.tutorPhoneNumber.text.length == 0 ||
                  tutorPhoneNumberValid
              ? sizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 1, top: screenWidth * 1),
                  child: Row(
                    children: [
                      text(tutorErrorTextPhoneNumber, screenWidth * 2.7,
                          theme.redColor),
                    ],
                  ),
                ),
          sizedBox(height: screenWidth * 4),
          Row(
            children: [
              text('المادة', screenWidth * 3, theme.lightTextColor,
                  fontWeight: FontWeight.w500),
            ],
          ),
          sizedBox(height: screenWidth * 3),
          Container(
            padding: EdgeInsets.only(right: 5),
            width: double.infinity,
            child: DropdownSearch<String>.multiSelection(
              items: subjects,
              popupProps: PopupPropsMultiSelection.menu(
                showSelectedItems: true,
                disabledItemFn: (String s) => s.startsWith('I'),
              ),
              onChanged: (value) {
                values = value;
                if (values.isNotEmpty) {
                  tutorDegreeValid = true;
                  authProvider.tutorDegree.text = jsonEncode(values);
                  tutorErrorTextDegree = '';
                  if (tutorPasswordValid &&
                      tutorEmailValid &&
                      tutorUsernameValid &&
                      tutorPhoneNumberValid &&
                      tutorDegreeValid &&
                      tutorLocationValid &&
                      tutorMajorValid &&
                      tutorAddressValid &&
                      onlineLessonPriceValid &&
                      studentsHomeLessonPriceValid &&
                      tutorsHomeLessonPriceValid) {
                    tutorAllFieldsValid = true;
                  }
                } else {
                  tutorErrorTextDegree = 'المادة المدخلة غير صحيحة';
                  tutorDegreeValid = false;
                  tutorAllFieldsValid = false;
                }
                if (mounted) setState(() {});
              },
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 4,
                    vertical: screenWidth * 2,
                  ),
                  hintStyle: textStyle(screenWidth * 3.3, theme.lightTextColor),
                  hintText: 'إضافة مادة ',
                  filled: true,
                  fillColor: Colors.white24,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 200),
                    borderSide: BorderSide(
                      width: .3,
                      color: theme.lightTextColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 200),
                    borderSide: BorderSide(
                      width: .6,
                      color: !tutorDegreeValid
                          ? theme.redColor
                          : theme.yellowColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          values.length == 0 || tutorDegreeValid
              ? sizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 1,
                    top: screenWidth * 1,
                  ),
                  child: Row(
                    children: [
                      text(
                        tutorErrorTextDegree,
                        screenWidth * 2.7,
                        theme.redColor,
                      ),
                    ],
                  ),
                ),
          sizedBox(height: screenWidth * 4),
          Row(
            children: [
              text('التخصص العلمي', screenWidth * 3, theme.lightTextColor,
                  fontWeight: FontWeight.w500),
            ],
          ),
          sizedBox(height: screenWidth * 3),
          SizedBox(
            height: screenWidth * 12.5,
            width: double.infinity,
            child: TextFormField(
              controller: authProvider.tutorMajor,
              onChanged: (value) {
                setState(() {
                  if (authProvider.tutorMajor.text.isNotEmpty) {
                    tutorMajorValid = true;
                    tutorErrorTextMajor = '';
                    if (tutorPasswordValid &&
                        tutorEmailValid &&
                        tutorUsernameValid &&
                        tutorPhoneNumberValid &&
                        tutorDegreeValid &&
                        tutorLocationValid &&
                        tutorMajorValid &&
                        tutorAddressValid &&
                        onlineLessonPriceValid &&
                        studentsHomeLessonPriceValid &&
                        tutorsHomeLessonPriceValid) {
                      tutorAllFieldsValid = true;
                    }
                  } else {
                    tutorErrorTextMajor = 'التخصص المدخل غير صحيح';
                    tutorMajorValid = false;
                    tutorAllFieldsValid = false;
                  }
                });
              },
              style: textStyle(screenWidth * 3.7, theme.mainColor),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 4, vertical: screenWidth * 4),
                hintText: 'مثال : تقنية المعلومات',
                hintStyle: textStyle(screenWidth * 3.3, theme.lightTextColor),
                filled: true,
                fillColor: Colors.white24,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 200),
                    borderSide:
                        BorderSide(width: .3, color: theme.lightTextColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 200),
                    borderSide: BorderSide(
                        width: .6,
                        color: !tutorMajorValid
                            ? theme.redColor
                            : theme.yellowColor)),
              ),
            ),
          ),
          authProvider.tutorMajor.text.length == 0 || tutorMajorValid
              ? sizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 1, top: screenWidth * 1),
                  child: Row(
                    children: [
                      text(tutorErrorTextMajor, screenWidth * 2.7,
                          theme.redColor),
                    ],
                  ),
                ),
          sizedBox(height: screenWidth * 4),
          Row(
            children: [
              text('المدينة', screenWidth * 3, theme.lightTextColor,
                  fontWeight: FontWeight.w500),
            ],
          ),
          sizedBox(height: screenWidth * 3),
          SizedBox(
            height: screenWidth * 12.5,
            width: double.infinity,
            child: DropdownButtonFormField(
              key: _tutorAddressKey,
              items: citiesList.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) async {
                var tempCity = await cities
                    .where((element) => (element['name_ar'] == value));
                var tempArea = await areas.where((element) =>
                    (element['city_id'] == tempCity.first['city_id']));
                _tutorAddressKey.currentState?.reset();
                areasList.clear();
                areasList.addAll(tempArea);
                authProvider.tutorLocation.text = value.toString();
                if (authProvider.tutorLocation.text.isNotEmpty) {
                  tutorLocationValid = true;
                  tutorErrorTextLocation = '';
                  if (tutorPasswordValid &&
                      tutorEmailValid &&
                      tutorUsernameValid &&
                      tutorPhoneNumberValid &&
                      tutorDegreeValid &&
                      tutorLocationValid &&
                      tutorMajorValid &&
                      tutorAddressValid &&
                      onlineLessonPriceValid &&
                      studentsHomeLessonPriceValid &&
                      tutorsHomeLessonPriceValid) {
                    tutorAllFieldsValid = true;
                  }
                } else {
                  tutorErrorTextLocation = "المدينة التي تم إدخالها غير صحيحة";
                  tutorLocationValid = false;
                  tutorAllFieldsValid = false;
                }
                if (mounted) setState(() {});
              },
              style: textStyle(screenWidth * 3.7, theme.mainColor),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 4, vertical: screenWidth * 4),
                hintText: 'المدينة',
                hintStyle: textStyle(screenWidth * 3.3, theme.lightTextColor),
                filled: true,
                fillColor: Colors.white24,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 200),
                    borderSide:
                        BorderSide(width: .3, color: theme.lightTextColor)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 200),
                  borderSide: BorderSide(
                    width: .6,
                    color: !tutorLocationValid
                        ? theme.redColor
                        : theme.yellowColor,
                  ),
                ),
              ),
            ),
          ),
          authProvider.tutorLocation.text.length == 0 || tutorLocationValid
              ? sizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 1,
                    top: screenWidth * 1,
                  ),
                  child: Row(
                    children: [
                      text(
                        tutorErrorTextLocation,
                        screenWidth * 2.7,
                        theme.redColor,
                      ),
                    ],
                  ),
                ),
          sizedBox(height: screenWidth * 4),
          Row(
            children: [
              text(
                'العنوان / الحي',
                screenWidth * 3,
                theme.lightTextColor,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          sizedBox(height: screenWidth * 3),
          SizedBox(
            height: screenWidth * 16,
            width: double.infinity,
            child: DropdownButtonFormField(
              items: areasList.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value['name_ar']),
                );
              }).toList(),
              onChanged: (dynamic value) {
                setState(() {
                  authProvider.tutorAddress.text = value['name_ar'];
                  if (authProvider.tutorAddress.text.isNotEmpty) {
                    tutorAddressValid = true;
                    tutorErrorTextAddress = '';
                    if (tutorPasswordValid &&
                        tutorEmailValid &&
                        tutorUsernameValid &&
                        tutorPhoneNumberValid &&
                        tutorDegreeValid &&
                        tutorLocationValid &&
                        tutorMajorValid &&
                        tutorAddressValid &&
                        onlineLessonPriceValid &&
                        studentsHomeLessonPriceValid &&
                        tutorsHomeLessonPriceValid) {
                      tutorAllFieldsValid = true;
                    }
                  } else {
                    tutorErrorTextAddress = 'العنوان / الحي المدخل غير صحيح';
                    tutorAddressValid = false;
                    tutorAllFieldsValid = false;
                  }
                });
              },
              style: textStyle(screenWidth * 3.7, theme.mainColor),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 4, vertical: screenWidth * 4),
                hintText: "الحي",
                hintStyle: textStyle(screenWidth * 3.3, theme.lightTextColor),
                filled: true,
                fillColor: Colors.white24,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 200),
                    borderSide:
                        BorderSide(width: .3, color: theme.lightTextColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 200),
                    borderSide: BorderSide(
                        width: .6,
                        color: !tutorAddressValid
                            ? theme.redColor
                            : theme.yellowColor)),
              ),
            ),
          ),
          authProvider.tutorAddress.text.length == 0 || tutorAddressValid
              ? sizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 1, top: screenWidth * 1),
                  child: Row(
                    children: [
                      text(
                        tutorErrorTextAddress,
                        screenWidth * 2.7,
                        theme.redColor,
                      ),
                    ],
                  ),
                ),
          sizedBox(height: screenWidth * 4),
          Row(
            children: [
              text(
                'نوع الدروس',
                screenWidth * 3,
                theme.lightTextColor,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 35,
                  child: CheckboxListTile(
                    value: authProvider.isOnlineLesson,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.all(0),
                    shape: CircleBorder(),
                    onChanged: (value) {
                      authProvider.isOnlineLesson = value!;
                      if (mounted) setState(() {});
                      if (authProvider.isOnlineLesson) {
                        if (authProvider.onlineLessonPrice.text.isNotEmpty) {
                          onlineLessonPriceValid = true;
                          tutorErrorTextOnlineLessonPrice = '';
                          if (tutorPasswordValid &&
                              tutorEmailValid &&
                              tutorUsernameValid &&
                              tutorPhoneNumberValid &&
                              tutorDegreeValid &&
                              tutorLocationValid &&
                              tutorMajorValid &&
                              tutorAddressValid &&
                              onlineLessonPriceValid &&
                              studentsHomeLessonPriceValid &&
                              tutorsHomeLessonPriceValid) {
                            tutorAllFieldsValid = true;
                          }
                        } else {
                          tutorErrorTextOnlineLessonPrice =
                              'تأكد من إدخال السعر بشكل صحيح';
                          onlineLessonPriceValid = false;
                          tutorAllFieldsValid = false;
                        }
                      } else {
                        if (!authProvider.isOnlineLesson &&
                            !authProvider.isStudentHomeLesson &&
                            !authProvider.isTutorHomeLesson) {
                          tutorErrorTextOnlineLessonPrice =
                              'تأكد من إدخال السعر بشكل صحيح';
                          onlineLessonPriceValid = false;
                          tutorAllFieldsValid = false;
                        } else {
                          onlineLessonPriceValid = true;
                          tutorAllFieldsValid = false;
                        }
                      }
                      if (mounted) setState(() {});
                    },
                    title: Text(
                      'أون لاين',
                      style: TextStyle(
                        fontSize: screenWidth * 3,
                        color: theme.lightTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 35,
                width: 110,
                child: TextFormField(
                  controller: authProvider.onlineLessonPrice,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    setState(() {
                      if (authProvider.isOnlineLesson) {
                        if (authProvider.onlineLessonPrice.text.isNotEmpty) {
                          onlineLessonPriceValid = true;
                          tutorErrorTextOnlineLessonPrice = '';
                          if (tutorPasswordValid &&
                              tutorEmailValid &&
                              tutorUsernameValid &&
                              tutorPhoneNumberValid &&
                              tutorDegreeValid &&
                              tutorLocationValid &&
                              tutorMajorValid &&
                              tutorAddressValid &&
                              onlineLessonPriceValid &&
                              studentsHomeLessonPriceValid &&
                              tutorsHomeLessonPriceValid) {
                            tutorAllFieldsValid = true;
                          }
                        } else {
                          tutorErrorTextOnlineLessonPrice =
                              ' المدخل غير صحيح';
                          onlineLessonPriceValid = false;
                          tutorAllFieldsValid = false;
                        }
                      } else {
                        if (!authProvider.isOnlineLesson &&
                            !authProvider.isStudentHomeLesson &&
                            !authProvider.isTutorHomeLesson) {
                          tutorErrorTextOnlineLessonPrice =
                              ' المدخل غير صحيح';
                          onlineLessonPriceValid = false;
                          tutorAllFieldsValid = false;
                        } else {
                          onlineLessonPriceValid = true;
                          tutorAllFieldsValid = false;
                        }
                      }
                    });
                  },
                  style: textStyle(screenWidth * 3.7, theme.mainColor),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 4,
                        vertical: screenWidth * 1.5),
                    hintText: 'ريال/ساعة',
                    hintStyle:
                        textStyle(screenWidth * 3.3, theme.lightTextColor),
                    filled: true,
                    fillColor: Colors.white24,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 200),
                      borderSide:
                          BorderSide(width: .3, color: theme.lightTextColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 200),
                      borderSide: BorderSide(
                        width: .6,
                        color: !onlineLessonPriceValid
                            ? theme.redColor
                            : theme.yellowColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          onlineLessonPriceValid
              ? sizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 1, top: screenWidth * 1),
                  child: Row(
                    children: [
                      text(
                        tutorErrorTextOnlineLessonPrice,
                        screenWidth * 2.7,
                        theme.redColor,
                      ),
                    ],
                  ),
                ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 35,
                  child: CheckboxListTile(
                    value: authProvider.isStudentHomeLesson,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.all(0),
                    shape: CircleBorder(),
                    onChanged: (value) {
                      authProvider.isStudentHomeLesson = value!;
                      if (mounted) setState(() {});
                      if (authProvider.isStudentHomeLesson) {
                        if (authProvider
                            .studentsHomeLessonPrice.text.isNotEmpty) {
                          studentsHomeLessonPriceValid = true;
                          tutorErrorTextStudentsHomeLessonPrice = '';
                          if (tutorPasswordValid &&
                              tutorEmailValid &&
                              tutorUsernameValid &&
                              tutorPhoneNumberValid &&
                              tutorDegreeValid &&
                              tutorLocationValid &&
                              tutorMajorValid &&
                              tutorAddressValid &&
                              onlineLessonPriceValid &&
                              studentsHomeLessonPriceValid &&
                              tutorsHomeLessonPriceValid) {
                            tutorAllFieldsValid = true;
                          }
                        } else {
                          tutorErrorTextStudentsHomeLessonPrice =
                              'تأكد من إدخال السعر بشكل صحيح';
                          studentsHomeLessonPriceValid = false;
                          tutorAllFieldsValid = false;
                        }
                      } else {
                        if (!authProvider.isOnlineLesson &&
                            !authProvider.isStudentHomeLesson &&
                            !authProvider.isTutorHomeLesson) {
                          tutorErrorTextOnlineLessonPrice =
                              'تأكد من إدخال السعر بشكل صحيح';
                          studentsHomeLessonPriceValid = false;
                          tutorAllFieldsValid = false;
                        } else {
                          studentsHomeLessonPriceValid = true;
                          tutorAllFieldsValid = false;
                        }
                      }
                      if (mounted) setState(() {});
                    },
                    title: Text(
                      'حضوري (مكان الطالب)',
                      style: TextStyle(
                        fontSize: screenWidth * 3,
                        color: theme.lightTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 35,
                width: 110,
                child: TextFormField(
                  controller: authProvider.studentsHomeLessonPrice,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    setState(() {
                      if (authProvider.isStudentHomeLesson) {
                        if (authProvider
                            .studentsHomeLessonPrice.text.isNotEmpty) {
                          studentsHomeLessonPriceValid = true;
                          tutorErrorTextStudentsHomeLessonPrice = '';
                          if (tutorPasswordValid &&
                              tutorEmailValid &&
                              tutorUsernameValid &&
                              tutorPhoneNumberValid &&
                              tutorDegreeValid &&
                              tutorLocationValid &&
                              tutorMajorValid &&
                              tutorAddressValid &&
                              onlineLessonPriceValid &&
                              studentsHomeLessonPriceValid &&
                              tutorsHomeLessonPriceValid) {
                            tutorAllFieldsValid = true;
                          }
                        } else {
                          tutorErrorTextStudentsHomeLessonPrice =
                              ' المدخل غير صحيح';
                          studentsHomeLessonPriceValid = false;
                          tutorAllFieldsValid = false;
                        }
                      } else {
                        if (!authProvider.isOnlineLesson &&
                            !authProvider.isStudentHomeLesson &&
                            !authProvider.isTutorHomeLesson) {
                          tutorErrorTextOnlineLessonPrice =
                              'تأكد من إدخال السعر بشكل صحيح';
                          studentsHomeLessonPriceValid = false;
                          tutorAllFieldsValid = false;
                        } else {
                          studentsHomeLessonPriceValid = true;
                          tutorAllFieldsValid = false;
                        }
                      }
                    });
                  },
                  style: textStyle(screenWidth * 3.7, theme.mainColor),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 4,
                        vertical: screenWidth * 1.5),
                    hintText: 'ريال/ساعة',
                    hintStyle:
                        textStyle(screenWidth * 3.3, theme.lightTextColor),
                    filled: true,
                    fillColor: Colors.white24,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 200),
                      borderSide:
                          BorderSide(width: .3, color: theme.lightTextColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 200),
                      borderSide: BorderSide(
                        width: .6,
                        color: !studentsHomeLessonPriceValid
                            ? theme.redColor
                            : theme.yellowColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          studentsHomeLessonPriceValid
              ? sizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 1, top: screenWidth * 1),
                  child: Row(
                    children: [
                      text(
                        tutorErrorTextStudentsHomeLessonPrice,
                        screenWidth * 2.7,
                        theme.redColor,
                      ),
                    ],
                  ),
                ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 35,
                  child: CheckboxListTile(
                    value: authProvider.isTutorHomeLesson,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.all(0),
                    shape: CircleBorder(),
                    onChanged: (value) {
                      authProvider.isTutorHomeLesson = value!;
                      if (mounted) setState(() {});
                      if (authProvider.isTutorHomeLesson) {
                        if (authProvider
                            .tutorsHomeLessonPrice.text.isNotEmpty) {
                          tutorsHomeLessonPriceValid = true;
                          tutorErrorTextTutorsHomeLessonPrice = '';
                          if (tutorPasswordValid &&
                              tutorEmailValid &&
                              tutorUsernameValid &&
                              tutorPhoneNumberValid &&
                              tutorDegreeValid &&
                              tutorLocationValid &&
                              tutorMajorValid &&
                              tutorAddressValid &&
                              onlineLessonPriceValid &&
                              studentsHomeLessonPriceValid &&
                              tutorsHomeLessonPriceValid) {
                            tutorAllFieldsValid = true;
                          }
                        } else {
                          tutorErrorTextTutorsHomeLessonPrice =
                              ' تأكد من إدخال السعر بشكل صحيح';
                          tutorsHomeLessonPriceValid = false;
                          tutorAllFieldsValid = false;
                        }
                      } else {
                        if (!authProvider.isOnlineLesson &&
                            !authProvider.isStudentHomeLesson &&
                            !authProvider.isTutorHomeLesson) {
                          tutorErrorTextOnlineLessonPrice =
                              ' المدخل غير صحيح';
                          tutorsHomeLessonPriceValid = false;
                          tutorAllFieldsValid = false;
                        } else {
                          tutorsHomeLessonPriceValid = true;
                          tutorAllFieldsValid = false;
                        }
                      }
                      if (mounted) setState(() {});
                    },
                    title: Text(
                      'حضوري (مكان المعلم)',
                      style: TextStyle(
                        fontSize: screenWidth * 3,
                        color: theme.lightTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 35,
                width: 110,
                child: TextFormField(
                  controller: authProvider.tutorsHomeLessonPrice,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    setState(() {
                      if (authProvider.isTutorHomeLesson) {
                        if (authProvider
                            .tutorsHomeLessonPrice.text.isNotEmpty) {
                          tutorsHomeLessonPriceValid = true;
                          tutorErrorTextTutorsHomeLessonPrice = '';
                          if (tutorPasswordValid &&
                              tutorEmailValid &&
                              tutorUsernameValid &&
                              tutorPhoneNumberValid &&
                              tutorDegreeValid &&
                              tutorLocationValid &&
                              tutorMajorValid &&
                              tutorAddressValid &&
                              onlineLessonPriceValid &&
                              studentsHomeLessonPriceValid &&
                              tutorsHomeLessonPriceValid) {
                            tutorAllFieldsValid = true;
                          }
                        } else {
                          tutorErrorTextTutorsHomeLessonPrice =
                              'تأكد من إدخال السعر بشكل صحيح';
                          tutorsHomeLessonPriceValid = false;
                          tutorAllFieldsValid = false;
                        }
                      } else {
                        if (!authProvider.isOnlineLesson &&
                            !authProvider.isStudentHomeLesson &&
                            !authProvider.isTutorHomeLesson) {
                          tutorErrorTextOnlineLessonPrice =
                              'تأكد من إدخال السعر بشكل صحيح';
                          tutorsHomeLessonPriceValid = false;
                          tutorAllFieldsValid = false;
                        } else {
                          tutorsHomeLessonPriceValid = true;
                          tutorAllFieldsValid = false;
                        }
                      }
                    });
                  },
                  style: textStyle(screenWidth * 3.7, theme.mainColor),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 4,
                        vertical: screenWidth * 1.5),
                    hintText: 'ريال/ساعة',
                    hintStyle:
                        textStyle(screenWidth * 3.3, theme.lightTextColor),
                    filled: true,
                    fillColor: Colors.white24,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 200),
                      borderSide:
                          BorderSide(width: .3, color: theme.lightTextColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 200),
                      borderSide: BorderSide(
                        width: .6,
                        color: !tutorsHomeLessonPriceValid
                            ? theme.redColor
                            : theme.yellowColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          tutorsHomeLessonPriceValid
              ? sizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 1, top: screenWidth * 1),
                  child: Row(
                    children: [
                      text(
                        tutorErrorTextTutorsHomeLessonPrice,
                        screenWidth * 2.7,
                        theme.redColor,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget studentBlock(screenWidth, AuthProvider authProvider) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        sizedBox(height: screenWidth * 4),
        Row(
          children: [
            text('اسم المستخدم', screenWidth * 3, theme.lightTextColor,
                fontWeight: FontWeight.w500),
          ],
        ),
        sizedBox(height: screenWidth * 3),
        SizedBox(
          height: screenWidth * 12.5,
          width: double.infinity,
          child: TextFormField(
            controller: authProvider.studentUserName,
            onChanged: (value) {
              setState(() {
                if (!authProvider.studentUserName.text.contains(' ') &&
                    authProvider.studentUserName.text.isNotEmpty) {
                  studentUsernameValid = true;
                  studentErrorTextUserName = '';
                  if (studentPasswordValid &&
                      studentEmailValid &&
                      studentPhoneNumberValid &&
                      studentLocationValid &&
                      studentUsernameValid &&
                      studentAddressValid) {
                    studentAllFieldsValid = true;
                  }
                } else {
                  studentErrorTextUserName = 'اسم المستخدم المدخل غير صحيح';
                 /* if (authProvider.studentUserName.text.contains(' ')) {
                    studentErrorTextUserName =
                        'اسم المستخدم يجب أن لايحتوي على مسافات';
                  }*/ 
                  studentUsernameValid = false;
                  studentAllFieldsValid = false;
               }
              });
            },
            style: textStyle(screenWidth * 3.7, theme.blueColor),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 4, vertical: screenWidth * 4),
              hintText: 'اسم المستخدم',
              hintStyle: textStyle(screenWidth * 3.3, theme.lightTextColor),
              filled: true,
              fillColor: Colors.white24,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 200),
                  borderSide:
                      BorderSide(width: .3, color: theme.lightTextColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 200),
                  borderSide: BorderSide(
                      width: .6,
                      color: !studentUsernameValid
                          ? theme.redColor
                          : theme.yellowColor)),
            ),
          ),
        ),
        authProvider.studentUserName.text.length == 0 || studentUsernameValid
            ? sizedBox()
            : Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 1, top: screenWidth * 1),
                child: Row(
                  children: [
                    text(studentErrorTextUserName, screenWidth * 2.7,
                        theme.redColor),
                  ],
                ),
              ),
        sizedBox(height: screenWidth * 4),
        Row(
          children: [
            text('البريد الإلكتروني', screenWidth * 3, theme.lightTextColor,
                fontWeight: FontWeight.w500),
          ],
        ),
        sizedBox(height: screenWidth * 3),
        SizedBox(
          height: screenWidth * 12.5,
          width: double.infinity,
          child: TextFormField(
            controller: authProvider.studentEmail,
            onChanged: (value) {
              setState(() {
                if (authProvider.studentEmail.text.isNotEmpty &&
                    isEmail(value)
                    // (studentEmail.text.contains('@gmail.com') ||
                    //     studentEmail.text.contains('@hotmail.com') ||
                    //     studentEmail.text.contains('@yahoo.com'))
                    &&
                    !authProvider.studentEmail.text.contains(' ')) {
                  studentEmailValid = true;
                  studentErrorTextEmail = '';
                  if (studentPasswordValid &&
                      studentEmailValid &&
                      studentPhoneNumberValid &&
                      studentLocationValid &&
                      studentAddressValid) {
                    studentAllFieldsValid = true;
                  }
                } else {
                  studentErrorTextEmail = 'البريد الإلكتروني المدخل غير صحيح';
                  if (authProvider.studentEmail.text.contains(' ')) {
                    studentErrorTextEmail =
                        'يجب أن لا يحتوي البريد الإلكتروني على مساحات فارغة';
                  }
                  studentEmailValid = false;
                  studentAllFieldsValid = false;
                }
              });
            },
            style: textStyle(screenWidth * 3.7, theme.mainColor),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 4, vertical: screenWidth * 4),
              hintText: 'abc@domain.com',
              hintStyle: textStyle(screenWidth * 3.3, theme.lightTextColor),
              filled: true,
              fillColor: Colors.white24,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 200),
                  borderSide:
                      BorderSide(width: .3, color: theme.lightTextColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 200),
                  borderSide: BorderSide(
                      width: .6,
                      color: !studentEmailValid
                          ? theme.redColor
                          : theme.yellowColor)),
            ),
          ),
        ),
        authProvider.studentEmail.text.length == 0 || studentEmailValid
            ? sizedBox()
            : Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 1, top: screenWidth * 1),
                child: Row(
                  children: [
                    text(studentErrorTextEmail, screenWidth * 2.7,
                        theme.redColor),
                  ],
                ),
              ),
        sizedBox(height: screenWidth * 4),
        Row(
          children: [
            text('كلمة المرور', screenWidth * 3, theme.lightTextColor,
                fontWeight: FontWeight.w500),
          ],
        ),
        sizedBox(height: screenWidth * 3),
        SizedBox(
          height: screenWidth * 12.5,
          width: double.infinity,
          child: TextFormField(
            controller: authProvider.studentPassword,
            onChanged: (value) {
              setState(() {
                if (authProvider.studentPassword.text.length > 7 &&
                    !authProvider.studentPassword.text.contains(' ') &&
                    validatePassword(value)) {
                  studentPasswordValid = true;
                  studentErrorTextPassword = '';
                  if (studentPasswordValid &&
                      studentEmailValid &&
                      studentPhoneNumberValid &&
                      studentLocationValid &&
                      studentAddressValid) {
                    studentAllFieldsValid = true;
                  }
                } else {
                  studentErrorTextPassword =
                      'يجب أن تحتوي كلمة المرور على 8 أحرف كبيرة وصغيرة وأرقام ورموز';
                  if (authProvider.studentPassword.text.contains(' ')) {
                    studentErrorTextPassword =
                        'يجب أن لا تحتوي كلمة المرور على مسافات';
                  }
                  studentPasswordValid = false;
                  studentAllFieldsValid = false;
                }
              });
            },
            obscureText: showStudentPassword ? false : true,
            style: textStyle(screenWidth * 3.7, theme.mainColor),
            decoration: InputDecoration(
              isDense: true,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    showStudentPassword = !showStudentPassword;
                  });
                },
                child: Icon(
                  showStudentPassword ? Icons.visibility : Icons.visibility_off,
                  color: theme.lightTextColor,
                  size: screenWidth * 5,
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 4, vertical: screenWidth * 4),
              hintText: 'AB123@abc',
              hintStyle: textStyle(screenWidth * 3.3, theme.lightTextColor),
              filled: true,
              fillColor: Colors.white24,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 200),
                  borderSide:
                      BorderSide(width: .3, color: theme.lightTextColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 200),
                  borderSide: BorderSide(
                      width: .6,
                      color: !studentPasswordValid
                          ? theme.redColor
                          : theme.yellowColor)),
            ),
          ),
        ),
        authProvider.studentPassword.text.length == 0 || studentPasswordValid
            ? sizedBox()
            : Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 1, top: screenWidth * 1),
                child: Row(
                  children: [
                    text(studentErrorTextPassword, screenWidth * 2.7,
                        theme.redColor),
                  ],
                ),
              ),
        sizedBox(height: screenWidth * 4),
        Row(
          children: [
            text('رقم الجوال', screenWidth * 3, theme.lightTextColor,
                fontWeight: FontWeight.w500),
          ],
        ),
        sizedBox(height: screenWidth * 3),
        SizedBox(
          height: screenWidth * 16,
          width: double.infinity,
          child: InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              authProvider.studentPhoneNumber.text =
                  number.phoneNumber!.replaceAll('+966', '');
              if (authProvider.tutorPhoneNumber.text.startsWith('5')) {
                if (number.phoneNumber!.length > 10) {
                  studentPhoneNumberValid = true;
                  studentErrorTextPhoneNumber = '';
                  if (studentPasswordValid &&
                      studentEmailValid &&
                      studentPhoneNumberValid &&
                      studentLocationValid &&
                      studentAddressValid) {
                    studentAllFieldsValid = true;
                  }
                } else {
                  studentErrorTextPhoneNumber =
                      "الهاتف الذي تم إدخاله غير صحيح";
                  if (authProvider.studentPhoneNumber.text.contains(' ')) {
                    studentErrorTextPhoneNumber =
                        "يجب ألا يحتوي الهاتف على مسافات";
                  }
                  studentPhoneNumberValid = false;
                  studentAllFieldsValid = false;
                }
              } else {
                studentErrorTextPhoneNumber = "يجب أن يبدأ الهاتف بالرقم 5";
                studentPhoneNumberValid = false;
                studentAllFieldsValid = false;
              }
              if (mounted) setState(() {});
            },
            countries: ["SA"],
            maxLength: 9,
            inputBorder: InputBorder.none,
            onInputValidated: (bool value) {
              print(value);
            },
            selectorConfig: SelectorConfig(
              selectorType: PhoneInputSelectorType.DROPDOWN,
              trailingSpace: false,
              leadingPadding: 0.0,
              showFlags: false,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.disabled,
            selectorTextStyle: TextStyle(color: Colors.black),
            initialValue: PhoneNumber(
              dialCode: "+966",
              isoCode: "SA",
              phoneNumber: "5XXXXXXXX",
            ),
            textFieldController: authProvider.studentPhoneNumber,
            formatInput: false,
            inputDecoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * 4,
                vertical: screenWidth * 4,
              ),
              hintText: '5XXXXXXXX',
              hintStyle: textStyle(screenWidth * 3.3, theme.lightTextColor),
              filled: true,
              fillColor: Colors.white24,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(screenWidth * 200),
                borderSide: BorderSide(
                  width: .3,
                  color: theme.lightTextColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(screenWidth * 200),
                borderSide: BorderSide(
                  width: .6,
                  color: !studentPhoneNumberValid
                      ? theme.redColor
                      : theme.yellowColor,
                ),
              ),
            ),
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
            onSaved: (PhoneNumber number) {
              print('On Saved: $number');
            },
          ),
        ),
        authProvider.studentPhoneNumber.text.length == 0 ||
                studentPhoneNumberValid
            ? sizedBox()
            : Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 1, top: screenWidth * 1),
                child: Row(
                  children: [
                    text(studentErrorTextPhoneNumber, screenWidth * 2.7,
                        theme.redColor),
                  ],
                ),
              ),
        sizedBox(height: screenWidth * 4),
        Row(
          children: [
            text('المدينة', screenWidth * 3, theme.lightTextColor,
                fontWeight: FontWeight.w500),
          ],
        ),
        sizedBox(height: screenWidth * 3),
        SizedBox(
          height: screenWidth * 16,
          width: double.infinity,
          child: DropdownButtonFormField(
            key: _studentAddressKey,
            items: citiesList.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (dynamic value) async {
              var tempCity = await cities
                  .where((element) => (element['name_ar'] == value));
              var tempArea = await areas.where((element) =>
                  (element['city_id'] == tempCity.first['city_id']));
              _studentAddressKey.currentState?.reset();
              areasList.clear();
              areasList.addAll(tempArea);
              authProvider.studentLocation.text = value.toString();
              if (authProvider.studentLocation.text.isNotEmpty) {
                studentLocationValid = true;
                studentErrorTextLocation = '';
                if (studentPasswordValid &&
                    studentEmailValid &&
                    studentPhoneNumberValid &&
                    studentLocationValid &&
                    studentAddressValid) {
                  studentAllFieldsValid = true;
                }
              } else {
                studentErrorTextLocation = "المدينة التي تم إدخالها غير صحيحة";
                studentLocationValid = false;
                studentAllFieldsValid = false;
              }
              if (mounted) setState(() {});
            },
            style: textStyle(screenWidth * 3.7, theme.mainColor),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 4, vertical: screenWidth * 4),
              hintText: 'المدينة',
              hintStyle: textStyle(screenWidth * 3.3, theme.lightTextColor),
              filled: true,
              fillColor: Colors.white24,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 200),
                  borderSide:
                      BorderSide(width: .3, color: theme.lightTextColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 200),
                  borderSide: BorderSide(
                      width: .6,
                      color: !studentLocationValid
                          ? theme.redColor
                          : theme.yellowColor)),
            ),
          ),
        ),
        authProvider.studentLocation.text.length == 0 || studentLocationValid
            ? sizedBox()
            : Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 1, top: screenWidth * 1),
                child: Row(
                  children: [
                    text(studentErrorTextLocation, screenWidth * 2.7,
                        theme.redColor),
                  ],
                ),
              ),
        sizedBox(height: screenWidth * 4),
        Row(
          children: [
            text('العنوان / الحي', screenWidth * 3, theme.lightTextColor,
                fontWeight: FontWeight.w500),
          ],
        ),
        sizedBox(height: screenWidth * 3),
        SizedBox(
          height: screenWidth * 16,
          width: double.infinity,
          child: DropdownButtonFormField(
            items: areasList.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value['name_ar']),
              );
            }).toList(),
            onChanged: (dynamic value) {
              setState(() {
                authProvider.studentAddress.text = value['name_ar'];
                if (authProvider.studentAddress.text.isNotEmpty) {
                  studentAddressValid = true;
                  studentErrorTextLocation = '';
                  if (studentPasswordValid &&
                      studentEmailValid &&
                      studentPhoneNumberValid &&
                      studentAddressValid &&
                      studentAddressValid) {
                    studentAllFieldsValid = true;
                  }
                } else {
                  studentErrorTextLocation =
                      "المدينة التي تم إدخالها غير صحيحة";
                  studentAddressValid = false;
                  studentAllFieldsValid = false;
                }
              });
            },
            style: textStyle(screenWidth * 3.7, theme.mainColor),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 4, vertical: screenWidth * 4),
              hintText: "حي العمل",
              hintStyle: textStyle(screenWidth * 3.3, theme.lightTextColor),
              filled: true,
              fillColor: Colors.white24,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 200),
                  borderSide:
                      BorderSide(width: .3, color: theme.lightTextColor)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(screenWidth * 200),
                borderSide: BorderSide(
                  width: .6,
                  color:
                      !studentAddressValid ? theme.redColor : theme.yellowColor,
                ),
              ),
            ),
          ),
        ),
        authProvider.studentAddress.text.length == 0 || studentAddressValid
            ? sizedBox()
            : Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 1, top: screenWidth * 1),
                child: Row(
                  children: [
                    text(studentErrorTextAddress, screenWidth * 2.7,
                        theme.redColor),
                  ],
                ),
              ),
      ]),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final ValueChanged<int> onDeleted;
  final int index;
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });
  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: theme.blueColor,
      labelPadding: const EdgeInsets.only(right: 10, top: 6, bottom: 6),
      label: Text(
        label,
        style: TextStyle(color: theme.whiteColor),
      ),
      deleteIcon: Icon(Icons.close, size: 18, color: theme.whiteColor),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
