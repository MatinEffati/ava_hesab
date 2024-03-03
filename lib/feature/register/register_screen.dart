import 'package:ava_hesab/config/app_colors.dart';
import 'package:ava_hesab/core/widgets/ava_loading_button.dart';
import 'package:ava_hesab/core/widgets/normal_app_bar.dart';
import 'package:ava_hesab/core/widgets/snack_bar_widget.dart';
import 'package:ava_hesab/feature/home/home_screen.dart';
import 'package:ava_hesab/feature/login/login_screen.dart';
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
                            var response =
                                await registerController.verifyOTP(mobileOTPController.text, otpCodeController.text);
                            response.fold((l) => snackBarWithoutButton(context, l.message!), (r) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FinishRegistration(
                                    registerController: registerController,
                                    mobile: mobileOTPController.text,
                                    code: otpCodeController.text,
                                  ),
                                ),
                                (route) => false,
                              );
                            });
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

class FinishRegistration extends StatefulWidget {
  const FinishRegistration({super.key, required this.registerController, required this.mobile, required this.code});

  final RegisterController registerController;
  final String mobile;
  final String code;

  @override
  State<FinishRegistration> createState() => _FinishRegistrationState();
}

class _FinishRegistrationState extends State<FinishRegistration> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NormalAppBar(
        title: 'تکمیل اطلاعات',
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => AvaLoadingButton(
            title: 'تایید اطلاعات',
            isLoading: widget.registerController.isLoadingFinishRegisterButton.value,
            onPressed: () async {
              await widget.registerController
                  .finishRegister(
                widget.code,
                firstNameController.text,
                lastNameController.text,
                widget.mobile,
                passwordController.text,
                passwordConfirmationController.text,
              ).then(
                (value) {
                  snackBarWithoutButton(context, value);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
              );
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(label: Text('نام')),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(label: Text('نام خانوادگی')),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(label: Text('رمز عبور')),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordConfirmationController,
                decoration: const InputDecoration(label: Text('تکرار رمز عبور')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
