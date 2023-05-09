import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Dhyaa/globalWidgets/toast.dart';
import 'package:Dhyaa/screens/student/student_homepage.dart';
import 'package:Dhyaa/screens/tutor/tutor_homepage.dart';

class AuthProvider extends ChangeNotifier {
  final tutorUsername = TextEditingController();
  final tutorEmail = TextEditingController();
  final tutorPassword = TextEditingController();
  final tutorPhoneNumber = TextEditingController();
  final tutorMajor = TextEditingController();
  final tutorDegree = TextEditingController();
  final tutorLocation = TextEditingController();
  final tutorPrice = TextEditingController();
  final tutorAddress = TextEditingController();
  bool isOnlineLesson = true;
  bool isStudentHomeLesson = false;
  bool isTutorHomeLesson = false;
  final onlineLessonPrice = TextEditingController();
  final studentsHomeLessonPrice = TextEditingController();
  final tutorsHomeLessonPrice = TextEditingController();

  String degree = '';

  final studentUserName = TextEditingController();
  final studentEmail = TextEditingController();
  final studentPassword = TextEditingController();
  final studentPhoneNumber = TextEditingController();
  final studentLocation = TextEditingController();
  final studentAddress = TextEditingController();

  List<String> categoryList = [
    "Art",
    "Beverages",
    "Beauty",
    "Fashion",
    "Fitness",
    "Food",
    "Health/Wellness",
    "Home",
    "Media",
    "Other",
    "General Store"
  ];
  List<String> countryList = [
    "Australia",
    "Austria",
    "Belgium",
    "Canada",
    "Croatia",
    "Denmark",
    "Finland",
    "France",
    "Germany",
    "Greece",
    "Ireland",
    "Italy",
    "Lithuania",
    "Netherlands",
    "New Zealand",
    "Norway",
    "Portugal",
    "Spain",
    "Sweden",
    "Switzerland",
    "United Kingdom"
  ];

  String onCountry(String country) {
    String countryCode = "";
    switch (country) {
      case "Australia":
        countryCode = "AU";
        break;
      case "Austria":
        countryCode = "AT";
        break;
      case "Belgium":
        countryCode = "BE";
        break;
      case "Canada":
        countryCode = "CA";
        break;
      case "Croatia":
        countryCode = "HR";
        break;
      case "Denmark":
        countryCode = "DK";
        break;
      case "Finland":
        countryCode = "FI";
        break;
      case "France":
        countryCode = "FR";
        break;
      case "Germany":
        countryCode = "DE";
        break;
      case "Greece":
        countryCode = "GR";
        break;
      case "Ireland":
        countryCode = "IE";
        break;
      case "Italy":
        countryCode = "IT";
        break;
      case "Lithuania":
        countryCode = "LT";
        break;
      case "Netherlands":
        countryCode = "NL";
        break;
      case "New Zealand":
        countryCode = "NZ";
        break;
      case "Norway":
        countryCode = "NO";
        break;
      case "Portugal":
        countryCode = "PT";
        break;
      case "Spain":
        countryCode = "ES";
        break;
      case "Sweden":
        countryCode = "SE";
        break;
      case "Switzerland":
        countryCode = "CH";
        break;
      case "United Kingdom":
        countryCode = "GB";
        break;
    }
    return countryCode;
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  String? countryOfOperationsValue;
  String? categoryValue;
  bool onlineBusiness = false;
  bool terms = false;

  static final userFormKey = GlobalKey<FormState>();
  static final loginFormKey = GlobalKey<FormState>();
  bool isLoading = false;

  final FirebaseFirestore db = FirebaseFirestore.instance;
  String? path;
  CollectionReference? ref;

  register(context, type) async {
    try {
      isLoading = true;
      notifyListeners();
      UserCredential? userCredential;
      if (type == "Student") {
        userCredential = await auth.createUserWithEmailAndPassword(
            email: studentEmail.text, password: studentPassword.text);
        final User user = userCredential.user!;
        await addUser(user, context, type);
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(
            email: tutorEmail.text, password: tutorPassword.text);
        final User user = userCredential.user!;
        await addUser(user, context, type);
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      if (e.code == 'weak-password') {
        showToast('كلمة المرور المستخدمة ضعيفة ');
      } else if (e.code == 'email-already-in-use') {
        showToast('البريد الإلكتروني مسجل مسبقًا');
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print(e);
    }
  }

  Future<User?> handleSignInEmail(context, email, password, String type) async {
    try {
      isLoading = true;
      notifyListeners();
      UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User user = result.user!;

      Map<String, dynamic> userData =
          await doesNameAlreadyExist(user.uid, "Users");
      if (userData["active_status"] == "مفعل") {
        if (userData["type"] == type) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('type', type);
          await prefs.setString('user', email);
          if (type == "Student") {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => StudentHomepage(),
                ),
                (Route<dynamic> route) => false);
          } else if (type == "Tutor") {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => TutorHomepage(),
                ),
                (Route<dynamic> route) => false);
          }
        } else {
          showToast("نوع المستخدم غير صحيح", isSuccess: false);
        }
      } else {
        showToast("حسابك متوقف", isSuccess: false);
      }

      isLoading = false;
      notifyListeners();
      return user;
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      if (e.code == "user-not-found") {
        showToast("لم يتم العثور على المستخدم", isSuccess: false);
      } else if (e.code == "موقوف") {
        showToast("حسابك متوقف", isSuccess: false);
      } else {
        showToast("تأكد من إدخال البريد الإلكتروني وكلمة المرور الصحيحين.");
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  // Apple Sign in

  // pick image camera

  // Future<File> imgFromGallery(image) async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //
  //   // setState(() {
  //   if (pickedFile != null) {
  //     image = File(pickedFile.path);
  //     // uploadFile(image);
  //   }
  //   return File(pickedFile!.path);
  //   // });
  // }
  //
  // Future<File> imgFromCamera(image) async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.camera);
  //
  //   // setState(() {
  //   if (pickedFile != null) {
  //     image = File(pickedFile.path);
  //     notifyListeners();
  //   }
  //   return File(pickedFile!.path);
  //   // });
  // }

  // Future<String?> uploadFile(
  //   File? image,
  // ) async {
  //   isLoading = true;
  //   notifyListeners();
  //   String? uploaded;
  //   if (image == null) return "";
  //   final fileName = basename(image.path);
  //   final destination = 'files/$fileName';
  //
  //   try {
  //     final ref = firebase_storage.FirebaseStorage.instance
  //         .ref(destination)
  //         .child('file/');
  //     // await ref.putFile(image);
  //     firebase_storage.UploadTask uploadTask = ref.putFile(image);
  //     uploadTask.then((res) async {
  //       uploaded = await res.ref.getDownloadURL();
  //     });
  //     return uploaded;
  //   } catch (e) {
  //     print('error occured');
  //   }
  // }

  // get current location

  // late locc.Location locationObj;
  // void getCurrentLocation(BuildContext context) async {
  //   // if (await locationObj.requestService()) {
  //   //   if (await locationObj.serviceEnabled()) {
  //   //     if (await Permission.locationWhenInUse.status.isGranted) {
  //   //       print('I am after request provided getCurrentLocation');
  //   //       isLoading = true;
  //   //       placeMarkerOnCurrentLocation();
  //   //     } else if (await Permission.location.request().isGranted) {
  //   try {
  //     placeMarkerOnCurrentLocation();
  //   } catch (e) {
  //     showToast("${e}");
  //   }
  //   //     } else {
  //   //       //Show dilogue user current permission denied
  //   //       locationRequireDialog(context);
  //   //     }
  //   //   } else {
  //   //     locationRequireDialog(context);
  //   //     //show dilogue service is not avail
  //   //   }
  //   // }
  // }
  //
  // void placeMarkerOnCurrentLocation() async {
  //   var loc = await locationObj.getLocation();
  //   // markers.clear();
  //
  //   print(loc.longitude);
  //   print(loc.latitude);
  //
  //   lat = loc.latitude;
  //   lng = loc.longitude;
  //
  //   // await mapController!
  //   //     .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //   //   target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
  //   //   zoom: 17.0,
  //   // )));
  //   // selectedLat = loc.latitude;
  //   // selectedLong = loc.longitude;
  //   placemarks = await placemarkFromCoordinates(loc.latitude!, loc.longitude!);
  //   address =
  //       '${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
  //   storeLocation.text = address!;
  //   // countryCode = placemarks.first.isoCountryCode;
  //
  //   notifyListeners();
  //
  //   // if (markers.isEmpty) {
  //   //   markers.add(Marker(
  //   //       markerId: const MarkerId('Current Location'),
  //   //       position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)));
  //   // }
  //   isLoading = false;
  // }

  Future addUser(User user, context, type) async {
    try {
      var result = db.collection("Users").doc(user.uid);
      if (type == "Student") {
        result.set({
          "email": studentEmail.text,
          "phone": "+966${studentPhoneNumber.text}",
          "location": studentLocation.text,
          "address": studentAddress.text,
          "username": studentUserName.text,
          "userId": user.uid,
          "type": 'Student',
          'majorSubjects': '',
          'degree': [],
          "isOnlineLesson": false,
          "isStudentHomeLesson": false,
          "isTutorHomeLesson": false,
          "onlineLessonPrice": '',
          "studentsHomeLessonPrice": '',
          "tutorsHomeLessonPrice": '',
          "bio": '',
          "active_status": 'مفعل',
        }).then((value) {
          studentUserName.clear();
          studentEmail.clear();
          studentPhoneNumber.clear();
          studentPassword.clear();
          studentLocation.clear();
          studentAddress.clear();
          isLoading = false;
          notifyListeners();
          showToast("تم تسجيلك كطالب");
          Navigator.pop(context);
        });
      } else {
        result.set({
          "email": tutorEmail.text,
          "phone": "+966${tutorPhoneNumber.text}",
          "username": tutorUsername.text,
          "userId": user.uid,
          "type": 'Tutor',
          'majorSubjects': tutorMajor.text,
          'degree': jsonDecode(tutorDegree.text),
          "location": tutorLocation.text,
          "address": tutorAddress.text,
          "isOnlineLesson": isOnlineLesson,
          "isStudentHomeLesson": isStudentHomeLesson,
          "isTutorHomeLesson": isTutorHomeLesson,
          "onlineLessonPrice": onlineLessonPrice.text,
          "studentsHomeLessonPrice": studentsHomeLessonPrice.text,
          "tutorsHomeLessonPrice": tutorsHomeLessonPrice.text,
          "bio": '',
          "active_status": 'مفعل',
        }).then((value) {
          tutorUsername.clear();
          tutorEmail.clear();
          tutorPassword.clear();
          tutorPhoneNumber.clear();
          tutorDegree.clear();
          tutorMajor.clear();
          tutorLocation.clear();
          tutorAddress.clear();
          onlineLessonPrice.clear();
          studentsHomeLessonPrice.clear();
          tutorsHomeLessonPrice.clear();
          isLoading = false;
          notifyListeners();
          showToast("تم تسجيلك كمعلم");
          Navigator.pop(context);
        });
      }
      return;
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      showToast("${e.code}");
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print(e);
    }
  }

  // Future<void> getUser(User user, context) async {
  //   UserDataProvider userDataProvider =
  //       Provider.of<UserDataProvider>(context, listen: false);
  //
  //   userDataProvider.businessModel =
  //       await userDataProvider.doesNameAlreadyExist(
  //     user.uid,
  //     "Users",
  //   );
  //   print("kjhkjhkjhkjhkjhkjhkjhkjh");
  //       if (userDataProvider.businessModel != null) {
  //     print("kjhkjhkjhkjhkjhkjhkjhkjh" +
  //         userDataProvider.businessModel!.userId.toString());
  //     if (userDataProvider.businessModel!.type == "user") {
  //       type = UserType.user;
  //     } else {
  //       type = UserType.business;
  //     }
  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(
  //             builder: (context) => Home(
  //                 user: user.uid,
  //                 businessModel: userDataProvider.businessModel)),
  //         (Route<dynamic> route) => false);
  //   }
  //
  //   // stars =await Provider.of<UserDataProvider>(context, listen: false).getStarsDocList(userDataProvider!.businessModel!.userId);
  //   // }else{
  //   //   await userDataProvider!.doesNameAlreadyExist(widget.user!.uid,"Businesses",widget.type);
  //   // }
  //   // await userDataProvider!.getBusinesses();
  // }
  //
  Future<Map<String, dynamic>> doesNameAlreadyExist(
      String userId, collection) async {
    final QuerySnapshot result = await db
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    Map<String, dynamic> data;
    if (documents.isNotEmpty) {
      data = documents[0].data() as Map<String, dynamic>;
    } else {
      data = {'type': ''};
    }
    return data;
  }

  //get user by username //do we still need it ?
  Future<List<DocumentSnapshot>> doesUserNameAlreadyExist(
      String username, collection) async {
    final QuerySnapshot result = await db
        .collection(collection)
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents;
  }
  //
  // Future<void> updateUser(BusinessModel businessModel, context) async {
  //   var result = db.collection("Users").doc(businessModel.userId);
  //
  //   result.update(businessModel.toJson()).then((value) async {
  //     final pro = Provider.of<UserDataProvider>(context, listen: false);
  //     pro.businessModel = await pro.doesNameAlreadyExist(
  //       businessModel.userId.toString(),
  //       "Users",
  //     );
  //     isLoading = false;
  //     notifyListeners();
  //     pro.notifyListeners();
  //     showToast("User Updated successful");
  //     Navigator.pop(context);
  //   });
  // }
}
