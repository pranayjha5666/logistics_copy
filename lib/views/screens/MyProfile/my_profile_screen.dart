import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logistics/views/screens/MyProfile/Components/personal_info_section.dart';
import 'package:logistics/views/screens/MyProfile/edit_profile_screen.dart';
import '../../../controllers/auth_controller.dart';
import '../../../generated/assets.dart';
import '../../../services/route_helper.dart';
import '../../../services/theme.dart';
import 'Components/additional_info_section.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<AuthController>().getUserProfileData();
  }


  @override
  Widget build(BuildContext context) {
    final userdetails = Get.find<AuthController>().userModel!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            size: 20,
            color: Colors.black,
          ),
          padding: EdgeInsets.zero,
        ),
        titleSpacing: 5,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade200,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Text(
                  Get.find<AuthController>()
                          .userModel
                          ?.name
                          ?.substring(0, 1)
                          .toUpperCase() ??
                      "U",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w600,
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
                  "${userdetails.name!}",
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "${userdetails!.email != null ? userdetails.email! : "Have a Good Day"}",
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: const Color(0xff252525), fontSize: 8),
                ),
              ],
            )
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 25),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primaryColor),
              ),
              child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                        context, getCustomRoute(child: EditProfileScreen()));
                  },
                  icon: Icon(
                    Icons.edit,
                    size: 20,
                    color: primaryColor,
                  )),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                PersonalInfoSection(),
                SizedBox(
                  height: 25,
                ),
                if (userdetails.companyName != null ||
                    userdetails.gstNumber != null ||
                    userdetails.gstCertificate != null ||
                    userdetails.msmeCertificate != null)
                  AdditionalInfoSection()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
