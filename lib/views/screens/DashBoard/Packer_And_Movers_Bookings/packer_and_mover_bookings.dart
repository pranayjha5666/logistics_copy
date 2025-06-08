import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/data/models/response/packer_and_mover_booking_model.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/views/screens/DashBoard/Packer_And_Movers_Bookings/Components/no_order_widget.dart';
import 'package:logistics/views/screens/DashBoard/Packer_And_Movers_Bookings/Components/packers_and_mover_booking_card.dart';
import 'package:logistics/views/screens/DashBoard/dashboard.dart';
import '../../../../controllers/packers_and_mover_booking_controller.dart';
import '../../Shimmer/booking_shimmer.dart';
import '../../../base/timer_page.dart';
import '../Booking_Screen/GoodsList/Goods_Booking_Details_Screen/booking_details_page.dart';
import 'Packer_And_Mover_Placed_Screen/pacers_and_mover_placed_screen.dart';

class PackerAndMoverBookings extends StatefulWidget {
  PackerAndMoverBookings({
    super.key,
  });

  @override
  State<PackerAndMoverBookings> createState() => _PackerAndMoverBookingsState();
}

class _PackerAndMoverBookingsState extends State<PackerAndMoverBookings> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<PackersAndMoverBookingController>().getpackersandmoversBookings();
    Get.find<PackersAndMoverBookingController>().updatepage();
    Get.find<PackersAndMoverBookingController>().scrollController.addListener(
        Get.find<PackersAndMoverBookingController>().scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<PackersAndMoverBookingController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Center(child: BookingShimmer());
        } else if (controller.packerandmoverbookingList.length == 0)
          return Center(child: NoOrderWidget());
        return ListView.separated(
          physics: AlwaysScrollableScrollPhysics(),
          separatorBuilder: (context, index) => SizedBox(
            height: 10,
          ),
          controller: controller.scrollController,
          itemCount: controller.packerandmoverbookingList.length + 1,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index == controller.packerandmoverbookingList.length) {
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

            PackerAndMoverBookingModel booking =
                controller.packerandmoverbookingList[index];

            return GestureDetector(
              onTap: () async {
                if (booking.status == "placed") {
                  // Navigator.push(
                  //   context,
                  //   getCustomRoute(
                  //       child: TimerPage(
                  //     time: booking.createdAt!,
                  //     id: booking.id!,
                  //   )),
                  // );

                  Navigator.push(
                    context,
                    getCustomRoute(
                        child: PacersAndMoverPlacedScreen(
                      fromdetails: true,
                      lat: double.tryParse(
                              booking.locations?.first.latitude ?? '') ??
                          0.0,
                      lng: double.tryParse(
                              booking.locations?.first.longitude ?? '') ??
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
              child: PackersAndMoverBookingCard(
                booking: booking,
              ),
              // child: BookingCard(booking: booking),
            );
          },
        );
      },
    ));
  }
}
