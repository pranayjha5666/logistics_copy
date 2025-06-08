import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/two_wheeler_controller.dart';
import 'package:logistics/generated/assets.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/base/custom_image.dart';

import '../../../../../../controllers/location_controller.dart';

class SelectVehicleType extends StatefulWidget {
  const SelectVehicleType({super.key});

  @override
  State<SelectVehicleType> createState() => _SelectVehicleTypeState();
}

class _SelectVehicleTypeState extends State<SelectVehicleType> {
  List<Map<String, dynamic>> converthomelistmap(
      List<LocationFormControllers> location) {
    return location.map((items) {
      return {
        "type": items.type,
        "latitude": items.latitude,
        "longitude": items.longitude,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwoWheelerController>(
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.updatebike(true);

                  final locationController = Get.find<LocationController>();

                  final data = {
                    "locations": [
                      ...converthomelistmap(locationController.pickupLocations),
                      ...converthomelistmap(locationController.dropLocations),
                    ],
                    "booking_type": Get.find<TwoWheelerController>().bike
                        ? "two_wheeler"
                        : "truck",
                    if (!Get.find<TwoWheelerController>().bike)
                      "two_wheeler_truck_id":
                          Get.find<TwoWheelerController>().tempotypeid,
                  };

                  log(data.toString(),
                      name: "Send Api Data calculatetwowheelerdeliveryamount");

                  if (locationController.dropLocations.isNotEmpty &&
                      locationController.dropLocations.first.latitude != null) {
                    Get.find<TwoWheelerController>()
                        .calculatetwowheelerdeliveryamount(data);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: controller.bike ? primaryColor : Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomImage(
                            path: Assets.imagesBikeeee,
                            width: 30,
                            height: 30,
                          ),
                          Text(
                            "Two Wheeler",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    color: controller.bike
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins"),
                          )
                        ],
                      ),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Up to",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    fontSize: 8,
                                    color: controller.bike
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: "Poppins"),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "20kg",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    color: controller.bike
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins"),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.updatebike(false);

                  final locationController = Get.find<LocationController>();

                  final data = {
                    "locations": [
                      ...converthomelistmap(locationController.pickupLocations),
                      ...converthomelistmap(locationController.dropLocations),
                    ],
                    "booking_type": Get.find<TwoWheelerController>().bike
                        ? "two_wheeler"
                        : "truck",
                    if (!Get.find<TwoWheelerController>().bike)
                      "two_wheeler_truck_id":
                          Get.find<TwoWheelerController>().tempotypeid,
                  };

                  log(data.toString(),
                      name: "Send Api Data calculatetwowheelerdeliveryamount");

                  if (locationController.dropLocations.isNotEmpty &&
                      locationController.dropLocations.first.latitude != null) {
                    Get.find<TwoWheelerController>()
                        .calculatetwowheelerdeliveryamount(data);
                  }
                },
                child: Container(
                  // padding: EdgeInsets.only(right: 20, top: 10,bottom: 10),
                  padding: EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    color: !controller.bike ? primaryColor : Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          CustomImage(
                            path: Assets.imagesTempo,
                            width: 30,
                            height: 30,
                          ),
                          Text(
                            "Tempo",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    color: !controller.bike
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins"),
                          )
                        ],
                      ),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Icon(
                          //   Icons.error,
                          //   color:
                          //       !controller.bike ? Colors.white : Colors.black,
                          // ),
                          // SizedBox(
                          //   height: 6,
                          // ),

                          Text(
                            "Up to",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    fontSize: 8,
                                    color: !controller.bike
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: "Poppins"),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "100kg",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    color: !controller.bike
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins"),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
