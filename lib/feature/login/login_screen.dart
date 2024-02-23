import 'package:ava_hesab/config/app_colors.dart';
import 'package:ava_hesab/core/widgets/ava_loading_button.dart';
import 'package:ava_hesab/core/widgets/snack_bar_widget.dart';
import 'package:ava_hesab/feature/login/controller/login_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());

  // with Username and password
  TextEditingController mobileUsernameController = TextEditingController(text: '09398300660');
  TextEditingController passwordController = TextEditingController(text: '123456');
  TextEditingController captchaUsernameController = TextEditingController();

  //with OTP
  TextEditingController mobileOTPController = TextEditingController(text: '09398300660');
  TextEditingController captchaOTPController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();
  final focusNode = FocusNode();

  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'ورود با نام کاربری'),
              Tab(text: 'ورود با کد یکبار مصرف'),
            ],
          ),
          title: const Text('ورود به حساب کاربری'),
        ),
        body: TabBarView(
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
                    'از دیدن شما خوشحالم! لطفا با حساب کاربری خود وارد شوید.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: mobileUsernameController,
                    decoration: const InputDecoration(label: Text('شماره موبایل خود را وارد کنید')),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: passwordVisible,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      label: const Text('رمز عبور خود را وارد کنید'),
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility, size: 18),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  Obx(() {
                    return loginController.loadingCaptcha.value
                        ? const CupertinoActivityIndicator()
                        : Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: captchaUsernameController,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              loginController.captchaForUsername.value.captcha != null
                                  ? Image.file(
                                      loginController.captchaForUsername.value.captcha!,
                                      width: 82,
                                      height: 32,
                                    )
                                  : Container(), // Placeholder or alternate content for null captcha
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () {
                                  captchaUsernameController.clear();
                                  loginController.refreshCaptchaUsername();
                                },
                                child: const Icon(Icons.refresh),
                              ),
                            ],
                          );
                  }),
                  const SizedBox(height: 24),
                  Obx(
                    () => AvaLoadingButton(
                      title: 'ورود',
                      isLoading: loginController.isLoadingLoginUsernameButton.value,
                      onPressed: () async {
                        await loginController
                            .loginWithUsername(
                              mobileUsernameController.text,
                              passwordController.text,
                              captchaUsernameController.text,
                              loginController.captchaForUsername.value.captchaId!,
                            )
                            .then((value) => snackBarWithoutButton(context, value));
                      },
                    ),
                  )
                ],
              ),
            ),
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
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: const Offset(5, 7), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'از دیدن شما خوشحالم! لطفا با حساب کاربری خود وارد شوید.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: mobileOTPController,
                    decoration: const InputDecoration(label: Text('شماره موبایل خود را وارد کنید')),
                  ),
                  SizedBox(height: 24),
                  Visibility(
                    visible: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('کد تایید را وارد کنید',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColorsLight.textLightSoft),),
                        SizedBox(height: 8),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Pinput(
                            keyboardType: TextInputType.number,
                            forceErrorState: showError,
                            length: length,
                            controller: otpCodeController,
                            focusNode: focusNode,
                            defaultPinTheme: defaultPinTheme,
                            readOnly: true,
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
                  const Expanded(child: SizedBox.shrink()),
                  //captcha
                  Obx(() {
                    return loginController.loadingCaptcha.value
                        ? const CupertinoActivityIndicator()
                        : Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: captchaOTPController,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              loginController.captchaForOTP.value.captcha != null
                                  ? Image.file(
                                      loginController.captchaForOTP.value.captcha!,
                                      width: 82,
                                      height: 32,
                                    )
                                  : Container(), // Placeholder or alternate content for null captcha
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () {
                                  captchaUsernameController.clear();
                                  loginController.refreshCaptchaUsername();
                                },
                                child: const Icon(Icons.refresh),
                              ),
                            ],
                          );
                  }),
                  const SizedBox(height: 24),
                  Obx(() => AvaLoadingButton(
                        title: 'ارسال کد',
                        isLoading: loginController.isLoadingLoginOTPButton.value,
                        onPressed: () async {
                          await loginController
                              .loginWithOTP(
                                mobileOTPController.text,
                                captchaOTPController.text,
                                loginController.captchaForOTP.value.captchaId!,
                              )
                              .then((value) => snackBarWithoutButton(context, value));
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
