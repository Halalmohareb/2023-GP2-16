import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:Dhyaa/provider/auth_provider.dart';
import 'package:Dhyaa/screens/splashScreen/splash_screen.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/db/db_helper.dart';
import 'responsiveBloc/size_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Variables
  bool loading = true;
  dynamic bytes;
  final authProvider = AuthProvider();

  // functions
  memoryFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    bytes = byteData.buffer.asUint8List();
    loading = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    memoryFromAssets('images/intro.mp4');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return ChangeNotifierProvider<AuthProvider>.value(
              value: authProvider,
              child: Consumer<AuthProvider>(
                builder: (context, value, child) {
                  return MultiProvider(
                    providers: [
                      ChangeNotifierProvider<AuthProvider>.value(
                          value: authProvider),
                    ],
                    child: GetMaterialApp(
                      localizationsDelegates: [
                        GlobalMaterialLocalizations.delegate
                      ],
                      supportedLocales: [
                        const Locale('en'),
                        const Locale('ar')
                      ],
                      debugShowCheckedModeBanner: false,
                      home: Builder(builder: (context) {
                        MediaQueryData queryData = MediaQuery.of(context);
                        double w = queryData.size.width;
                        double h = queryData.size.height;
                        return loading
                            ? Container()
                            : SplashScreen(
                                path: bytes,
                                aspectRatio: h / 1.2 / w,
                              );
                      }),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
