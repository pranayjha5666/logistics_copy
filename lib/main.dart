import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/location_controller.dart';
import 'package:logistics/services/constants.dart';
import 'package:logistics/services/init.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/screens/splash_screen/splash_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Init().initialize();
  await Init().intializeAppBuildInfo();
  await Init().stopAppRotation();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackBarKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  initPlatForm() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.none);
    OneSignal.initialize('appId'); //---------------------ADD ONESIGNAL APP ID
    OneSignal.User.pushSubscription.optIn();
    await OneSignal.consentRequired(true);

    OneSignal.Notifications.addForegroundWillDisplayListener(
        (OSNotificationWillDisplayEvent event) {
      /// preventDefault to not display the notification
      event.preventDefault();

      /// Do async work
      /// notification.display() to display after preventing default
      event.notification.display();
    });

    OneSignal.Notifications.addClickListener((OSNotificationClickEvent result) {
      ///TODO:
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (Get.find<LocationController>().comefromdailogue) {
      if (state == AppLifecycleState.resumed) {
        log(serviceEnabled.toString(), name: "Service Enable");
        Get.find<LocationController>().updatecomefromdailogue(false);

        if (serviceEnabled) {
          Get.find<LocationController>().getCurrentLocation();
        }
        log('Current state = $state');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    initPlatForm();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: AppConstants.appName,
        navigatorKey: navigatorKey,
        themeMode: ThemeMode.light,
        theme: CustomTheme.light,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
