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

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authProvider = AuthProvider();

  // This widget is the root of your application.
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
              // create: (context) => NavigationProvider(),
              child: Consumer<AuthProvider>(
                builder: (context, value, child) {
                  return MultiProvider(
                    providers: [
                      ChangeNotifierProvider<AuthProvider>.value(
                          value: authProvider),
                      // ChangeNotifierProvider<ApiBloc>.value(value: _apiBloc),
                    ],
                    child: GetMaterialApp(
                      localizationsDelegates: [
                        GlobalMaterialLocalizations.delegate
                      ],
                      supportedLocales: [
                        const Locale('en'),
                        const Locale('ar')
                      ],
                      // useInheritedMediaQuery: true,
                      // locale: DevicePreview.locale(context),
                      // builder: DevicePreview.appBuilder,
                      debugShowCheckedModeBanner: false,
                      home: SplashScreen(),
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
