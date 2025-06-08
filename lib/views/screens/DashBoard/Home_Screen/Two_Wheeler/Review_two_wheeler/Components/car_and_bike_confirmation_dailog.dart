import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logistics/controllers/car_and_bike_controller.dart';
import 'package:logistics/services/route_helper.dart';

import '../../../../../../../controllers/location_controller.dart';
import '../../../../../../base/common_button.dart';
import '../../../Car&Bike/Components/car_and_bike_order_conformation_page.dart';

class CarAndBikeConfirmationDailog extends StatelessWidget {
  Map<String, dynamic> data;
  CarAndBikeConfirmationDailog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.green.shade400,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
          Container(),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Are you sure you want to book this order?",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: CustomButton(
                  type: ButtonType.secondary,
                  title: 'Cancel',
                  height: 20,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(child: GetBuilder<CarAndBikeController>(
                builder: (controller) {
                  return CustomButton(
                    isLoading: controller.isLoading,
                    type: ButtonType.primary,
                    title: 'Book Now',
                    height: 20,
                    onTap: () {
                      controller.storecarandbikebooking(data).then(
                        (value) {
                          if (value.isSuccess) {
                            clearfield();
                            Navigator.pushAndRemoveUntil(
                              context,
                              getCustomRoute(
                                  child: CarAndBikeOrderConformationPage()),
                              (route) => false,
                            );
                          } else {
                            Navigator.pop(context);
                            Fluttertoast.showToast(msg: value.message);
                          }
                        },
                      );
                    },
                  );
                },
              )),
            ],
          )
        ],
      ),
    );
  }

  void clearfield() {
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
  }
}
