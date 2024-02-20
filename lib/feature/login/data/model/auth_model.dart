import 'package:hive/hive.dart';

part 'auth_model.g.dart';

@HiveType(typeId: 0)
class AuthModel {
  @HiveField(0)
  final String token;

  AuthModel({required this.token});

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(token: json['token']);
}
