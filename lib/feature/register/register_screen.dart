import 'package:ava_hesab/config/app_colors.dart';
import 'package:ava_hesab/core/widgets/ava_loading_button.dart';
import 'package:ava_hesab/core/widgets/normal_app_bar.dart';
import 'package:ava_hesab/core/widgets/snack_bar_widget.dart';
import 'package:ava_hesab/feature/register/controller/register_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController registerController = Get.put(RegisterController());
  TextEditingController mobileOTPController = TextEditingController(text: '09336329689');
  TextEditingController captchaController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NormalAppBar(title: 'ثبت نام'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(32, 48, 32, 48),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 0.5, color: AppColorsLight.borderDefault),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(3, 7), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'از دیدن شما خوشحالم! لطفا ثبت نام کنید.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    enabled: !registerController.isShowOTPFields.value,
                    controller: mobileOTPController,
                    decoration: const InputDecoration(label: Text('شماره موبایل خود را وارد کنید')),
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => Visibility(
                      visible: registerController.isShowOTPFields.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'کد تایید را وارد کنید',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColorsLight.textLightSoft),
                          ),
                          const SizedBox(height: 8),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Pinput(
                              keyboardType: TextInputType.number,
                              forceErrorState: showError,
                              length: 6,
                              controller: otpCodeController,
                              defaultPinTheme: defaultPinTheme,
                              focusedPinTheme: defaultPinTheme.copyWith(
                                height: 68,
                                width: 64,
                                decoration: defaultPinTheme.decoration!.copyWith(
                                  border: Border.all(color: AppColorsLight.primaryColor),
                                ),
                              ),
                              errorPinTheme: defaultPinTheme.copyWith(
                                decoration: BoxDecoration(
                                  color: errorColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  Obx(() {
                    return registerController.loadingCaptcha.value
                        ? const CupertinoActivityIndicator()
                        : Visibility(
                            visible: registerController.resendTimer.value == 0,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: captchaController,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                registerController.captchaForOTP.value.captcha != null
                                    ? Image.file(
                                        registerController.captchaForOTP.value.captcha!,
                                        width: 82,
                                        height: 32,
                                      )
                                    : Container(), // Placeholder or alternate content for null captcha
                                const SizedBox(width: 12),
                                InkWell(
                                  onTap: () {
                                    captchaController.clear();
                                    registerController.refreshCaptchaOTP();
                                  },
                                  child: const Icon(Icons.refresh),
                                ),
                              ],
                            ),
                          );
                  }),
                  Obx(() {
                    return Visibility(
                      visible: registerController.isShowOTPFields.value,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          InkWell(
                              onTap: registerController.isOnResendOTP.value
                                  ? () async {
                                      await registerController
                                          .register(
                                            mobileOTPController.text,
                                            captchaController.text,
                                            registerController.captchaForOTP.value.captchaId!,
                                          )
                                          .then((value) => snackBarWithoutButton(context, value));
                                      captchaController.clear();
                                    }
                                  : null,
                              child: Text(
                                'ارسال مجدد کد',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: registerController.isOnResendOTP.value
                                        ? AppColorsLight.primaryColor
                                        : AppColorsLight.textSoft),
                              )),
                          const SizedBox(height: 8),
                          Visibility(
                            visible: registerController.resendTimer.value != 0,
                            child: Text(
                              'ارسال مجدد کد ${registerController.resendTimer} دیگر',
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColorsLight.textSoft),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  Obx(() => AvaLoadingButton(
                        title: registerController.isShowOTPFields.value ? 'تایید کد' : 'ارسال کد',
                        isLoading: registerController.isLoadingLoginOTPButton.value,
                        onPressed: () async {
                          if (registerController.isShowOTPFields.value) {
                            await registerController
                                .verifyOTP(mobileOTPController.text, otpCodeController.text)
                                .then((value) => snackBarWithoutButton(context, value));
                          } else {
                            await registerController
                                .register(
                                  mobileOTPController.text,
                                  captchaController.text,
                                  registerController.captchaForOTP.value.captchaId!,
                                )
                                .then((value) => snackBarWithoutButton(context, value));
                            captchaController.clear();
                          }
                        },
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool showError = false;
  final length = 6;
  final borderColor = const Color.fromRGBO(114, 178, 238, 1);
  final errorColor = const Color.fromRGBO(255, 234, 238, 1);
  final fillColor = const Color.fromRGBO(222, 231, 240, .57);
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    decoration: BoxDecoration(
      border: Border.all(color: AppColorsLight.borderDefault),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
