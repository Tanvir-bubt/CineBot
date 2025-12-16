import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cinebot/helper/global.dart';
import 'package:cinebot/screen/home_screen.dart';
import 'package:cinebot/screen/onboarding_screen.dart';
import 'package:cinebot/services/hive_service.dart';
import 'package:cinebot/widget/custom_loading.dart';
import 'package:cinebot/screen/feature/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

//Wait for 1 second and navigate to HomeScreen
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      await HvService.init();
      final userLoggedIn = HvService.userEmail.isNotEmpty;
      if (!userLoggedIn) {
        Get.off(() => LoginScreen());
      } else if (HvService.showOnboarding) {
        Get.off(() => const OnboardingScreen());
      } else {
        Get.off(() => const HomeScreen());
      }
    });
  }







  @override
  Widget build(BuildContext context) {
    // Initialize the media query variable for global use
    mq = MediaQuery.sizeOf(context);

    final double paddingValue = mq.width * .02;
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            const Spacer(flex: 2),
            Card(
              color: const Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.all(Radius.circular(20))),
              child: Padding(

                padding: EdgeInsets.all(paddingValue),
                child: Image.asset('assets/images/home.png',
                 width: mq.width *  .45
                 ),
              ),
            ),
            const Spacer(),
            const CustomLoading(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}