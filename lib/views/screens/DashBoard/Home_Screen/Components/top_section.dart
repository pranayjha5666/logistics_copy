import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/views/screens/DashBoard/Home_Screen/Components/custom_slider.dart';
import '../../../../../controllers/auth_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../main.dart';

class TopSection extends StatefulWidget {
  const TopSection({super.key});

  @override
  State<TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Get.find<AuthController>().getUserProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 10.0, bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                  child: CircleAvatar(
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
                        Get.find<AuthController>().userModel?.name?.substring(0, 1).toUpperCase() ?? "U",
                        // style: const TextStyle(
                        //   fontSize: 24,
                        //   fontWeight: FontWeight.bold,
                        //   color: Colors.black,
                        // ),
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w600,

                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hii ${Get.find<AuthController>().userModel != null ? Get.find<AuthController>().userModel!.name! : "Na"}",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Have a Good Day",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: const Color(0xff252525), fontSize: 10),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const CustomSliderWidget(),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 16.0),
              child: Text(
                "Services We Offer",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.black,
                      // fontSize: 19,
                      // fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
