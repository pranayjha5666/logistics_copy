import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logistics/controllers/location_controller.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/screens/auth/register_user_page.dart';
import 'package:logistics/views/screens/onboarding_page/onboarding_page.dart';

import '../../../controllers/auth_controller.dart';
import '../../base/custom_image.dart';
import '../DashBoard/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () async {
      await Get.find<AuthController>().getBusinessSettings();

      if (Get.find<AuthController>().isLoggedIn()) {
        await Get.find<AuthController>().getUserProfileData().then((value) {
          if (value.isSuccess) {
            if (!Get.find<AuthController>().checkUserData()) {
              Navigator.pushReplacement(
                  context,
                  getCustomRoute(
                      child: RegisterUserPage(
                          user: Get.find<AuthController>().userModel!)));
            } else {
              // Get.find<LocationController>().getCurrentLocation();
              // Get.find<AuthController>().getStates();
              Navigator.pushReplacement(
                  context, getCustomRoute(child: Dashboard()));
            }
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              getCustomRoute(child: OnboardingPage()),
              (route) => false,
            );
          }
        });
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          getCustomRoute(child: OnboardingPage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(

        child: CustomImage(
          width: 200,
          height: 200,
          path: Assets.imagesLogo,
        ),
      ),
    );
  }
}
