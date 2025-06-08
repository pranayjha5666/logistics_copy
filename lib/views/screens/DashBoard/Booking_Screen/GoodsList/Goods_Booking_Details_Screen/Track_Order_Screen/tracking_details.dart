import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/booking_controller.dart';
import 'package:timelines_plus/timelines_plus.dart';

class TrackingDetails extends StatefulWidget {
  final int id;

  const TrackingDetails({super.key, required this.id});

  @override
  State<TrackingDetails> createState() => _TrackingDetailsState();
}

class _TrackingDetailsState extends State<TrackingDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: GetBuilder<BookingController>(
        builder: (controller) {
          final trackingSteps = controller.getTrackingSteps();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Timeline.tileBuilder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                builder: TimelineTileBuilder.connected(
                  connectionDirection: ConnectionDirection.before,
                  nodePositionBuilder: (context, index) {
                    return 0.3;
                  },
                  oppositeContentsBuilder: (context, index) {
                    final step = trackingSteps[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, bottom: 24.0, right: 12.0, top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (step["completed"]) ...[
                            const SizedBox(height: 5),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${step["time"]}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${step["date"]}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                  itemCount: trackingSteps.length,
                  indicatorBuilder: (context, index) {
                    final step = trackingSteps[index];
                    return DotIndicator(
                      size: 20.0,
                      color: step["completed"] ? Colors.green : Colors.grey,
                      child: Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      ),
                    );
                  },
                  connectorBuilder: (_, index, type) {
                    return SolidLineConnector(
                      color: trackingSteps[index]["completed"]
                          ? Colors.green
                          : Colors.grey.shade400,
                    );
                  },
                  contentsBuilder: (context, index) {
                    final step = trackingSteps[index];
                    return Padding(
                      padding:
                          EdgeInsets.only(left: 12.0, bottom: 24.0, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step["title"],
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            step["subtitle"],
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      )),
    );
  }
}
