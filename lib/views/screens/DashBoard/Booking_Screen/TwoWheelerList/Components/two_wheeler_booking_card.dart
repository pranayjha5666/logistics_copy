import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:logistics/data/models/response/two_wheeler_booking_list_model.dart';
import 'package:logistics/services/extensions.dart';

import 'card_location_section.dart';

class TwoWheelerBookingCard extends StatelessWidget {
  final TwoWheelerBookingListModel booking;
  const TwoWheelerBookingCard({super.key, required this.booking});

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return const Color(0xFF6C63FF);
      case 'confirmed':
        return const Color(0xFF00C060);
      case 'inprocess':
        return const Color(0xFFDCA812);
      case 'delivered':
        return Colors.green.shade800;
      default:
        return const Color(0xFFFF4654);
    }
  }

  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return "Placed";
      case 'confirmed':
        return "Confirmed";
      case 'inprocess':
        return "In Transit";
      case 'delivered':
        return "Delivered";
      default:
        return "Cancelled";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffD9D9D9)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "ID: ${booking.bookingId != null ? booking.bookingId!.toUpperCase() : "NA"}",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 95,
                      height: 30,
                      decoration: BoxDecoration(
                        color: getStatusColor(booking.status ?? ''),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                                booking.status == 'delivered'
                                    ? Icons.check
                                    : booking.status == 'cancelled'
                                        ? Icons.close
                                        : Icons.local_shipping,
                                color: Colors.white,
                                size: 12),
                            const SizedBox(width: 6),
                            Text(getStatusText(booking.status ?? ''),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11)),

                            // Text(booking.status!.toUpperCase(),
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .labelLarge
                            //         ?.copyWith(
                            //         color: Colors.white,
                            //         fontWeight: FontWeight.w500,
                            //         fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // const SizedBox(height: 8),
          Divider(
            color: Colors.grey[200],
            height: 1,
          ),

          CardLocationSection(
            booking: booking,
          ),

          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xffF6F6F6),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${booking.createdAt!.dateTime}",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff646363)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    // booking.bookingType!.toUpperCase(),

                    booking.bookingType == "two_wheeler"
                        ? "TWO WHEELER"
                        : "TEMPO",
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
        ],
      ),
    );
  }
}
