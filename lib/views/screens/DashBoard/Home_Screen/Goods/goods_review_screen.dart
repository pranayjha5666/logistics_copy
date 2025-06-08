import 'dart:developer';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/goods_controller.dart';
import 'package:logistics/services/extensions.dart';
import '../../../../../controllers/location_controller.dart';
import '../../../../../services/route_helper.dart';
import '../../../../../services/theme.dart';
import '../../../../base/common_button.dart';
import '../../Location_Selection/drop_details.dart';
import '../../Location_Selection/pick_up_details.dart';
import '../Packers_And_Movers/booking_placed_page.dart';

class GoodsReviewScreen extends StatefulWidget {
  const GoodsReviewScreen({super.key});

  @override
  State<GoodsReviewScreen> createState() => _GoodsReviewScreenState();
}

class _GoodsReviewScreenState extends State<GoodsReviewScreen> {
  DateTime? selectedDate = Get.find<LocationController>().pickupDate;

  String _shorten(String name) {
    if (name.length <= 10) return name;
    return "${name.substring(0, 10)}...";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  border: Border.all(color: const Color(0xffD9D9D9)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 5.0),
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
              Container(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GetBuilder<LocationController>(
                  builder: (controller) {
                    final allLocations = [
                      ...controller.pickupLocations.map((e) => {
                            "address": e.addressLineOne.text.trim(),
                            "name": e.name.text.trim(),
                            "phone": e.phone.text.trim(),
                            "isPickUp": true,
                          }),
                      ...controller.dropLocations.map((e) => {
                            "address": e.addressLineOne.text.trim(),
                            "name": e.name.text.trim(),
                            "phone": e.phone.text.trim(),
                            "isPickUp": false,
                          }),
                    ];

                    int pickupCount = 0;
                    int dropCount = 0;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: allLocations.length,
                      itemBuilder: (context, index) {
                        bool isFirst = index == 0;
                        bool isLast = index == allLocations.length - 1;
                        var step = allLocations[index];

                        if (allLocations[index]["isPickUp"] == true) {
                          pickupCount++;
                        } else {
                          dropCount++;
                        }
                        bool isPickup = step["isPickUp"] == true;

                        bool isFirstDrop = !isPickup && dropCount == 1;

                        return InkWell(
                          onTap: () {
                            if (isFirst || isFirstDrop) {
                              if (isPickup) {
                                Navigator.push(
                                  context,
                                  getCustomRoute(child: PickUpDetailsPage()),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  getCustomRoute(child: DropDetails()),
                                );
                              }
                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Timeline side
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Container(
                                      margin: EdgeInsets.only(top: 2.5),
                                      width: isFirst || isLast ? 40 : 20,
                                      height: isFirst || isLast ? 30 : 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isPickup
                                            ? const Color(0xFF00C060)
                                            : const Color(0xFFEB0404),
                                      ),
                                      child: Icon(
                                        isFirst || isLast
                                            ? Icons.location_on
                                            : Icons.circle,
                                        color: Colors.white,
                                        size: isFirst || isLast ? 16.5 : 10,
                                      ),
                                    ),
                                  ),
                                  if (!isLast)
                                    (controller.pickupLocations.length > 1 ||
                                            controller.dropLocations.length > 1)
                                        ? SizedBox(
                                            width: 40,
                                            height: 35,
                                            child: DottedBorder(
                                              strokeWidth: 2,
                                              dashPattern: const [5, 5],
                                              color: Colors.grey,
                                              customPath: (size) {
                                                return Path()
                                                  ..moveTo(size.width / 2, 6)
                                                  ..lineTo(size.width / 2, 50);
                                              },
                                              child: const SizedBox.shrink(),
                                            ),
                                          )
                                        : SizedBox(width: 40, height: 20),
                                ],
                              ),
                              const SizedBox(width: 14),

                              // Address side
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (step["address"] != null &&
                                        step["address"].toString().isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: isFirst ? 10.0 : 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  children: [
                                                    if (isPickup)
                                                      TextSpan(
                                                        text:
                                                            "Pick up $pickupCount    ",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displayMedium
                                                            ?.copyWith(
                                                              color: const Color(
                                                                  0xff787878),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                            ),
                                                      ),
                                                    if (!isPickup)
                                                      TextSpan(
                                                        text:
                                                            "Drop off $dropCount    ",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displayMedium
                                                            ?.copyWith(
                                                              color: const Color(
                                                                  0xff787878),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                            ),
                                                      ),
                                                    TextSpan(
                                                      text:
                                                      "${_shorten(step["name"].toString())}   ${step["phone"]}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium
                                                          ?.copyWith(
                                                            color: const Color(
                                                                0xff787878),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (isFirst || isFirstDrop)
                                              InkWell(
                                                onTap: () {
                                                  if (isPickup) {
                                                    Navigator.push(
                                                      context,
                                                      getCustomRoute(
                                                          child:
                                                              PickUpDetailsPage()),
                                                    );
                                                  } else {
                                                    Navigator.push(
                                                      context,
                                                      getCustomRoute(
                                                          child: DropDetails()),
                                                    );
                                                  }
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 12.0),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: primaryColor,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      )
                                    else
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: isFirst ? 10.0 : 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  children: [
                                                    if (isPickup)
                                                      TextSpan(
                                                        text:
                                                            "Pick up $pickupCount    ",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displayMedium
                                                            ?.copyWith(
                                                              color: const Color(
                                                                  0xff787878),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                            ),
                                                      ),
                                                    if (!isPickup)
                                                      TextSpan(
                                                        text:
                                                            "Drop off $dropCount    ",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displayMedium
                                                            ?.copyWith(
                                                              color: const Color(
                                                                  0xff787878),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                            ),
                                                      ),
                                                    TextSpan(
                                                      text: isPickup
                                                          ? "Na"
                                                          : "Na",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium
                                                          ?.copyWith(
                                                            color: const Color(
                                                                0xff787878),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (isFirst || isFirstDrop)
                                              InkWell(
                                                onTap: () {
                                                  if (isPickup) {
                                                    Navigator.push(
                                                      context,
                                                      getCustomRoute(
                                                          child:
                                                              PickUpDetailsPage()),
                                                    );
                                                  } else {
                                                    Navigator.push(
                                                      context,
                                                      getCustomRoute(
                                                          child: DropDetails()),
                                                    );
                                                  }
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 12.0),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: primaryColor,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),

                                    const SizedBox(height: 5),

                                    // Directly show the address (always available)
                                    Text(
                                      step["address"] != null
                                          ? step["address"].toString()
                                          : "Na",
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(fontSize: 12),
                                    ),

                                    if (index != allLocations.length - 1)
                                      Divider(
                                        color: Color(0xffE4E4E4),
                                        thickness: 1,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Color(0xff7E7E7E),
                          fontWeight: FontWeight.w800,
                          fontSize: 12),
                    ),
                    Text(
                      selectedDate!.dMy,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontWeight: FontWeight.w700, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 50,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Truck",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Color(0xff7E7E7E),
                          fontWeight: FontWeight.w800,
                          fontSize: 12),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Expanded(
                      child: Text(
                        Get.find<GoodsController>().selectedTruckName!,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 50,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Goods Type",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Color(0xff7E7E7E),
                          fontWeight: FontWeight.w800,
                          fontSize: 12),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Expanded(
                      child: Text(
                        Get.find<GoodsController>().selectedGoodsType!,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ],
                ),
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
                  Map<String, dynamic> data = {
                    // "pickup_user_name":
                    //     Get.find<LocationController>().sendername.text,
                    // "pickup_user_phone":
                    //     Get.find<LocationController>().sendermobileno.text,
                    "pickup_date": selectedDate?.toIso8601String(),
                    // "drop_user_name":
                    //     Get.find<LocationController>().receivername.text,
                    // "drop_user_phone":
                    //     Get.find<LocationController>().receivermobileno.text,
                    "good_type_id": Get.find<GoodsController>()
                        .good_type_id, // should be an ID
                    "truck_type": Get.find<GoodsController>()
                        .truck_type, // should be either "open_truck" or "body_pack_truck"
                    "vehicle_id": Get.find<GoodsController>()
                        .vehicle_id, // should be an ID
                    "locations": [
                      ...convertLocationControllersToJson(
                        Get.find<LocationController>().pickupLocations,
                      ),
                      ...convertLocationControllersToJson(
                        Get.find<LocationController>().dropLocations,
                      ),
                    ]
                  };

                  log(data.toString(), name: "Data send to api");

                  Get.find<GoodsController>()
                      .goodsBooking(data)
                      .then((value) async {
                    if (value.isSuccess) {
                      final locationcontroller =
                      Get.find<LocationController>();
                      Navigator.push(
                          context, getCustomRoute(child: BookingPlacedPage(
                          lat: double.parse(locationcontroller
                              .pickupLocations.first.latitude!),
                          lng: double.parse(locationcontroller
                              .pickupLocations.first.longitude!),
                          id: value.data["data"]["id"],
                        date: value.data["data"]["created_at"] != null
                            ? DateTime.parse(value.data["data"]["created_at"])
                            : DateTime.now(),
                      )));
                      clearfield();

                    } else {
                      Fluttertoast.showToast(msg: value.message);
                    }
                  });
                },
                title: 'Book',
              ))
        ],
      ),
    );
  }

  List<Map<String, dynamic>> convertLocationControllersToJson(
      List<LocationFormControllers> locations) {
    return locations.map((address) => address.toModel().toJson()).toList();
  }

  void clearfield() {
    Get.find<LocationController>().pickupLocations.clear();
    Get.find<LocationController>().dropLocations.clear();
    // Get.find<LocationController>().sendermobileno.clear();
    // Get.find<LocationController>().receivername.clear();
    // Get.find<LocationController>().sendername.clear();
    // Get.find<LocationController>().receivermobileno.clear();
    Get.find<GoodsController>().selectedTruckName = null;
    Get.find<GoodsController>().selectedGoodsType = null;
    Get.find<LocationController>().update();
    Get.find<GoodsController>().update();
    Get.find<LocationController>()
        .pickupLocations
        .add(LocationFormControllers(type: "pickup"));
    Get.find<LocationController>()
        .dropLocations
        .add(LocationFormControllers(type: "drop"));
    Get.find<LocationController>().updatedate(null);
  }
}
