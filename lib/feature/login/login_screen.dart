import 'package:ava_hesab/config/app_colors.dart';
import 'package:ava_hesab/core/widgets/ava_loading_button.dart';
import 'package:ava_hesab/core/widgets/snack_bar_widget.dart';
import 'package:ava_hesab/feature/login/controller/login_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());
  TextEditingController mobileController = TextEditingController(text: '09398300660');
  TextEditingController passwordController = TextEditingController(text: '123456');
  TextEditingController captchaController = TextEditingController();
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
                    controller: mobileController,
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
                                  controller: captchaController,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              loginController.captchaModel.value.captcha != null
                                  ? Image.file(
                                      loginController.captchaModel.value.captcha!,
                                      width: 82,
                                      height: 32,
                                    )
                                  : Container(), // Placeholder or alternate content for null captcha
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () {
                                  captchaController.clear();
                                  loginController.refreshCaptcha();
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
                      isLoading: loginController.isLoadingLoginButton.value,
                      onPressed: () async {
                        await loginController.loginWithUsername(
                          mobileController.text,
                          passwordController.text,
                          captchaController.text,
                          loginController.captchaModel.value.captchaId!,
                        ).then((value) => snackBarWithoutButton(context, value));

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
                  const TextField(
                    decoration: InputDecoration(label: Text('شماره موبایل خود را وارد کنید')),
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  //captcha
                  const Row(),
                  AvaLoadingButton(
                    title: 'ارسال کد',
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
