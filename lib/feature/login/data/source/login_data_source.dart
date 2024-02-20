import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ava_hesab/core/network/failure.dart';
import 'package:ava_hesab/core/network/network.dart';
import 'package:ava_hesab/feature/login/data/model/captcha_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class ILoginDataSource {
  Future<Either<Failure, void>> loginWithUsername(
    String username,
    String password,
    String captcha,
    String captchaId,
  );

  Future<CaptchaModel> captcha();
}

class LoginDataSource extends ILoginDataSource {
  final NetworkClient networkClient;

  LoginDataSource({required this.networkClient});

  @override
  Future<CaptchaModel> captcha() async {
    // Define the Dio instance
    Dio dio = Dio();
    // URL of the image to download
    String imageUrl = "https://www.avahesab.com/api/v1/captcha";
    // Fetch the image data
    Response response = await dio.get(imageUrl, options: Options(responseType: ResponseType.bytes));
    // Convert the response body to Uint8List
    Uint8List bytes = Uint8List.fromList(response.data);
    // Create a File instance and write the image data to it
    String tempPath = Directory.systemTemp.path;
    File file = File('$tempPath/${Random().nextInt(1000)}.png');
    await file.writeAsBytes(bytes);
    String captchaId = response.headers['Captchaid'].toString();
    return CaptchaModel(captcha: file, captchaId: captchaId);
  }

  @override
  Future<Either<Failure, void>> loginWithUsername(String username, String password, String captcha, String captchaId) {
    // TODO: implement loginWithUsername
    throw UnimplementedError();
  }

  // @override
  // Future<Either<Failure, void>> loginWithUsername(String username, String password, String captcha, String captchaId) {
  //   var response  = networkClient.postRequest('customer/login', variables: {
  //     "captcha": captcha,
  //     "captchaId": captchaId,
  //     "password": password,
  //     "username": username,
  //   });
  // }
}
