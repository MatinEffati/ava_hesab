import 'package:ava_hesab/feature/login/data/model/auth_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxes {
  static Box<AuthModel> getAuthBox() => Hive.box<AuthModel>("authBox");
}

Future<void> registerAdapterForBox() async {
  Hive.registerAdapter<AuthModel>(AuthModelAdapter());
  await Hive.openBox<AuthModel>('authBox');
}
