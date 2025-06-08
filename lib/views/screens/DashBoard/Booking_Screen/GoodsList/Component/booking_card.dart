import 'package:logistics/services/extensions.dart';
import 'package:logistics/services/theme.dart';
import 'package:flutter/material.dart';
import '../../../../../../data/models/response/booking_model.dart';
import 'goods_card_location_section.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  const BookingCard({super.key, required this.booking});

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

  String? getCustomStatusLabel(List<Location> locations) {
    int pickupCount = 0;
    int dropCount = 0;
    final Map<int, int> typeCountMap = {};

    for (int i = 0; i < locations.length; i++) {
      final type = locations[i].type?.toLowerCase();
      if (type == 'pickup') {
        pickupCount++;
        typeCountMap[i] = pickupCount;
      } else if (type == 'drop') {
        dropCount++;
        typeCountMap[i] = dropCount;
      }
    }

    for (int i = locations.length - 1; i >= 0; i--) {
      if (locations[i].doneAt != null) {
        final type = locations[i].type?.toLowerCase();
        final count = typeCountMap[i] ?? 0;
        if (type == 'pickup') return 'Pickup $count';
        if (type == 'drop') return 'Drop $count';
      }
    }
    return null;
  }

  String getStatusText(String status) {
    switch (status.toLowerCase()) {
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
                if (booking.driver != null &&
                    booking.driver!.vehicleNumber != null)
                  Text(
                    booking.driver!.vehicleNumber.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
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
                          ],
                        ),
                      ),
                    ),
                    if (booking.status?.toLowerCase() == 'intransit' &&
                        booking.locations != null &&
                        booking.locations?.first.doneAt != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        width: 65,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 15,
                            ),
                            Text(
                                textAlign: TextAlign.center,
                                booking.status?.toLowerCase() == 'intransit'
                                    ? getCustomStatusLabel(
                                            booking.locations!) ??
                                        getStatusText(booking.status ?? '')
                                    : getStatusText(booking.status ?? ''),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 9)),
                          ],
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

          GoodsCardLocationSection(booking: booking),
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
                  "${booking.pickupDate!.dateTime}",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff646363)),
                ),
                if (booking.estimatedDeliveryDate != null)
                  Expanded(
                    child: Text(
                      "Est. Delivery: ${booking.estimatedDeliveryDate!.dMy}",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff646363)),
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
