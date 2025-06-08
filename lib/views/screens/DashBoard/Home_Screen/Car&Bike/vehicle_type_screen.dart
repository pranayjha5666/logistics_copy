import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logistics/views/base/custom_image.dart';

import '../../../../../controllers/car_and_bike_controller.dart';
import '../../../../../controllers/location_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../base/common_button.dart';
import '../Two_Wheeler/Review_two_wheeler/Components/car_and_bike_confirmation_dailog.dart';

class VehicleTypeScreen extends StatefulWidget {
  const VehicleTypeScreen({super.key});

  @override
  State<VehicleTypeScreen> createState() => _VehicleTypeScreenState();
}

class _VehicleTypeScreenState extends State<VehicleTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: Text(
          "Car & Bike",
          style:
              Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 17),
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
              "Vehicle Types *",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            GetBuilder<CarAndBikeController>(
              builder: (controller) {
                return ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.vehicleMap.length,
                  itemBuilder: (context, index) {
                    String parentType =
                        controller.vehicleMap.keys.elementAt(index);
                    List<String> subTypes = controller.vehicleMap[parentType]!;
                    bool isSelected =
                        controller.selectedParents.contains(parentType);
                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          controller.selectedParents.remove(parentType);
                          controller.selectedSubItems.remove(parentType);
                        } else {
                          controller.selectedParents.add(parentType);
                          if (subTypes.isNotEmpty) {
                            controller.selectedSubItems[parentType] =
                                subTypes.first;
                          }
                        }
                        controller.update();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: isSelected && subTypes.isNotEmpty
                                ? Border.all(
                                    color: Colors.grey.shade300,
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(6)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  color: isSelected ? Color(0xffF8F6F6) : null,
                                  border: !(isSelected && subTypes.isNotEmpty)
                                      ? Border.all(
                                          color: Colors.grey.shade300,
                                        )
                                      : null,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.90,
                                    child: Checkbox(
                                      value: isSelected,
                                      onChanged: (value) {
                                        if (value == true) {
                                          controller.selectedParents
                                              .add(parentType);
                                          if (subTypes.isNotEmpty) {
                                            controller.selectedSubItems[
                                                parentType] = subTypes.first;
                                          }
                                        } else {
                                          controller.selectedParents
                                              .remove(parentType);
                                          controller.selectedSubItems
                                              .remove(parentType);
                                        }
                                        controller.update();
                                      },
                                    ),
                                  ),
                                  Text(parentType,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              fontFamily: "Poppins")),
                                  Spacer(),
                                  CustomImage(
                                    path: parentType == "Car"
                                        ? Assets.imagesCarVariant
                                        : parentType == "Bike"
                                            ? Assets.imagesBikeVariant
                                            : Assets.imagesScootyVariant,
                                    width: 24,
                                    height: 24,
                                  )
                                ],
                              ),
                            ),
                            if (isSelected && subTypes.isNotEmpty) ...[
                              Divider(
                                height: 0,
                                color: Colors.grey.shade300,
                              ),
                              Column(
                                children: subTypes.map((sub) {
                                  return RadioListTile<String>(
                                    dense: true,
                                    visualDensity: VisualDensity(vertical: -2),
                                    title: Text(sub,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                                color: Color(0xff8A8A8A),
                                                fontWeight: FontWeight.w500)),
                                    value: sub,
                                    groupValue:
                                        controller.selectedSubItems[parentType],
                                    onChanged: (String? value) {
                                      controller.selectedSubItems[parentType] =
                                          value!;
                                      controller.update();
                                    },
                                  );
                                }).toList(),
                              ),
                            ]
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      )),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: GetBuilder<CarAndBikeController>(
                builder: (controller) {
                  return CustomButton(
                    onTap: () {
                      final carAndBikeController =
                          Get.find<CarAndBikeController>();
                      final locationController = Get.find<LocationController>();

                      Map<String, dynamic> data = {
                        "estimated_moving_date":
                            locationController.pickupDate.toString(),
                        "where_to_move":
                            carAndBikeController.moveType.toString(),
                        "pickup_user_name": locationController
                            .pickupLocations.first.name.text
                            .toString(),
                        "pickup_user_phone": locationController
                            .pickupLocations.first.phone.text
                            .toString(),
                        "pickup_map_location": locationController
                            .pickupLocations.first.mapaddress.text
                            .toString(),
                        "pickup_address_line_one": locationController
                            .pickupLocations.first.addressLineOne.text
                            .toString(),
                        "pickup_address_line_two": locationController
                            .pickupLocations.first.addressLineTwo.text
                            .toString(),
                        "pickup_state_id": locationController
                            .pickupLocations.first.stateId
                            .toString(),
                        "pickup_city": locationController
                            .pickupLocations.first.city.text
                            .toString(),
                        "pickup_pincode": locationController
                            .pickupLocations.first.pincode.text
                            .toString(),
                        "pickup_latitude": locationController
                            .pickupLocations.first.latitude
                            .toString(),
                        "pickup_longitude": locationController
                            .pickupLocations.first.longitude
                            .toString(),
                        "drop_user_name": locationController
                            .dropLocations.first.name.text
                            .toString(),
                        "drop_user_phone": locationController
                            .dropLocations.first.phone.text
                            .toString(),
                        "drop_map_location": locationController
                            .dropLocations.first.mapaddress.text
                            .toString(),
                        "drop_address_line_one": locationController
                            .dropLocations.first.addressLineOne.text
                            .toString(),
                        "drop_address_line_two": locationController
                            .dropLocations.first.addressLineTwo.text
                            .toString(),
                        "drop_state_id": locationController
                            .dropLocations.first.stateId
                            .toString(),
                        "drop_city": locationController
                            .dropLocations.first.city.text
                            .toString(),
                        "drop_pincode": locationController
                            .dropLocations.first.pincode.text
                            .toString(),
                        "drop_latitude": locationController
                            .dropLocations.first.latitude
                            .toString(),
                        "drop_longitude": locationController
                            .dropLocations.first.longitude
                            .toString(),
                        "vehicle_data": convertVehicleSelectionToJson(
                          carAndBikeController.selectedParents.toList(),
                          carAndBikeController.selectedSubItems,
                        ),
                      };

                      log(jsonEncode(data).toString(),
                          name: "Send Data to API");

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CarAndBikeConfirmationDailog(
                            data: data,
                          );
                        },
                      );
                    },
                    title: "Next",
                  );
                },
              )),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> convertVehicleSelectionToJson(
      List<String> selectedParents, Map<String, String> selectedSubItems) {
    return selectedParents.map((parent) {
      final model = selectedSubItems[parent];
      return {
        "type": parent,
        if (model != null) "model": model,
      };
    }).toList();
  }
}
