import 'package:ava_hesab/feature/login/data/model/auth_model.dart';
import 'package:ava_hesab/feature/splash/data/model/first_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxes {
  static Box<AuthModel> getAuthBox() => Hive.box<AuthModel>("authBox");
  static Box<FirstTime> getIsFirstTime() => Hive.box<FirstTime>("firstTimeBox");
}

Future<void> registerAdapterForBox() async {
  Hive.registerAdapter<AuthModel>(AuthModelAdapter());
  Hive.registerAdapter<FirstTime>(FirstTimeAdapter());
  await Hive.openBox<FirstTime>('firstTimeBox');
  await Hive.openBox<AuthModel>('authBox');
}
