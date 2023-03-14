import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/home_page.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';

class EditTutorScreen extends StatefulWidget {
  const EditTutorScreen({super.key});

  @override
  State<EditTutorScreen> createState() => _EditTutorScreenState();
}

class _EditTutorScreenState extends State<EditTutorScreen> {
  UserData userData = emptyUserData;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController location = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController subject = new TextEditingController();
  TextEditingController degree = new TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  getMyData() async {
    FirestoreHelper.getMyUserData().then((value) {
      setState(() {
        userData = value;
      });
    });
  }

  @override
  void initState() {
    getMyData();
    super.initState();
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
                "are you sure?",
                style: headingTextStyle,
              ),
              Spacer(),
              const SizedBox(
                height: 1,
              ),
              _buildBottomSheetButton(
                label: "edit ",
                onTap: () {
                  updateUser();
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

  updateUser() async {
    setState(() {
      isLoading = true;
    });

    print('location;;;' + location.text);
    print('username;;;;' + username.text);
    print('phone///' + phone.text);
    print('subject' + subject.text);
    print('' + degree.text);

    await db.collection("Users").doc(userData.userId).update({
      "location": location.text.length > 0 ? location.text : userData.location,
      "username": username.text.length > 0 ? username.text : userData.username,
      "phone": phone.text.length > 0 ? phone.text : userData.phone,
      "majorSubjects":
          subject.text.length > 0 ? subject.text : userData.majorSubjects,
      "degree": degree.text.length > 0 ? degree.text : userData.degree,
    });
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);

    getMyData();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'تعديل ملفي الشخصي',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.accents[0].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Center(
                              child: ListView(
                                shrinkWrap: true,
                                padding:
                                    EdgeInsets.only(left: 12.0, right: 12.0),
                                children: [
                                  Center(
                                    child: Text(
                                      'تعديل ملفي الشخصي',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'cb',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: TextFormField(
                                      controller: username,
                                      keyboardType: TextInputType.text,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        hintText: userData.username +
                                            ': اسم المستخدم ',
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 10.0),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: TextFormField(
                                      controller: location,
                                      keyboardType: TextInputType.text,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        hintText:
                                            userData.location + ': الموقع  ',
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 10.0),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      autofocus: false,
                                      controller: phone,
                                      decoration: InputDecoration(
                                        hintText:
                                            userData.phone + ' : رقم الهاتف ',
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 10.0),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      autofocus: false,
                                      controller: subject,
                                      decoration: InputDecoration(
                                        hintText:
                                            userData.majorSubjects + ':المادة ',
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 10.0),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: TextFormField(
                                      controller: degree,
                                      keyboardType: TextInputType.text,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        hintText: userData.degree +
                                            ' : المؤاهل العلمي',
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 10.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            )),
                        Divider(),
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return const HomePage();
                                  },
                                ));
                              },
                              child: Text('تحديد الاوقات المتاحة'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              onPressed: () {
                                _showBottomdelet(context);
                              },
                              child: Text('تحديث'),
                            )
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      )),
    );
  }
}
