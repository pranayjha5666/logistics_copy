import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../../../../controllers/auth_controller.dart';
import '../../../../../../../services/route_helper.dart';
import '../../../../../../../services/theme.dart';
import '../../../../../business_setting/html_widget_screen.dart';

class TwoWheelerDisclaimer extends StatefulWidget {
  const TwoWheelerDisclaimer({super.key});

  @override
  State<TwoWheelerDisclaimer> createState() => _TwoWheelerDisclaimerState();
}

class _TwoWheelerDisclaimerState extends State<TwoWheelerDisclaimer> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   Get.find<AuthController>().getBusinessSettings();
  // }

  @override
  Widget build(BuildContext context) {
    log(
        Get.find<AuthController>()
                .businessSettings
                .firstWhereOrNull(
                    (element) => element.key == "two_wheeler_booking_policy")
                ?.value
                .toString() ??
            "".toString(),
        name: "TwoWheeler");

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200)),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          // Text(
          //   "By Tapping next you are accepting our Booking policy",
          //   // style: Theme.of(context)
          //   //     .textTheme
          //   //     .labelSmall
          //   //     ?.copyWith(fontWeight: FontWeight.w600),
          // ),
          // HtmlWidget(
          //   textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
          //       color: Colors.black,
          //       fontWeight: FontWeight.w600,
          //       fontStyle: FontStyle.normal),
          //   Get.find<AuthController>()
          //           .businessSettings
          //           .firstWhereOrNull((element) =>
          //               element.key == "two_wheeler_booking_policy")
          //           ?.value ??
          //       "",
          // ),

        ],
      ),
    );
  }
}
