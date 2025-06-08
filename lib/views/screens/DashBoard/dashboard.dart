import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/auth_controller.dart';
import 'package:logistics/controllers/dashboard_controller.dart';
import 'package:logistics/controllers/location_controller.dart';
import 'package:logistics/main.dart';
import 'package:logistics/views/base/custom_image.dart';
import '../../../controllers/homeservices_controller.dart';
import '../../../controllers/two_wheeler_controller.dart';
import 'Booking_Screen/booking_screen.dart';
import 'Components/custom_exit_dailogue.dart';
import 'Support_Screen/support_screen.dart';
import 'drawer_widget.dart';
import 'Home_Screen/home_screen.dart';

class Dashboard extends StatefulWidget {
  final int initialIndex;
  int? bookingpage;
  Dashboard({Key? key, this.initialIndex = 0, this.bookingpage})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<DashboardController>().updateidx(widget.initialIndex);
      Get.find<AuthController>().getUserProfileData();
      if (Get.find<AuthController>().stateList.isEmpty)
        Get.find<AuthController>().getStates();
      Get.find<LocationController>().getCurrentLocation();
      Get.find<TwoWheelerController>().getpackagestypes();
      Get.find<TwoWheelerController>().gettempolist();
      Get.find<HomeServiceController>().getSliders();
    });
  }

  List<Widget> get pages => [
        HomeScreen(),
        BookingScreen(bookingpage: widget.bookingpage),
        SupportScreen(),
      ];

  void _onItemTapped(int index) {
    Get.find<DashboardController>().updateidx(index);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) => const CustomExitDialog(),
          );

          if (shouldExit == true) {
            exit(0);
          }
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: DrawerWidget(),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Theme(
                data: ThemeData(),
                child: GetBuilder<DashboardController>(
                  builder: (controller) {
                    return BottomNavigationBar(
                      backgroundColor: Colors.white,
                      useLegacyColorScheme: false,
                      enableFeedback: false,
                      type: BottomNavigationBarType.fixed,
                      onTap: _onItemTapped,
                      selectedItemColor: Theme.of(context).primaryColor,
                      currentIndex: controller.selectedidx,
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          backgroundColor: Colors.white,
                          icon: Icon(
                            Icons.home,
                            color: controller.selectedidx == 0
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                          label: "Home",
                        ),
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(Assets.imagesBottomsupportsvg,
                              colorFilter: ColorFilter.mode(
                                  controller.selectedidx == 1
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey,
                                  BlendMode.srcIn)),
                          label: "Bookings",
                        ),
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(Assets.imagesBottombookingsvg,
                              colorFilter: ColorFilter.mode(
                                  controller.selectedidx == 2
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey,
                                  BlendMode.srcIn)),
                          label: "Support",
                        ),
                      ],
                    );
                  },
                )),
          ],
        ),
        body: GetBuilder<DashboardController>(
          builder: (controller) {
            return pages.elementAt(controller.selectedidx);
          },
        ),
      ),
    );
  }
}
