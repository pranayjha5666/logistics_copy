import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/goods_controller.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/screens/DashBoard/Components/location_section_widget.dart';
import 'package:logistics/views/screens/DashBoard/Home_Screen/Goods/select_truck_type_screen.dart';

import '../../../../../controllers/location_controller.dart';
import '../../../../../services/constants.dart';
import '../../../../../services/route_helper.dart';
import '../../../../base/common_button.dart';


class Goods extends StatefulWidget {
  const Goods({super.key});

  @override
  State<Goods> createState() => _GoodsState();
}

class _GoodsState extends State<Goods> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        Get.find<LocationController>().pickupLocations.clear();
        Get.find<LocationController>().dropLocations.clear();
        Get.find<LocationController>().updatedate(null);
        Get.find<LocationController>()
            .pickupLocations
            .add(LocationFormControllers(type: "pickup"));
        Get.find<LocationController>()
            .dropLocations
            .add(LocationFormControllers(type: "drop"));
        Get.find<GoodsController>().selectedTruckName = null;
        Get.find<GoodsController>().selectedGoodsType = null;
        // Get.find<LocationController>().update();
        // Get.find<GoodsController>().update();
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          leadingWidth: 70,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffD9D9D9)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Icon(Icons.arrow_back_ios, size: 16),
                  )),
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Pickup & Drop off Location",
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: LocationSectionWidget(),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomButton(
                  onTap: () {
                    if (Get.find<LocationController>()
                                .pickupLocations
                                .first
                                .addressLineOne
                                .text ==
                            "" ||
                        Get.find<LocationController>()
                                .dropLocations
                                .first
                                .addressLineOne
                                .text ==
                            "")
                      return showCustomToast("Enter Location Details",
                          color: Colors.black);
                    else if(Get.find<LocationController>().pickupDate==null)
                      return showCustomToast("Enter Pickup Date");
                    else
                      Navigator.push(context,
                          getCustomRoute(child: SelectTruckTypeScreen()));
                  },
                  title: 'Next',
                ))
          ],
        ),
      ),
    );
  }
}
