import 'package:Dhyaa/models/UserData.dart';

class Singleton {
  static Singleton? _instance;

  Singleton._();

  static Singleton get instance => _instance ??= Singleton._();

  UserData? userData;
  String? userId;
}