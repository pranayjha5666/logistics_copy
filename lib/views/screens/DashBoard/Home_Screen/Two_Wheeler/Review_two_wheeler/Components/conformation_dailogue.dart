import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logistics/controllers/two_wheeler_controller.dart';
import 'package:logistics/main.dart';

import '../../../../../../../controllers/location_controller.dart';
import '../../../../../../../services/route_helper.dart';
import '../../../../../../base/common_button.dart';
import '../../../../Booking_Screen/TwoWheelerList/TwoWheeler_BookingDetails/Pending_Order_Page/pending_order_page.dart';

class ConformationDailogue extends StatelessWidget {
  Map<String, dynamic> data;
  ConformationDailogue({super.key, required this.data});

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
              Expanded(child: GetBuilder<TwoWheelerController>(
                builder: (controller) {
                  return CustomButton(
                    type: ButtonType.primary,
                    title: 'Book Now',
                    height: 20,
                    onTap: () {
                      Navigator.pop(context);
                      if (!controller.paymentmode) {
                        Get.find<TwoWheelerController>()
                            .storetwowheelerbookings(data)
                            .then(
                          (value) {
                            if (value.isSuccess) {
                              log(value.data["data"].toString(),
                                  name: "Message For StoreBooking");
                              final locationcontroller =
                                  Get.find<LocationController>();
                              Navigator.push(
                                navigatorKey.currentState!.context,
                                getCustomRoute(
                                  child: PendingOrderPage(
                                      lat: double.parse(locationcontroller
                                          .pickupLocations.first.latitude!),
                                      lng: double.parse(locationcontroller
                                          .pickupLocations.first.longitude!),
                                      id: value.data["data"]),
                                ),
                              );
                            }
                          },
                        );
                      } else {
                        Get.find<TwoWheelerController>()
                            .createtwowheelerpayment(data);
                      }
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
}
