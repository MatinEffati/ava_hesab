import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ava_hesab/core/database/boxes.dart';
import 'package:ava_hesab/core/network/failure.dart';
import 'package:ava_hesab/core/network/network.dart';
import 'package:ava_hesab/feature/login/data/model/auth_model.dart';
import 'package:ava_hesab/feature/login/data/model/captcha_model.dart';
import 'package:ava_hesab/feature/login/data/model/otp_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class ILoginDataSource {
  Future<Either<Failure, void>> loginWithUsername(
    String username,
    String password,
    String captcha,
    String captchaId,
  );

  Future<Either<Failure, OtpModel>> loginWithUOTP(
    String mobile,
    String captcha,
    String captchaId,
  );

  Future<Either<Failure, void>> verifyOTP(
    String mobile,
    String code,
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
    // Remove square brackets if they exist
    captchaId = captchaId.replaceAll('[', '').replaceAll(']', '');
    return CaptchaModel(captcha: file, captchaId: captchaId);
  }

  @override
  Future<Either<Failure, void>> loginWithUsername(
    String username,
    String password,
    String captcha,
    String captchaId,
  ) async {
    try {
      var response = await networkClient.postRequest('customer/login', variables: {
        "captcha": captcha,
        "captchaId": captchaId,
        "password": password,
        "username": username,
      });
      var authFromJson = AuthModel.fromJson(response.data);
      var authBox = HiveBoxes.getAuthBox();
      authBox.clear();
      authBox.put('authBox', authFromJson);
      return const Right(null);
    } on DioException catch (e) {
      return Left(Failure.fromJson(e.response!.data));
    }
  }

  @override
  Future<Either<Failure, OtpModel>> loginWithUOTP(String mobile, String captcha, String captchaId) async {
    try {
      var response = await networkClient.postRequest('customer/login/otp/request', variables: {
        "captcha": captcha,
        "captchaId": captchaId,
        "mobile": mobile,
      });
      return Right(OtpModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(Failure.fromJson(e.response!.data));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOTP(String mobile, String code) async{
    try {
      var response = await networkClient.postRequest('customer/login/otp/verify', variables: {
        "mobile": mobile,
        "code": code,
      });
      var authFromJson = AuthModel.fromJson(response.data);
      var authBox = HiveBoxes.getAuthBox();
      authBox.clear();
      authBox.put('authBox', authFromJson);
      return const Right(null);
    } on DioException catch (e) {
      return Left(Failure.fromJson(e.response!.data));
    }
  }
}
