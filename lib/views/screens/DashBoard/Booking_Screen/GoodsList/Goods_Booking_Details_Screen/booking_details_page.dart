import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/booking_controller.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/services/theme.dart';

import '../../../../Shimmer/booking_details_shimmer.dart';
import '../Goods_Live_Tracking/goods_live_tracking.dart';
import 'Booking_Info/booking_info_screen.dart';
import 'Track_Order_Screen/tracking_details.dart';

class BookingDetailsPage extends StatefulWidget {
  final int id;
  const BookingDetailsPage({super.key, required this.id});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPage();
}

class _BookingDetailsPage extends State<BookingDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BookingController>().getBookingsById(widget.id.toString());
      Get.find<BookingController>().updateselectedpage(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: () async {
            // await Get.find<BookingController>().getBookings();
            Get.find<BookingController>().getBookingsById(widget.id.toString());
          },
          child: GetBuilder<BookingController>(
            builder: (controller) {
              return controller.isLoading
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Center(child: BookingDetailsShimmer()),
                    )
                  : SafeArea(
                      child: Column(
                        children: [
                          if (controller.selectedPage == 0)
                            Row(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(Icons.arrow_back,
                                          size: 30),
                                      color: Colors.black,
                                    ),
                                    Text(
                                      "Booking Details",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Text(
                                    "#${controller.bookingdetailsModel?.bookingId!.toUpperCase() ?? ''}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                            fontSize: 14,
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(Icons.arrow_back,
                                          size: 30),
                                      color: Colors.black,
                                    ),
                                    Text(
                                      "Tracking Details",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Text(
                                    "#${controller.bookingdetailsModel?.bookingId!.toUpperCase() ?? ''}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                            fontSize: 14,
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          if (controller
                                  .bookingdetailsModel?.driver?.vehicleNumber !=
                              null)
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              width: double.infinity,
                              color: Colors.grey[100],
                              child: Text(
                                textAlign: TextAlign.center,
                                controller
                                    .bookingdetailsModel!.driver!.vehicleNumber!
                                    .toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                        fontSize: 12, color: Colors.black),
                              ),
                            ),
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => controller.goToPage(0),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: controller.selectedPage == 0
                                            ? primaryColor
                                            : Color(0xffF2F2F2),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(6),
                                            bottomLeft: Radius.circular(6)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Booking Info",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                                color:
                                                    controller.selectedPage == 0
                                                        ? Colors.white
                                                        : Colors.black,
                                                fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => controller.goToPage(1),
                                    child: Container(
                                      // height: 50,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: controller.selectedPage == 1
                                            ? primaryColor
                                            : Color(0xffF2F2F2),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(6),
                                            topRight: Radius.circular(6)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Track Order",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                                color:
                                                    controller.selectedPage == 1
                                                        ? Colors.white
                                                        : Colors.black,
                                                fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              backgroundColor: Colors.white,
                              onRefresh: () async {
                                Get.find<BookingController>()
                                    .getBookingsById(widget.id.toString());
                              },
                              child: PageView(
                                controller: controller.pageController,
                                onPageChanged: (index) {
                                  controller.updateselectedpage(index);
                                },
                                children: [
                                  BookingInfoScreen(id: widget.id),
                                  TrackingDetails(id: widget.id),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
      floatingActionButton: GetBuilder<BookingController>(
        builder: (controller) {
          return Align(
            alignment: Alignment(1.1, 0.93),
            child: controller.bookingdetailsModel?.status != "delivered"
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        getCustomRoute(child: GoodsLiveTracking()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 16, bottom: 16),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withAlpha(200),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.gps_fixed,
                                size: 18, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              "Live Tracking",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
