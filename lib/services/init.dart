import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:logistics/controllers/auth_controller.dart';
import 'package:logistics/controllers/booking_controller.dart';
import 'package:logistics/controllers/car_and_bike_controller.dart';
import 'package:logistics/controllers/dashboard_controller.dart';
import 'package:logistics/controllers/homeservices_controller.dart';
import 'package:logistics/controllers/otp_autofill_controller.dart';
import 'package:logistics/controllers/goods_controller.dart';
import 'package:logistics/controllers/packers_and_mover_booking_controller.dart';
import 'package:logistics/controllers/packers_and_movers_controller.dart';
import 'package:logistics/controllers/pusher_controller.dart';
import 'package:logistics/controllers/service_controller.dart';
import 'package:logistics/controllers/support_controller.dart';
import 'package:logistics/controllers/timer_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/location_controller.dart';
import '../controllers/two_wheeler_booking_controller.dart';
import '../controllers/two_wheeler_controller.dart';
import '../data/api/api_client.dart';
import '../data/repositories/auth_repo.dart';
import '../data/repositories/user_repo.dart';
import 'constants.dart';

class Init {
  // getBaseUrl() async {
  //   ApiCalls calls = ApiCalls();
  //   await calls
  //       .apiCallWithResponseGet(
  //           'https://fishcary.com/fishcary/api/link2.php?for=true')
  //       .then((value) {
  //     log(value.toString());
  //     AppConstants().setBaseUrl = jsonDecode(value)['link'];
  //     log(AppConstants().getBaseUrl, name: 'BASE');
  //   });
  // }

  initialize() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.lazyPut<SharedPreferences>(() => sharedPreferences);

    try {
      Get.lazyPut(() => ApiClient(
          appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));
      Get.lazyPut(
          () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
      Get.lazyPut(
          () => UserRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

      Get.lazyPut(
          () => AuthController(userRepo: Get.find(), authRepo: Get.find()));

      Get.lazyPut(() => ServiceController());
      Get.lazyPut(() =>
          HomeServiceController(userRepo: Get.find(), authRepo: Get.find()));
      Get.lazyPut(
          () => GoodsController(userRepo: Get.find(), authRepo: Get.find()));
      Get.lazyPut(
          () => BookingController(userRepo: Get.find(), authRepo: Get.find()));
      Get.lazyPut(() => PackersAndMoversController(
          userRepo: Get.find(), authRepo: Get.find()));
      Get.lazyPut(() => PackersAndMoverBookingController(
          userRepo: Get.find(), authRepo: Get.find()));
      Get.lazyPut(() => TwoWheelerBookingController(
          userRepo: Get.find(), authRepo: Get.find()));
      Get.lazyPut(() =>
          CarAndBikeController(userRepo: Get.find(), authRepo: Get.find()));

      Get.lazyPut(
          () => PusherController(userRepo: Get.find(), authRepo: Get.find()));

      Get.lazyPut(() =>
          TwoWheelerController(userRepo: Get.find(), authRepo: Get.find()));

      Get.lazyPut(() => OTPAutofillController());
      Get.lazyPut(() => LocationController());
      Get.lazyPut(() => TimerController());
      Get.lazyPut(() => DashboardController());

      Get.lazyPut(() => SupportController(userRepo: Get.find()));
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT initialize()");
    }
  }

  intializeAppBuildInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppConstants.appName = packageInfo.appName;
    AppConstants.packageName = packageInfo.packageName;
    AppConstants.version = packageInfo.version;
    AppConstants.buildNumber = packageInfo.buildNumber;
  }

  stopAppRotation() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }
}
