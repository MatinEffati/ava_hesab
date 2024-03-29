import 'dart:async';

import 'package:ava_hesab/core/di/service_locator.dart';
import 'package:ava_hesab/core/network/failure.dart';
import 'package:ava_hesab/feature/login/data/model/captcha_model.dart';
import 'package:ava_hesab/feature/login/data/source/login_data_source.dart';
import 'package:ava_hesab/feature/register/data/source/register_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  RxBool loadingCaptcha = false.obs;
  RxBool isLoadingLoginUsernameButton = false.obs;
  RxBool isLoadingLoginOTPButton = false.obs;
  RxBool isLoadingFinishRegisterButton = false.obs;
  RxBool isShowOTPFields = false.obs;
  RxBool isOnResendOTP = false.obs;
  RxInt resendTimer = 0.obs;
  Rx<CaptchaModel> captchaForOTP = CaptchaModel().obs;
  late Timer timer;

  @override
  void onInit() async {
    super.onInit();
    loadingCaptcha.value = true;
    captchaForOTP.value = await getCaptcha();
    loadingCaptcha.value = false;
  }

  void refreshCaptchaOTP() async {
    loadingCaptcha.value = true;
    captchaForOTP.value = await getCaptcha();
    loadingCaptcha.value = false;
  }

  Future<CaptchaModel> getCaptcha() async {
    return await getIt<IRegisterDataSource>().captcha();
  }

  Future<String> register(String mobile, String captcha, String captchaId) async {
    isLoadingLoginOTPButton.value = true;
    var response = await getIt<IRegisterDataSource>().register(mobile, captcha, captchaId);
    isLoadingLoginOTPButton.value = false;
    return response.fold((l) {
      isShowOTPFields.value = false;
      return l.message!;
    }, (r) {
      resendTimer.value = r.expiresIn!;
      isOnResendOTP.value = false;
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (resendTimer.value == 0) {
          refreshCaptchaOTP();
          isOnResendOTP.value = true;
          timer.cancel();
        } else {
          resendTimer.value--;
        }
      });
      isShowOTPFields.value = true;
      return r.message!;
    });
  }

  Future<Either<Failure, String>> verifyOTP(String mobile, String code) async {
    isLoadingLoginOTPButton.value = true;
    var response = await getIt<IRegisterDataSource>().verifyOTP(mobile, code);
    isLoadingLoginOTPButton.value = false;
    return response;
  }

  Future<String> finishRegister(
    String code,
    String firstName,
    String lastName,
    String mobile,
    String password,
    String passwordConfirmation,
  ) async {
    isLoadingFinishRegisterButton.value = true;
    var response = await getIt<IRegisterDataSource>().finishRegister(
      code,
      firstName,
      lastName,
      mobile,
      password,
      passwordConfirmation,
    );
    isLoadingFinishRegisterButton.value = false;
    return response.fold((l) => l.message!, (r) => r);
  }
}
