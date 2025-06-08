import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/booking_controller.dart';
import 'package:logistics/services/extensions.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/views/base/common_button.dart';
import 'Component/payment_info_section.dart';
import 'Component/location_timeline.dart';
import 'Component/show_amount_dailog.dart';
import 'booked_home_items_list_page.dart';

class BookingInfoScreen extends StatefulWidget {
  final int id;
  const BookingInfoScreen({super.key, required this.id});
  @override
  State<BookingInfoScreen> createState() => _BookingInfoScreen();
}

class _BookingInfoScreen extends State<BookingInfoScreen> {
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'placed':
        return const Color(0xFF6C63FF);
      case 'confirmed':
        return const Color(0xFF00C060);
      case 'intransit':
        return const Color(0xFFFFC107);
      case 'delivered':
        return Colors.green.shade800;
      default:
        return const Color(0xFFFF4654); // cancelled or unknown
    }
  }

  String getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'placed':
        return "Placed";
      case 'confirmed':
        return "Confirmed";
      case 'intransit':
        return "In Transit";
      case 'delivered':
        return "Delivered";
      default:
        return "Cancelled";
    }
  }

  String getDeliveryStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'on_time':
        return "On Time";
      case 'delay':
        return "Delay";
      case 'early':
        return "Early";
      default:
        return "On Time";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: () async {
            Get.find<BookingController>().getBookingsById(widget.id.toString());
          },
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
            ),
            child: GetBuilder<BookingController>(
              builder: (controller) {
                final booking = controller.bookingdetailsModel;
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              color: Color(0xffF5F5F5),
                              child: Row(
                                children: [
                                  if (booking?.pickupDate != null)
                                    Text(
                                      "${(booking?.pickupDate)?.dateTime}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              color: const Color(0xff868686),
                                              fontWeight: FontWeight.w600),
                                    ),
                                  const Spacer(),
                                  if (booking?.status != null)
                                    Container(
                                      width: 95,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: getStatusColor(
                                            booking!.status ?? ''),
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                                booking.status == 'delivered'
                                                    ? Icons.check
                                                    : Icons.star,
                                                color: Colors.white,
                                                size: 12),
                                            const SizedBox(width: 6),
                                            Text(
                                                getStatusText(
                                                    booking.status ?? ''),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge
                                                    ?.copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 11)),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade100),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: const LocationTimeline(),
                                  ),
                                ),
                                Container(
                                  height: 10,
                                  color: Color(0xffF5F5F5),
                                ),
                                if (booking?.status == "delivered")
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    // decoration: BoxDecoration(
                                    //   // border:
                                    //   //     Border.all(color: Colors.grey.shade100),
                                    //   color: Colors.white,
                                    //   borderRadius: BorderRadius.circular(2),
                                    // ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Delivered Date:",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        const Spacer(),
                                        Text(
                                          booking!.delivered!.dateTime,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall
                                              ?.copyWith(
                                                  color:
                                                      const Color(0xff868686),
                                                  fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  )
                                else if (booking?.estimatedDeliveryDate != null)
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    // decoration: BoxDecoration(
                                    //   border:
                                    //       Border.all(color: Colors.grey.shade100),
                                    //   color: Colors.white,
                                    //   borderRadius: BorderRadius.circular(2),
                                    // ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Est. Delivery Date:",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        const Spacer(),
                                        Text(
                                          booking!.estimatedDeliveryDate!.dMy,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                  color:
                                                      const Color(0xff868686),
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(width: 12),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: (booking.deliveryStatus
                                                            ?.toLowerCase() ??
                                                        '') !=
                                                    'delay'
                                                ? Colors.green
                                                : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          // padding: const EdgeInsets.symmetric(
                                          //     vertical: 5),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child: Text(
                                              getDeliveryStatusText(
                                                  booking.deliveryStatus),
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                      color: Colors.white,
                                                      fontSize: 8)),
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((booking?.tripStartOtpVerified
                                                ?.toLowerCase() ??
                                            '') ==
                                        'no' &&
                                    booking?.tripStartOtp != null) ...[
                                  Container(
                                    height: 10,
                                    color: Color(0xffF5F5F5),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Trip Start Otp",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        const Spacer(),
                                        Text(
                                          booking?.tripStartOtp?.toString() ??
                                              '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                if ((booking?.bookingGoodHomeItems?.length !=
                                    0)) ...[
                                  Container(
                                    height: 10,
                                    color: Color(0xffF5F5F5),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          getCustomRoute(
                                              child: HomeItemsListPage(
                                            homeitems:
                                                booking!.bookingGoodHomeItems!,
                                          )));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                        gradient: const LinearGradient(colors: [
                                          Color(0xff09596F),
                                          Color(0xff11ABD5)
                                        ]),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Home Items List",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.arrow_circle_right_rounded,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],

                                // Container(
                                //   height: 10,
                                //   color: Color(0xffF5F5F5),
                                // ),
                                // DeliveredMap(),
                                Container(
                                  height: 10,
                                  color: Color(0xffF5F5F5),
                                ),
                                PaymentInfoSection(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: GetBuilder<BookingController>(
          builder: (controller) {
            int remainingamount = controller.remainingamount;
            if (controller.isLoading) return const SizedBox.shrink();
            return Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (controller.remainingamount != 0)
                    CustomButton(
                      height: 30,
                      onTap: () async {
                        final amount = await showDialog<String>(
                          context: context,
                          builder: (context) => ShowAmountDailog(
                              remainingamount: remainingamount),
                        );

                        if (amount != null) {
                          Map<String, dynamic> data = {
                            "booking_goods_id": widget.id,
                            "amount": amount.toString()
                          };
                          await Get.find<BookingController>()
                              .createpayment(data);
                          Get.find<BookingController>()
                              .getBookingsById(widget.id.toString());
                        }
                      },
                      title: "Pay",
                    ),
                ],
              ),
            );
          },
        ));
  }
}
