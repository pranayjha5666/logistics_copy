import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/two_wheeler_controller.dart';
import 'package:logistics/data/models/response/tempo_list_model.dart';
import 'package:logistics/services/theme.dart';

import '../../../../../../controllers/location_controller.dart';

class TempoList extends StatefulWidget {
  const TempoList({super.key});

  @override
  State<TempoList> createState() => _TempoListState();
}

class _TempoListState extends State<TempoList> {
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
        return SizedBox(
          height: 50,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 10,
              );
            },
            shrinkWrap: true,
            itemCount: controller.tempolist.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              TempoListModel tempo = controller.tempolist[index];
              return GestureDetector(
                onTap: () {
                  controller.updatetempotypeidx(index, tempo.id,tempo.weight);

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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: controller.tempotypeidx == index
                          ? primaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tempo.title!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 9,
                            color: controller.tempotypeidx == index
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins"),
                      ),
                      Text(
                        "${tempo.weight!} kg",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            color: controller.tempotypeidx == index
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins"),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
