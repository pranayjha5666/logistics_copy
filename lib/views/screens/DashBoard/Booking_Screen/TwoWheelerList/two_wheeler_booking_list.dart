import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:logistics/controllers/two_wheeler_booking_controller.dart';
import 'package:logistics/data/models/response/two_wheeler_booking_list_model.dart';
import 'package:logistics/views/screens/DashBoard/Booking_Screen/TwoWheelerList/Components/two_wheeler_booking_card.dart';
import 'package:logistics/views/screens/DashBoard/Booking_Screen/TwoWheelerList/TwoWheeler_BookingDetails/InTransit_Order_Page/intransit_order_page.dart';

import '../../../../../services/route_helper.dart';
import '../../../Shimmer/booking_shimmer.dart';
import '../../Packer_And_Movers_Bookings/Components/no_order_widget.dart';
import 'TwoWheeler_BookingDetails/Delivered_Page/two_wheeler_delivered_page.dart';

class TwoWheelerBookingList extends StatefulWidget {
  const TwoWheelerBookingList({super.key});

  @override
  State<TwoWheelerBookingList> createState() => _TwoWheelerBookingListState();
}

class _TwoWheelerBookingListState extends State<TwoWheelerBookingList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<TwoWheelerBookingController>().getTwoWheelerBookings();
      Get.find<TwoWheelerBookingController>()
          .twowheelerscrollController
          .addListener(
              Get.find<TwoWheelerBookingController>().twowheelerscrollListener);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwoWheelerBookingController>(
      builder: (controller) {
        return controller.isLoading
            ? BookingShimmer()
            : controller.twowheelerbookingList.length == 0
                ? Center(child: NoOrderWidget())
                : ListView.separated(
                    controller: controller.twowheelerscrollController,
                    shrinkWrap: true,
                    itemCount: controller.twowheelerbookingList.length + 1,
                    physics: AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index == controller.twowheelerbookingList.length) {
                        return controller.isPaginating
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: CircularProgressIndicator(
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : const SizedBox();
                      }

                      TwoWheelerBookingListModel booking =
                          controller.twowheelerbookingList[index];
                      return GestureDetector(
                          onTap: () {
                            if (booking.status == "delivered" ||
                                booking.status == "cancelled") {
                              Navigator.push(
                                context,
                                getCustomRoute(
                                    child: TwoWheelerDeliveredPage(
                                  id: booking.id!,
                                )),
                              );
                            } else {
                              Navigator.push(
                                context,
                                getCustomRoute(
                                    child: IntransitOrderPage(
                                  id: booking.id!,
                                )),
                              );
                            }
                          },
                          child: TwoWheelerBookingCard(booking: booking));
                    },
                  );
      },
    );
  }
}
