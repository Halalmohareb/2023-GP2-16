import 'dart:convert';
import 'dart:io';

import 'package:Dhyaa/_helper/areas.dart';
import 'package:Dhyaa/_helper/cities.dart';
import 'package:Dhyaa/_helper/subject.dart';
import 'package:Dhyaa/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:Dhyaa/globalWidgets/textWidget/text_widget.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/theme/theme.dart';
import '../_helper/helper.dart';
import '../models/UserData.dart';
import '../responsiveBloc/size_config.dart';
import 'package:fluttertoast/fluttertoast.dart'
    show Fluttertoast, Toast, ToastGravity;

class UpdateProfile extends StatefulWidget {
  final UserData userData;
  const UpdateProfile({Key? key, required this.userData}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  // Variables
  var screenWidth = SizeConfig.widthMultiplier;
  UserData userData = emptyUserData;
  var type = '';
  final GlobalKey<FormFieldState> _addressKey = GlobalKey<FormFieldState>();

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

  bool isOnlineLesson = true;
  bool isStudentHomeLesson = false;
  bool isTutorHomeLesson = false;
  bool allValid = false;
  bool isLoading = false;

  TextEditingController phone = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController degree = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController onlineLessonPrice = TextEditingController();
  TextEditingController studentsHomeLessonPrice = TextEditingController();
  TextEditingController tutorsHomeLessonPrice = TextEditingController();
  TextEditingController bio = TextEditingController();

  List<String> values = [];
  List areasList = [];
  bool imageSelected = false;
  File img = File('');

  // Functions
  @override
  void initState() {
    userData = widget.userData;
    getUserData();
    setter();
    if (mounted) setState(() {});
    super.initState();
  }

  getUserData() {
    FirestoreHelper.getMyUserData().then((value) {
      userData = value;
      setter();
      if (mounted) setState(() {});
    });
  }

  setter() async {
    areasList = [];
    values = [];
    type = widget.userData.type;
    phone.text = userData.phone.replaceAll('+966', '');
    location.text = userData.location;
    address.text = userData.address;
    bio.text = userData.bio;
    if (userData.type == 'Tutor') {
      subject.text = userData.majorSubjects;
      degree.text = userData.degree;
      if (userData.degree != '' && userData.degree != 'null') {
        for (var element in jsonDecode(userData.degree)) {
          values.add(element);
          setState(() {});
        }
      }
      isOnlineLesson = userData.isOnlineLesson;
      isStudentHomeLesson = userData.isStudentHomeLesson;
      isTutorHomeLesson = userData.isTutorHomeLesson;
      onlineLessonPrice.text = userData.onlineLessonPrice;
      studentsHomeLessonPrice.text = userData.studentsHomeLessonPrice;
      tutorsHomeLessonPrice.text = userData.tutorsHomeLessonPrice;
    }
    var tempCity =
        await cities.where((element) => (element['name_ar'] == location.text));
    var tempArea = await areas
        .where((element) => (element['city_id'] == tempCity.first['city_id']));
    areasList.clear();
    areasList.addAll(tempArea);
    if (mounted) setState(() {});
  }

  update() async {
    FocusScope.of(context).unfocus();
    checkValidation();

    if (allValid) {
      isLoading = true;
      if (mounted) setState(() {});
      if (!isOnlineLesson) {
        onlineLessonPrice.text = '';
      }
      if (!isStudentHomeLesson) {
        studentsHomeLessonPrice.text = '';
      }
      if (!isTutorHomeLesson) {
        tutorsHomeLessonPrice.text = '';
      }

      var form = {
        'phone': phone.text,
        'location': location.text,
        'majorSubjects': subject.text,
        'degree': userData.type == 'Student' ? [] : jsonDecode(degree.text),
        'address': address.text,
        "isOnlineLesson": isOnlineLesson,
        "isStudentHomeLesson": isStudentHomeLesson,
        "isTutorHomeLesson": isTutorHomeLesson,
        "onlineLessonPrice": onlineLessonPrice.text,
        "studentsHomeLessonPrice": studentsHomeLessonPrice.text,
        "tutorsHomeLessonPrice": tutorsHomeLessonPrice.text,
        "bio": bio.text,
        "avatar": userData.avatar,
      };
      if (imageSelected) {
        var avatarUrl = await uploadFile();
        form['avatar'] = avatarUrl;
      }
      FirestoreHelper.updateUserData(userData.userId, form).then((value) {
        FirestoreHelper.getMyUserData().then((value) {
          isLoading = false;
          userData = value;
          showToast('تم تحديث الملف الشخصي بنجاح');
          if (mounted) setState(() {});
        });
      });
    }
  }

  checkValidation() {
    if (phone.text.length > 10) {
      showToast("الهاتف الذي تم إدخاله غير صحيح");
      allValid = false;
    } else if (location.text.isEmpty || oldVal() == null) {
      showToast("المدينة التي تم إدخالها غير صحيحة");
      allValid = false;
    } else if (subject.text.isEmpty && type == 'Tutor') {
      showToast('التخصص المدخل غير صحيح');
      allValid = false;
    } else if (degree.text.isEmpty && type == 'Tutor') {
      showToast('المادة  الذي تم إدخالها غير صحيح');
      allValid = false;
    } else if (address.text.isEmpty && type == 'Tutor') {
      showToast('العنوان / الحي  المدخل غير صحيح');
      allValid = false;
    } else if (((isOnlineLesson && onlineLessonPrice.text.isEmpty) &&
            type == 'Tutor') ||
        ((isStudentHomeLesson && studentsHomeLessonPrice.text.isEmpty) &&
            type == 'Tutor') ||
        ((isTutorHomeLesson && tutorsHomeLessonPrice.text.isEmpty) &&
            type == 'Tutor')) {
      showToast('تأكد من إدخال السعر بشكل صحيح');
      allValid = false;
    } else if ((!isOnlineLesson && type == 'Tutor') &&
        (!isStudentHomeLesson && type == 'Tutor') &&
        (!isTutorHomeLesson && type == 'Tutor')) {
      showToast('تأكد من إدخال السعر بشكل صحيح');
      allValid = false;
    } //else if (bio.text.isEmpty && type == 'Tutor') {
    // showToast(' المدخل غير صحيح');
    // allValid = false;
    //}
    else {
      allValid = true;
    }
    if (mounted) setState(() {});
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

  oldVal() {
    if (citiesList.contains(location.text)) {
      return location.text;
    } else {
      return null;
    }
  }

  // =============================================
  // =============== Profile Image ===============
  // =============================================
  imageBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: theme.bgColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Wrap(
                children: <Widget>[
                  Center(
                      child: Text(
                    'اختر المصدر',
                    style: TextStyle(fontSize: 20, fontFamily: 'cb'),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.5, 0.5],
                              colors: [Colors.purple, Colors.purple.shade400],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Icon(
                              Icons.image_outlined,
                              color: theme.bgColor,
                            ),
                          ),
                        ),
                        title: Text('معرض الصور'),
                        onTap: () {
                          Navigator.pop(context);
                          avatarGallery(context);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.5, 0.5],
                                colors: [Colors.pink, Colors.pink.shade400])),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: theme.bgColor,
                          ),
                        ),
                      ),
                      title: Text('الكاميرا'),
                      onTap: () {
                        Navigator.pop(context);
                        avatarCamera(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future avatarCamera(BuildContext context) async {
    final dynamic image = await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
      imageQuality: 60,
    );
    if (image != null) {
      img = File(image.path);
      imageSelected = true;
      if (mounted) setState(() {});
    }
  }

  Future avatarGallery(BuildContext context) async {
    final dynamic image = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );
    if (image != null) {
      img = File(image.path);
      imageSelected = true;
      if (mounted) setState(() {});
    }
  }

  uploadFile() async {
    UploadTask? uploadTask;
    String date = DateTime.now().microsecondsSinceEpoch.toString();
    String fileName = 'files/' + date;
    final storageRef = FirebaseStorage.instance.ref(fileName);
    uploadTask = storageRef.putFile(img);
    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    return urlDownload;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context, userData),
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
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => imageBottomSheet(context),
                    child: Center(
                      child: Container(
                        height: 110,
                        width: 130,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 15,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: !imageSelected
                                    ? CachedNetworkImage(
                                        imageUrl: userData.avatar,
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        img,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: kBlueColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: theme.whiteColor,
                                  size: 22,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  Text('رقم الجوال'),
                  SizedBox(
                    height: screenWidth * 12.5,
                    width: double.infinity,
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {},
                      countries: ["SA"],
                      maxLength: 9,
                      inputBorder: InputBorder.none,
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
                        phoneNumber: "XXXXXXXXX",
                        dialCode: "+966",
                        isoCode: "SA",
                      ),
                      textFieldController: phone,
                      formatInput: false,
                      inputDecoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 4,
                          vertical: screenWidth * 3,
                        ),
                        hintText: 'XXXXXXXXX',
                        hintStyle: textStyle(
                          screenWidth * 3.3,
                          theme.lightTextColor,
                        ),
                        filled: true,
                        fillColor: theme.fillColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: .3,
                            color: theme.lightTextColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: .6,
                            color: theme.redColor,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                    ),
                  ),
                  (!phone.text.startsWith('5') && phone.text.isNotEmpty)
                      ? Row(
                          children: [
                            text(
                              "يجب أن يبدأ الهاتف بالرقم 5",
                              screenWidth * 2.7,
                              theme.redColor,
                            )
                          ],
                        )
                      : Container(),
                  SizedBox(height: 20),
                  Text('المدينة'),
                  SizedBox(
                    height: screenWidth * 12.5,
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      value: oldVal(),
                      items: citiesList.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_selectedValue) async {
                        var tempCity = await cities.where((element) =>
                            (element['name_ar'] == _selectedValue));
                        var tempArea = await areas.where((element) =>
                            (element['city_id'] == tempCity.first['city_id']));
                        _addressKey.currentState?.reset();
                        areasList.clear();
                        areasList.addAll(tempArea);
                        location.text = _selectedValue.toString();
                        if (mounted) setState(() {});
                      },
                      style: textStyle(screenWidth * 3.7, theme.mainColor),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 4,
                            vertical: screenWidth * 3),
                        hintText: 'الرياض',
                        hintStyle:
                            textStyle(screenWidth * 3.3, theme.lightTextColor),
                        filled: true,
                        fillColor: theme.fillColor,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                width: .3, color: theme.lightTextColor)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: .6,
                            color: theme.yellowColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('العنوان / الحي'),
                  SizedBox(
                    height: screenWidth * 12.5,
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      key: _addressKey,
                      items: areasList.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value['name_ar']),
                        );
                      }).toList(),
                      onChanged: (dynamic _selectedValue) {
                        address.text = _selectedValue['name_ar'].toString();
                        print(address.text);
                        if (mounted) setState(() {});
                      },
                      style: textStyle(screenWidth * 3.7, theme.mainColor),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 4,
                            vertical: screenWidth * 3),
                        hintText: address.text,
                        hintStyle:
                            textStyle(screenWidth * 3.3, theme.lightTextColor),
                        filled: true,
                        fillColor: theme.fillColor,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                width: .3, color: theme.lightTextColor)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: .6,
                            color: theme.yellowColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Additional only for tutor
                  if (type == 'Tutor')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('التخصص'),
                        SizedBox(
                          height: screenWidth * 12.5,
                          width: double.infinity,
                          child: TextFormField(
                            controller: subject,
                            style:
                                textStyle(screenWidth * 3.7, theme.mainColor),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 4,
                                  vertical: screenWidth * 3),
                              hintText: '',
                              hintStyle: textStyle(
                                  screenWidth * 3.3, theme.lightTextColor),
                              filled: true,
                              fillColor: theme.fillColor,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: .3, color: theme.lightTextColor)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: .6,
                                  color: theme.yellowColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text('المادة'),
                        Container(
                          width: double.infinity,
                          child: DropdownSearch<String>.multiSelection(
                            items: subjects,
                            selectedItems: values,
                            onChanged: (value) {
                              values = value;
                              degree.text = jsonEncode(values);
                              if (mounted) setState(() {});
                            },
                            dropdownSearchDecoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 4,
                                vertical: screenWidth * 2,
                              ),
                              hintStyle: textStyle(
                                  screenWidth * 3.3, theme.lightTextColor),
                              hintText: 'إضافة مادة أخرى',
                              filled: true,
                              fillColor: theme.fillColor,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: .3,
                                  color: theme.lightTextColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: .6,
                                  color: theme.yellowColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            text(
                              'نوع الدروس',
                              screenWidth * 3,
                              theme.lightTextColor,
                              fontFamily: 'cb',
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 35,
                                    child: CheckboxListTile(
                                      value: isOnlineLesson,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      contentPadding: EdgeInsets.all(0),
                                      shape: CircleBorder(),
                                      onChanged: (value) {
                                        isOnlineLesson = value!;
                                        if (mounted) setState(() {});
                                      },
                                      title: Text(
                                        'أون لاين',
                                        style: TextStyle(
                                          fontSize: screenWidth * 3,
                                          color: theme.lightTextColor,
                                          fontFamily: 'cb',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  width: 110,
                                  child: TextFormField(
                                    controller: onlineLessonPrice,
                                    inputFormatters: [
                                      DecimalTextInputFormatter(decimalRange: 1)
                                    ],
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    style: textStyle(
                                        screenWidth * 3.7, theme.mainColor),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 4,
                                          vertical: screenWidth * 1.5),
                                      hintText: 'ريال/ساعة',
                                      hintStyle: textStyle(screenWidth * 3.3,
                                          theme.lightTextColor),
                                      filled: true,
                                      fillColor: theme.fillColor,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 200),
                                        borderSide: BorderSide(
                                            width: .3,
                                            color: theme.lightTextColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 200),
                                        borderSide: BorderSide(
                                          width: .6,
                                          color: theme.yellowColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 35,
                                    child: CheckboxListTile(
                                      value: isStudentHomeLesson,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      contentPadding: EdgeInsets.all(0),
                                      shape: CircleBorder(),
                                      onChanged: (value) {
                                        isStudentHomeLesson = value!;
                                        if (mounted) setState(() {});
                                      },
                                      title: Text(
                                        'حضوري (مكان الطالب)',
                                        style: TextStyle(
                                          fontSize: screenWidth * 3,
                                          color: theme.lightTextColor,
                                          fontFamily: 'cb',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  width: 110,
                                  child: TextFormField(
                                    controller: studentsHomeLessonPrice,
                                    inputFormatters: [
                                      DecimalTextInputFormatter(decimalRange: 1)
                                    ],
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    style: textStyle(
                                        screenWidth * 3.7, theme.mainColor),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 4,
                                          vertical: screenWidth * 1.5),
                                      hintText: 'ريال/ساعة',
                                      hintStyle: textStyle(screenWidth * 3.3,
                                          theme.lightTextColor),
                                      filled: true,
                                      fillColor: theme.fillColor,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 200),
                                        borderSide: BorderSide(
                                            width: .3,
                                            color: theme.lightTextColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 200),
                                        borderSide: BorderSide(
                                          width: .6,
                                          color: theme.yellowColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 35,
                                    child: CheckboxListTile(
                                      value: isTutorHomeLesson,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      contentPadding: EdgeInsets.all(0),
                                      shape: CircleBorder(),
                                      onChanged: (value) {
                                        isTutorHomeLesson = value!;
                                        if (mounted) setState(() {});
                                      },
                                      title: Text(
                                        'حضوري (مكان المعلم)',
                                        style: TextStyle(
                                          fontSize: screenWidth * 3,
                                          color: theme.lightTextColor,
                                          fontFamily: 'cb',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  width: 110,
                                  child: TextFormField(
                                    controller: tutorsHomeLessonPrice,
                                    inputFormatters: [
                                      DecimalTextInputFormatter(decimalRange: 1)
                                    ],
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    style: textStyle(
                                        screenWidth * 3.7, theme.mainColor),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 4,
                                          vertical: screenWidth * 1.5),
                                      hintText: 'ريال/ساعة',
                                      hintStyle: textStyle(screenWidth * 3.3,
                                          theme.lightTextColor),
                                      filled: true,
                                      fillColor: theme.fillColor,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 200),
                                        borderSide: BorderSide(
                                            width: .3,
                                            color: theme.lightTextColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 200),
                                        borderSide: BorderSide(
                                          width: .6,
                                          color: theme.yellowColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  Text('نبذه عني'),
                  SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: bio,
                      maxLines: 6,
                      style: textStyle(screenWidth * 3.7, theme.mainColor),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 4,
                          vertical: screenWidth * 3,
                        ),
                        hintStyle: textStyle(
                          screenWidth * 3.3,
                          theme.lightTextColor,
                        ),
                        filled: true,
                        fillColor: theme.fillColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 5),
                          borderSide: BorderSide(
                              width: .3, color: theme.lightTextColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 5),
                          borderSide: BorderSide(
                            width: .6,
                            color: theme.yellowColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.blueColor,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            update();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin:
                                EdgeInsets.symmetric(vertical: screenWidth * 2)
                                    .copyWith(bottom: 0),
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 4,
                                vertical: screenWidth * 3),
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.mainColor),
                              borderRadius: BorderRadius.circular(10),
                              color: theme.blueColor,
                            ),
                            child: text(
                              'تحديث',
                              screenWidth * 3.9,
                              theme.whiteColor,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
