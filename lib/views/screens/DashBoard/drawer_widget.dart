import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:logistics/services/constants.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/views/screens/DashBoard/Home_Screen/Goods/goods.dart';
import 'package:logistics/views/screens/DashBoard/Home_Screen/Packers_And_Movers/packers_and_mover_page.dart';
import 'package:logistics/views/screens/DashBoard/Home_Screen/Two_Wheeler/two_wheeler_page.dart';
import 'package:logistics/views/screens/MyProfile/my_profile_screen.dart';
import '../../../controllers/auth_controller.dart';
import '../../base/dialogs/logout_dialog.dart';
import '../business_setting/html_widget_screen.dart';
import '../splash_screen/splash_screen.dart';
import 'Home_Screen/Car&Bike/car_and_bike.dart';
import 'Packer_And_Movers_Bookings/packer_and_mover_bookings.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Widget _MenuContentContainer(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 15),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.grey.shade600,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Color(0xff626161), fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // CircleAvatar(
                            //   radius: 25,
                            //   backgroundImage: AssetImage(Assets.imagesUser),
                            //   backgroundColor: Colors.transparent,
                            // ),
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey.shade200,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                // child: ClipOval(
                                //   child: Image.asset(
                                //     Assets.imagesUser2,
                                //     height:
                                //         100, // slightly smaller to fit nicely with padding
                                //     width: 100,
                                //     fit: BoxFit.cover,
                                //   ),
                                // ),
                                child: Text(
                                  Get.find<AuthController>()
                                          .userModel
                                          ?.name
                                          ?.substring(0, 1)
                                          .toUpperCase() ??
                                      "U",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Get.find<AuthController>().userModel!.name!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        fontSize: 14,
                                      ),
                                ),
                                Text(
                                  Get.find<AuthController>().userModel!.phone!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        color: Color(0xff626161),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),

                        Divider(
                          color: Color(0xffDAD9D9),
                        ),
                        // _MenuContentContainer(
                        //     title: "My Profile",
                        //     icon: Icons.account_circle_outlined,
                        //     onTap: () {}),
                        // _MenuContentContainer(
                        //     title: "My Bookings",
                        //     icon: Icons.bookmark_outline,
                        //     onTap: () {}),
                        _MenuContentContainer(
                            title: "Home",
                            icon: Icons.home_outlined,
                            onTap: () {
                              Navigator.pop(context);
                            }),

                        _MenuContentContainer(
                            title: "Profile",
                            icon: Icons.account_circle_outlined,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  getCustomRoute(child: MyProfileScreen()));
                            }),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, bottom: 8.0, top: 8.0),
                          child: Text(
                            "Services",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                ),
                          ),
                        ),
                        Divider(
                          color: Color(0xffDAD9D9),
                        ),
                        _MenuContentContainer(
                            title: "Local Bike And Tempo",
                            icon: Icons.two_wheeler_outlined,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  getCustomRoute(child: TwoWheelerPage()));
                            }),
                        _MenuContentContainer(
                            title: "Truck",
                            icon: Icons.local_shipping_outlined,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context, getCustomRoute(child: Goods()));
                            }),
                        _MenuContentContainer(
                            title: "Packers and Movers",
                            icon: Icons.all_inbox,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  getCustomRoute(child: PackersAndMoverPage()));
                            }),
                        _MenuContentContainer(
                            title: "Car & Bike",
                            icon: Icons.category,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context, getCustomRoute(child: CarAndBike()));
                            }),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, bottom: 8.0, top: 8.0),
                          child: Text(
                            "Others",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                ),
                          ),
                        ),
                        Divider(
                          color: Color(0xffDAD9D9),
                        ),

                        _MenuContentContainer(
                          title: "Term And Condition",
                          icon: Icons.description,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                getCustomRoute(
                                    child: HtmlWidgetPage(
                                  title: 'Term And Condition',
                                  htmlContent: Get.find<AuthController>()
                                          .businessSettings
                                          .firstWhereOrNull((element) =>
                                              element.key ==
                                              "terms_and_condition")
                                          ?.value ??
                                      "",
                                )));
                          },
                        ),

                        _MenuContentContainer(
                          title: "Privacy policy",
                          icon: Icons.security,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                getCustomRoute(
                                    child: HtmlWidgetPage(
                                  title: 'Privacy policy',
                                  htmlContent: Get.find<AuthController>()
                                          .businessSettings
                                          .firstWhereOrNull((element) =>
                                              element.key == "privacy_policy")
                                          ?.value ??
                                      "",
                                )));
                          },
                        ),

                        _MenuContentContainer(
                          title: "About Us",
                          icon: Icons.info_outline,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                getCustomRoute(
                                    child: HtmlWidgetPage(
                                  title: 'About Us',
                                  htmlContent: Get.find<AuthController>()
                                          .businessSettings
                                          .firstWhereOrNull((element) =>
                                              element.key == "about_us")
                                          ?.value ??
                                      "",
                                )));
                          },
                        ),
                        _MenuContentContainer(
                          title: "Support",
                          icon: Icons.support_agent_outlined,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                getCustomRoute(
                                    child: HtmlWidgetPage(
                                  title: 'Support',
                                  htmlContent: Get.find<AuthController>()
                                          .businessSettings
                                          .firstWhereOrNull((element) =>
                                              element.key == "contact_us")
                                          ?.value ??
                                      "",
                                )));
                          },
                        ),
                        // _MenuContentContainer(
                        //     title: "Help & Support",
                        //     icon: Icons.help_outline,
                        //     onTap: () {}),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GetBuilder<AuthController>(builder: (auth) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return LogoutDialog();
                        },
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_back,
                            color: Colors.red,
                            size: 24,
                          ),
                          const SizedBox(
                            width: 14,
                          ),
                          Text(
                            "Log Out",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    "Version Code: ${AppConstants.buildNumber}",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: Colors.black, fontSize: 11),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
