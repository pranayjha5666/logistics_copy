import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../../../data/models/response/packer_and_mover_booking_model.dart';

class PackersAndMoverCardLocationSection extends StatelessWidget {
  final PackerAndMoverBookingModel booking;

  PackersAndMoverCardLocationSection({super.key, required this.booking});

  Widget _buildLocationRow(
    BuildContext context,
    PackersLocation? location,
    bool isFirst,
    bool isLast,
    bool isSummary, [
    int totalPickup = 0,
    int totalDrop = 0,
  ]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: isLast ? 10 : 0,
                  top: isFirst
                      ? 10
                      : isLast
                          ? 3
                          : 5),
              child: Container(
                margin: EdgeInsets.only(top: 5),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSummary
                      ? Colors.grey
                      : location!.type == "pickup"
                          ? const Color(0xFF00C060)
                          : const Color(0xFFEB0404),
                ),
                child: const Icon(Icons.circle, color: Colors.white, size: 10),
              ),
            ),
            if (!isLast)
              SizedBox(
                width: 40,
                height: isSummary ? 15 : 20,
                child: DottedBorder(
                  strokeWidth: 2,
                  dashPattern: const [2, 2],
                  color: Colors.grey,
                  customPath: (size) {
                    return Path()
                      ..moveTo(size.width / 2, 4)
                      ..lineTo(size.width / 2, 40);
                  },
                  child: const SizedBox(),
                ),
              ),
          ],
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Container(
            margin:
                EdgeInsets.only(top: isFirst ? 3 : 0, bottom: isFirst ? 10 : 0),
            padding:
                EdgeInsets.only(top: isFirst ? 12 : 8, left: isLast ? 10 : 0),
            child: isSummary
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (totalPickup > 1) ...[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          child: Text(
                            "$totalPickup Pickup",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Poppins",
                                  color: Colors.green,
                                ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                      if (totalDrop > 1)
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          child: Text(
                            "${totalDrop - 1} Drop",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Poppins",
                                ),
                          ),
                        ),
                    ],
                  )
                : Text(
                    "${location!.addressLineOne}, ${location.pincode}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 12,
                        color: const Color(0xFF353535),
                        fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final locations = booking.locations ?? [];

    int totalPickup = locations.where((loc) => loc.type == "pickup").length;
    int totalDrop = locations.where((loc) => loc.type == "drop").length;

    final bool showAll = totalPickup == 1 && totalDrop == 1;

    // Extract first pickup and last drop
    final firstPickup = locations.firstWhere((loc) => loc.type == "pickup",
        orElse: () => locations.first);
    final lastDrop = locations.lastWhere((loc) => loc.type == "drop",
        orElse: () => locations.last);

    final List<Widget> locationWidgets = [];

    if (showAll) {
      for (int i = 0; i < locations.length; i++) {
        bool isLast = i == locations.length - 1;
        bool isFirst = i == 0;

        locationWidgets.add(
            _buildLocationRow(context, locations[i], isFirst, isLast, false));
      }
    } else {
      // First pickup
      locationWidgets
          .add(_buildLocationRow(context, firstPickup, true, false, false));

      // Middle Summery
      locationWidgets.add(_buildLocationRow(
          context, null, false, false, true, totalPickup, totalDrop));

      // Last drop
      locationWidgets
          .add(_buildLocationRow(context, lastDrop, false, true, false));
    }

    return Container(
      padding:
          const EdgeInsets.only(left: 0.0, right: 4.0, top: 0.0, bottom: 16.0),
      child: Column(children: locationWidgets),
    );
  }
}
