import 'package:cinebot/helper/global.dart';
import 'package:cinebot/helper/pref.dart';
import 'package:cinebot/screen/home_screen.dart';
import 'package:cinebot/screen/onboarding_screen.dart';
import 'package:cinebot/widget/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    Future.delayed(const Duration(seconds: 3), () {
      // ignore: use_build_context_synchronously
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (_) =>
      //     Pref.showOnboarding 
      //     ? const OnboardingScreen()
      //     : const HomeScreen()));
      Get.off(() => Pref.showOnboarding
          ? const OnboardingScreen()
          : const HomeScreen());
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