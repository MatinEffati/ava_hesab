import 'package:ava_hesab/core/di/service_locator.dart';
import 'package:ava_hesab/feature/login/data/model/captcha_model.dart';
import 'package:ava_hesab/feature/login/data/source/login_data_source.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool loadingCaptcha = false.obs;
  Rx<CaptchaModel> captchaModel = CaptchaModel().obs;

  @override
  void onInit() async {
    super.onInit();
    loadingCaptcha.value = true;
    captchaModel.value = await getCaptcha();
    loadingCaptcha.value = false;
  }

  void refreshCaptcha() async {
    loadingCaptcha.value = true;
    captchaModel.value = await getCaptcha(); // Reload the data
    loadingCaptcha.value = false;
  }

  Future<CaptchaModel> getCaptcha() async {
    return await getIt<ILoginDataSource>().captcha();
  }
}
