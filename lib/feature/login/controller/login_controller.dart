import 'package:ava_hesab/core/di/service_locator.dart';
import 'package:ava_hesab/feature/login/data/model/captcha_model.dart';
import 'package:ava_hesab/feature/login/data/source/login_data_source.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool loadingCaptcha = false.obs;
  RxBool isLoadingLoginUsernameButton = false.obs;
  RxBool isLoadingLoginOTPButton = false.obs;
  RxBool isShowOTPFields = false.obs;
  Rx<CaptchaModel> captchaForUsername = CaptchaModel().obs;
  Rx<CaptchaModel> captchaForOTP = CaptchaModel().obs;

  @override
  void onInit() async {
    super.onInit();
    loadingCaptcha.value = true;
    captchaForUsername.value = await getCaptcha();
    captchaForOTP.value = await getCaptcha();
    loadingCaptcha.value = false;
  }

  void refreshCaptchaUsername() async {
    loadingCaptcha.value = true;
    captchaForUsername.value = await getCaptcha();
    loadingCaptcha.value = false;
  }

  void refreshCaptchaOTP() async {
    loadingCaptcha.value = true;
    captchaForOTP.value = await getCaptcha();
    loadingCaptcha.value = false;
  }

  Future<CaptchaModel> getCaptcha() async {
    return await getIt<ILoginDataSource>().captcha();
  }


  Future<String> loginWithUsername(String username, String password, String captcha, String captchaId) async {
    isLoadingLoginUsernameButton.value = true;
    var response = await getIt<ILoginDataSource>().loginWithUsername(username, password, captcha, captchaId);
    isLoadingLoginUsernameButton.value = false;
    return response.fold((l) => l.message!, (r) => 'ورود شما با موفقیت انجام شذ.');
  }


  Future<String> loginWithOTP(String mobile, String captcha, String captchaId) async {
    isLoadingLoginOTPButton.value = true;
    var response = await getIt<ILoginDataSource>().loginWithUOTP(mobile, captcha, captchaId);
    isLoadingLoginOTPButton.value = false;
    return response.fold((l) {
      isShowOTPFields.value = false;
      return l.message!;
    }, (r) {
      isShowOTPFields.value = true;
      return r;
    });
  }
}
