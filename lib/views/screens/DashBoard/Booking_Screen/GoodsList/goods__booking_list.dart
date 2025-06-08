import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/booking_controller.dart';

import '../../../../../data/models/response/booking_model.dart';
import '../../../../../services/route_helper.dart';
import '../../../Shimmer/booking_shimmer.dart';
import '../../Packer_And_Movers_Bookings/Components/no_order_widget.dart';

import '../../../../base/timer_page.dart';
import 'Goods_Booking_Details_Screen/booking_details_page.dart';
import 'Component/booking_card.dart';
import 'Goods_Placed_Screen/goods_placed_screen.dart';

class GoodsBookingsList extends StatefulWidget {
  const GoodsBookingsList({super.key});

  @override
  State<GoodsBookingsList> createState() => _GoodsBookingsListState();
}

class _GoodsBookingsListState extends State<GoodsBookingsList> {
  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BookingController>().getBookings();
      Get.find<BookingController>().updatepage();
      Get.find<BookingController>()
          .scrollController
          .addListener(Get.find<BookingController>().scrollListener);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(
      builder: (controller) {
        return controller.isLoading
            ? BookingShimmer()
            : controller.bookingList.length == 0
                ? Center(
                    child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.8, // Enough height for pull-to-refresh
                      child: Center(child: NoOrderWidget()),
                    ),
                  ))
                : ListView.separated(
                    controller: controller.scrollController,
                    shrinkWrap: true,
                    itemCount: controller.bookingList.length + 1,
                    physics: AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index == controller.bookingList.length) {
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

                      BookingModel booking = controller.bookingList[index];

                      return GestureDetector(
                        onTap: () async {
                          if (booking.status == "placed") {

                            Navigator.push(
                              context,
                              getCustomRoute(
                                  child: GoodsPlacedScreen(
                                    fromdetails: true,
                                lat: double.tryParse(
                                        booking.locations?.first.latitude ??
                                            '') ??
                                    0.0,
                                lng: double.tryParse(
                                        booking.locations?.first.longitude ??
                                            '') ??
                                    0.0,
                                date: booking.createdAt ?? DateTime.now(),
                                id: booking.id ?? 0,
                              )),
                            );
                          } else {
                            Navigator.push(
                              context,
                              getCustomRoute(
                                  child: BookingDetailsPage(
                                id: booking.id!,
                              )),
                            );
                          }
                        },
                        child: BookingCard(booking: booking),
                      );
                    },
                  );
      },
    );
  }
}
