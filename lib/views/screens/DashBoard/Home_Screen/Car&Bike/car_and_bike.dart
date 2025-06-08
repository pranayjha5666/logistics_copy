import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logistics/services/extensions.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/views/base/common_button.dart';
import 'package:logistics/views/screens/DashBoard/Home_Screen/Car&Bike/vehicle_type_screen.dart';

import '../../../../../controllers/car_and_bike_controller.dart';
import '../../../../../controllers/location_controller.dart';
import '../../../../../services/constants.dart';
import '../../Components/location_section_widget.dart';

class CarAndBike extends StatefulWidget {
  const CarAndBike({super.key});

  @override
  State<CarAndBike> createState() => _CarAndBikeState();
}

class _CarAndBikeState extends State<CarAndBike> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != Get.find<LocationController>().pickupDate) {
      Get.find<LocationController>().updatedate(picked);
    }
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
        Get.find<CarAndBikeController>().moveType = "within_city";
        Get.find<CarAndBikeController>().selectedParents = {};
        Get.find<CarAndBikeController>().selectedSubItems = {};
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
          ),
          title: Text(
            "Car & Bike",
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontSize: 17),
          ),
        ),
        body: SafeArea(
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
                  child: LocationSectionWidget(
                    maxdropaddress: 1,
                    maxpickupaddress: 1,
                    iscarandbike: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Estimated Moving date *",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: .5),
                    ),
                    child:
                        GetBuilder<LocationController>(builder: (controller) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.pickupDate == null
                                  ? "Select Moving Date"
                                  : "${controller.pickupDate!.dMyDash}",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: controller.pickupDate == null
                                        ? Colors.grey[500]
                                        : Colors.black,
                                  ),
                            ),
                            Icon(
                              Icons.calendar_month,
                              color: controller.pickupDate == null
                                  ? Colors.grey[500]
                                  : Colors.black,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Where to move? *",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                GetBuilder<CarAndBikeController>(
                  builder: (controller) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.updatemove("within_city");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: BorderRadius.circular(6)),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: 0,
                              title: Text(
                                'Within City',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                        color:
                                            controller.moveType == "within_city"
                                                ? Colors.black
                                                : Colors.grey.shade700),
                              ),
                              leading: Radio<String>(
                                value: 'within_city',
                                groupValue: controller.moveType,
                                onChanged: (String? value) {
                                  controller.updatemove(value);
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.updatemove("outside_city");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: BorderRadius.circular(6)),
                            child: ListTile(
                              title: Text(
                                'Outside City',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                        color: controller.moveType ==
                                                "outside_city"
                                            ? Colors.black
                                            : Colors.grey.shade700),
                              ),
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: 0,
                              leading: Radio<String>(
                                value: 'outside_city',
                                groupValue: controller.moveType,
                                onChanged: (String? value) {
                                  controller.updatemove(value);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )
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
                  else if (Get.find<LocationController>().pickupDate == null)
                    return showCustomToast("Enter Pickup Date");
                  else
                    Navigator.push(
                        context, getCustomRoute(child: VehicleTypeScreen()));
                },
                title: "Next",
              ),
            )
          ],
        ),
      ),
    );
  }
}
