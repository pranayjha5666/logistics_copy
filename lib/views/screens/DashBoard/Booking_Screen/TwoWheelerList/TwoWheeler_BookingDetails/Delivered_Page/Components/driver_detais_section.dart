  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:get/get_core/src/get_main.dart';
  import 'package:lottie/lottie.dart';

  import '../../../../../../../../controllers/two_wheeler_booking_controller.dart';
  import '../../../../../../../../generated/assets.dart';

  class DriverDetaisSection extends StatelessWidget {
    bool? isbooked;
    DriverDetaisSection({super.key, this.isbooked});

    @override
    Widget build(BuildContext context) {
      return GetBuilder<TwoWheelerBookingController>(
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      "Driver Details",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w800),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        controller.twowheelerbookingdetailsModel!.bookingType!
                            .toUpperCase(),
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins",
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                color: Colors.grey[300],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 37.5,
                      backgroundColor: Colors.grey.shade200,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          controller.twowheelerbookingdetailsModel!.driver != null
                              ? controller
                                  .twowheelerbookingdetailsModel!.driver!.name!
                                  .substring(0, 1)
                                  .toUpperCase()
                              : "Z",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 25),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.twowheelerbookingdetailsModel!.driver != null
                              ? controller.twowheelerbookingdetailsModel!.driver!
                                  .name!.capitalizeFirst!
                              : "Zack M Powell",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          controller.twowheelerbookingdetailsModel!.driver != null
                              ? controller
                                  .twowheelerbookingdetailsModel!.driver!.phone!
                              : "1234567890",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          controller.twowheelerbookingdetailsModel!.driver != null
                              ? controller.twowheelerbookingdetailsModel!.driver!
                                  .vehicleNumber!
                              : "MH 07 AE 4563",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Spacer(),
                    if (isbooked == null)
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            Lottie.asset(
                              Assets.imagesOrderDeliveredLottie,
                              repeat: false,
                              fit: BoxFit.contain,
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "Order Delivered",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }
  }
