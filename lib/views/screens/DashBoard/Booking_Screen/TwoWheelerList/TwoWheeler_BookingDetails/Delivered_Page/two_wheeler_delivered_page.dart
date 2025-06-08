import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/two_wheeler_booking_controller.dart';
import 'package:logistics/views/screens/DashBoard/Booking_Screen/TwoWheelerList/TwoWheeler_BookingDetails/Delivered_Page/Components/order_cancel_section.dart';
import '../../../../../../../services/route_helper.dart';
import '../../../../../../../services/theme.dart';
import '../../../../dashboard.dart';
import 'Components/address_section.dart';
import 'Components/dates_and_packages_type_section.dart';
import 'Components/two_wheeler_delivered_map.dart';
import 'Components/payment_section.dart';
import 'Components/driver_detais_section.dart';
import 'Shimmer/two_wheeler_detials_page_shimmer.dart';

class TwoWheelerDeliveredPage extends StatefulWidget {
  final int id;

  const TwoWheelerDeliveredPage({
    super.key,
    required this.id,
  });

  @override
  State<TwoWheelerDeliveredPage> createState() =>
      _TwoWheelerBookingDetailsPageState();
}

class _TwoWheelerBookingDetailsPageState
    extends State<TwoWheelerDeliveredPage> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<TwoWheelerBookingController>()
          .gettwowheelerbookingsById(widget.id.toString());
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.pushAndRemoveUntil(
          context,
          getCustomRoute(
              child: Dashboard(
            initialIndex: 1,
            bookingpage: 1,
          )),
          (route) => false,
        );
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          leading: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                getCustomRoute(
                    child: Dashboard(
                  initialIndex: 1,
                )),
                (route) => false,
              );
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
          ),
          title: Text(
            "Booking Details",
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(fontSize: 16),
          ),
          actions: [
            GetBuilder<TwoWheelerBookingController>(
              builder: (controller) {
                if (controller.isLoading ||
                    controller.twowheelerbookingdetailsModel == null)
                  return SizedBox();
                else
                  return Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      "#${controller.twowheelerbookingdetailsModel!.bookingId!.toUpperCase()}",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              fontSize: 14,
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                    ),
                  );
              },
            )
          ],
        ),
        body: RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: () async {
            Get.find<TwoWheelerBookingController>()
                .gettwowheelerbookingsById(widget.id.toString());
          },
          child: GetBuilder<TwoWheelerBookingController>(
            builder: (controller) {
              if (controller.isLoading)
                // return Center(child: CircularProgressIndicator());
                return ShimmerTwoWheelerDeliveredPage();
              if (controller.twowheelerbookingdetailsModel == null)
                return Center(child: Text("Order Not Found"));
              else {
                return SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DatesAndPackagesTypeSection(),
                    Container(height: 10, color: const Color(0xffF1F1F1)),
                    if (controller.twowheelerbookingdetailsModel!.status !=
                        "cancelled")
                      DriverDetaisSection()
                    else
                      OrderCancelSection(),
                    Container(height: 10, color: const Color(0xffF1F1F1)),
                    TwoWheelerDeliveredMap(),
                    Container(height: 10, color: const Color(0xffF1F1F1)),
                    AddressSection(),
                    Container(height: 10, color: const Color(0xffF1F1F1)),
                    PaymentSection(),
                  ],
                ));
              }
            },
          ),
        ),
      ),
    );
  }
}
