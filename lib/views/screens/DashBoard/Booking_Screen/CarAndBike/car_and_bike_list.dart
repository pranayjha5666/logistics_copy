import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logistics/controllers/car_and_bike_controller.dart';
import 'package:logistics/data/models/response/car_and_bike_model.dart';
import 'package:logistics/views/screens/DashBoard/Booking_Screen/CarAndBike/component/car_and_bike_booking_card.dart';

import '../../../Shimmer/booking_shimmer.dart';
import '../../Packer_And_Movers_Bookings/Components/no_order_widget.dart';

class CarAndBikeList extends StatefulWidget {
  const CarAndBikeList({super.key});

  @override
  State<CarAndBikeList> createState() => _CarAndBikeListState();
}

class _CarAndBikeListState extends State<CarAndBikeList> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CarAndBikeController>().getcarandbikebooking();
      Get.find<CarAndBikeController>().updatepage();
      Get.find<CarAndBikeController>().carandbikescrollController.addListener(
          Get.find<CarAndBikeController>().carandbikesscrollListener);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CarAndBikeController>(
      builder: (controller) {
        return controller.isLoading
            ? BookingShimmer()
            : controller.carAndBikeBookingList.length == 0
                ? Center(child: NoOrderWidget())
                : ListView.separated(
                    controller: controller.carandbikescrollController,
                    shrinkWrap: true,
                    itemCount: controller.carAndBikeBookingList.length + 1,

                    physics: AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index == controller.carAndBikeBookingList.length) {
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

                      CarAndBikeModel booking =
                          controller.carAndBikeBookingList[index];
                      return GestureDetector(
                          // onTap: () {
                          //   if (booking.status == "delivered" ||
                          //       booking.status == "cancelled") {
                          //     Navigator.push(
                          //       context,
                          //       getCustomRoute(
                          //           child: TwoWheelerDeliveredPage(
                          //             id: booking.id!,
                          //           )),
                          //     );
                          //   } else {
                          //     Navigator.push(
                          //       context,
                          //       getCustomRoute(
                          //           child: IntransitOrderPage(
                          //             id: booking.id!,
                          //           )),
                          //     );
                          //   }
                          // },
                          child: CarAndBikeBookingCard(booking: booking));
                    },
                  );
      },
    );
  }
}
