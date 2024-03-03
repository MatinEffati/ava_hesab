import 'package:hive_flutter/hive_flutter.dart';

part 'first_time.g.dart';

@HiveType(typeId: 1)
class FirstTime {
  @HiveField(0)
  bool isFirstTime = true;

  FirstTime({required this.isFirstTime});
}
