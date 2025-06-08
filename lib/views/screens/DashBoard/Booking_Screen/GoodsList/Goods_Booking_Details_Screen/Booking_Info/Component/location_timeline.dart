import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logistics/controllers/booking_controller.dart';
import 'package:logistics/services/extensions.dart';
import 'package:timelines_plus/timelines_plus.dart';

class LocationTimeline extends StatelessWidget {
  const LocationTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(builder: (controller) {
      final bookingdetailsModel = controller.bookingdetailsModel;

      if (bookingdetailsModel == null ||
          bookingdetailsModel.locations == null) {
        return const SizedBox.shrink();
      }

      final locations = bookingdetailsModel.locations!;
      int pickupCount = 0;
      int dropCount = 0;

      return Timeline.tileBuilder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.before,
          nodePositionBuilder: (context, index) => 0,
          itemCount: locations.length,
          indicatorBuilder: (context, index) {
            final location = locations[index];
            final isDone = location.status == "done";
            return DotIndicator(
              size: 20.0,
              color: isDone ? Colors.green : null,
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // color: isDone ? location.type == "pickup"
                    //     ? Colors.green
                    //     : Colors.red : Colors.white,

                    color: isDone ? Colors.green : Colors.white,
                    border: Border.all(
                      // color: isDone ? location.type == "pickup"
                      //     ? Colors.green
                      //     : Colors.red : Colors.grey.shade400

                      color: isDone ? Colors.green : Colors.grey.shade400,
                    ),
                  ),
                  child: Icon(Icons.check,
                      color: isDone ? Colors.white : Colors.grey[500],
                      size: 12)),
            );
          },
          connectorBuilder: (_, index, type) {
            final isDone = locations[index].status == "done";
            // return DashedLineConnector(
            //
            //   gap: 1.0,
            //   // color: isDone ? locations[index].type == "pickup"
            //   //     ? Colors.green
            //   //     : Colors.red : Colors.grey[400],
            //
            //   color: isDone ?  Colors.green
            //       : Colors.grey[400],
            // );

            return SolidLineConnector(
              color: isDone ? Colors.green : Colors.grey[400],
            );
          },
          contentsBuilder: (context, index) {
            final location = locations[index];

            String pickupOrDrop;
            if (location.type == "pickup") {
              pickupCount++;
              pickupOrDrop = "Pick up $pickupCount";
            } else {
              dropCount++;
              pickupOrDrop = "Drop $dropCount";
            }

            final address = location.addressLineOne ?? "No address provided";
            final doneAt = location.doneAt;
            final isDone = location.status == "done";

            return Padding(
              padding: EdgeInsets.only(
                  left: 25.0, top: index == 0 ? 30 : 10, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        pickupOrDrop,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                color: location.type == "pickup"
                                    ? Colors.green
                                    : Colors.red,
                                // color: isDone?Colors.black: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 10.5),
                      ),
                      const SizedBox(width: 10),
                      if (doneAt != null)
                        Container(
                          color: Color(0xff019539),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 5),
                            child: Text(
                              "${doneAt.dateTime}",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    address,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
