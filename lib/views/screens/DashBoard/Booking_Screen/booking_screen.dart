import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/booking_controller.dart';
import 'package:logistics/controllers/car_and_bike_controller.dart';
import 'package:logistics/controllers/two_wheeler_booking_controller.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/base/custom_image.dart';
import 'package:logistics/views/screens/DashBoard/Packer_And_Movers_Bookings/packer_and_mover_bookings.dart';

import '../../../../controllers/dashboard_controller.dart';
import '../../../../controllers/packers_and_mover_booking_controller.dart';
import '../../../../services/route_helper.dart';
import '../Home_Screen/Car&Bike/car_and_bike.dart';
import '../Home_Screen/Goods/goods.dart';
import '../Home_Screen/Packers_And_Movers/packers_and_mover_page.dart';
import '../Home_Screen/Two_Wheeler/two_wheeler_page.dart';
import 'CarAndBike/car_and_bike_list.dart';
import 'GoodsList/goods__booking_list.dart';
import 'TwoWheelerList/two_wheeler_booking_list.dart';

class BookingScreen extends StatefulWidget {
  int? bookingpage;
  BookingScreen({super.key, this.bookingpage});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      log(widget.bookingpage.toString(), name: "Widget Page");
      Get.find<BookingController>().updateshowlistpage(widget.bookingpage ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text(
          "My Bookings",
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: () async {
          log(Get.find<BookingController>().showlistpage.toString());
          if (Get.find<BookingController>().showlistpage == 0) {
            // two wheeler booking
            Get.find<TwoWheelerBookingController>().getTwoWheelerBookings();
            Get.find<TwoWheelerBookingController>().updatepage();
          } else if (Get.find<BookingController>().showlistpage == 1) {
            // tempo truck container
            await Get.find<BookingController>().getBookings();
            Get.find<BookingController>().updatepage();
          } else if (Get.find<BookingController>().showlistpage == 2) {
            //packer and movers
            await Get.find<PackersAndMoverBookingController>()
                .getpackersandmoversBookings();
            Get.find<PackersAndMoverBookingController>().updatepage();
          } else {
            // car and bike
            Get.find<CarAndBikeController>().getcarandbikebooking();
            Get.find<CarAndBikeController>().updatepage();
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: GetBuilder<BookingController>(
            builder: (controller) {
              return Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tab 0: Local Bike & Tempo
                        GestureDetector(
                          onTap: () {
                            controller.getBookings();
                            controller.updatepage();
                            controller.updateshowlistpage(0);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: controller.showlistpage == 0
                                  ? primaryColor
                                  : Color(0xffF2F2F2),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                bottomLeft: Radius.circular(6),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Local Bike & Tempo",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: controller.showlistpage == 0
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ),

                        // Tab 1: Tempo Truck Container
                        GestureDetector(
                          onTap: () {
                            controller.updateshowlistpage(1);
                            Get.find<TwoWheelerBookingController>()
                                .updatepage();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: controller.showlistpage == 1
                                  ? primaryColor
                                  : Color(0xffF2F2F2),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Tempo Truck Container",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: controller.showlistpage == 1
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ),

                        // Tab 2: Packers & Movers
                        GestureDetector(
                          onTap: () {
                            controller.updateshowlistpage(2);
                            Get.find<PackersAndMoverBookingController>()
                                .updatepage();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: controller.showlistpage == 2
                                  ? primaryColor
                                  : Color(0xffF2F2F2),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Packers & Movers",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: controller.showlistpage == 2
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ),

                        // Tab 3: Car & Bike
                        GestureDetector(
                          onTap: () {
                            controller.updateshowlistpage(3);
                            Get.find<CarAndBikeController>().updatepage();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: controller.showlistpage == 3
                                  ? primaryColor
                                  : Color(0xffF2F2F2),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6),
                                bottomRight: Radius.circular(6),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Car & Bike",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: controller.showlistpage == 3
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: controller.showlistpage == 0
                          ? TwoWheelerBookingList()
                          : controller.showlistpage == 1
                              ? GoodsBookingsList()
                              : controller.showlistpage == 2
                                  ? PackerAndMoverBookings()
                                  : CarAndBikeList())
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: GetBuilder<BookingController>(
        builder: (controller) {
          // return FloatingActionButton(
          //   onPressed: () {
          //     int idx = controller.showlistpage;
          //     log(controller.showlistpage.toString());
          //     if (idx == 0) {
          //       Navigator.push(
          //           context, getCustomRoute(child: TwoWheelerPage()));
          //     } else if (idx == 1) {
          //       Navigator.push(context, getCustomRoute(child: Goods()));
          //     } else if (idx == 2) {
          //       Navigator.push(
          //           context, getCustomRoute(child: PackersAndMoverPage()));
          //     } else {
          //       Navigator.push(context, getCustomRoute(child: CarAndBike()));
          //     }
          //   },
          //   child: Icon(Icons.home),
          // );
          return GestureDetector(
            onTap: () {
              int idx = controller.showlistpage;
              log(controller.showlistpage.toString());
              if (idx == 0) {
                Navigator.push(
                    context, getCustomRoute(child: TwoWheelerPage()));
              } else if (idx == 1) {
                Navigator.push(context, getCustomRoute(child: Goods()));
              } else if (idx == 2) {
                Navigator.push(
                    context, getCustomRoute(child: PackersAndMoverPage()));
              } else {
                Navigator.push(context, getCustomRoute(child: CarAndBike()));
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    // Icon(Icons.book,
                    //     size: 18, color: Colors.white),
                    CustomImage(
                      path: Assets.imagesGotoBookingScreenImg,
                      width: 25,
                      height: 25,
                      color: Colors.white,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Book Now",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
