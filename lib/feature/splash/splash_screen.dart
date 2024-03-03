import 'package:ava_hesab/core/database/boxes.dart';
import 'package:ava_hesab/feature/home/home_screen.dart';
import 'package:ava_hesab/feature/intro/intro_screen.dart';
import 'package:ava_hesab/feature/login/data/model/auth_model.dart';
import 'package:ava_hesab/feature/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, this.token}) : super(key: key);
  final String? token;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: redirect(),
        builder: (context, snapshot) {
          return Center(
            child: Image.asset(
              'assets/images/ava.png',
              width: 300,
              height: 300,
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 3));
    AuthModel? authBox = HiveBoxes.getAuthBox().get('authBox');
    var firsTime = HiveBoxes.getIsFirstTime().get('firstTimeBox')?.isFirstTime;
    if (authBox != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
      FlutterNativeSplash.remove();
    } else {
      if (firsTime == false) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const IntroSlider(),
            ),
            (route) => false);
      }

      FlutterNativeSplash.remove();
    }
  }
}
