import 'dart:developer';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logistics/controllers/pusher_controller.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/base/common_button.dart';
import 'package:logistics/views/screens/DashBoard/Booking_Screen/TwoWheelerList/TwoWheeler_BookingDetails/Pending_Order_Page/Components/cancel_order_dailog.dart';
import 'package:lottie/lottie.dart';
import '../../../../../../../controllers/two_wheeler_booking_controller.dart';
import '../../../../../../../generated/assets.dart';
import '../InTransit_Order_Page/intransit_order_page.dart';

class PendingOrderPage extends StatefulWidget {
  final double lat;
  final double lng;
  final int id;
  const PendingOrderPage(
      {super.key, required this.lat, required this.lng, required this.id});

  @override
  State<PendingOrderPage> createState() => _PendingOrderMapState();
}

class _PendingOrderMapState extends State<PendingOrderPage> {
  @override
  void initState() {
    super.initState();
    Get.find<TwoWheelerBookingController>().startCountdown();
    Get.find<PusherController>().initializepusher(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<TwoWheelerBookingController>(
      builder: (controller) {
        double progress = controller.passedSeconds / 600;
        log(controller.driverLatLng.toString(), name: "Driverlatlng");
        log(LatLng(widget.lat, widget.lng).toString(), name: "UserLatlng");

        return Stack(
          children: [
            gmaps.GoogleMap(
              initialCameraPosition: gmaps.CameraPosition(
                target: gmaps.LatLng(widget.lat, widget.lng),
                zoom: 14,
              ),
              onMapCreated: (mapcontroller) {
                controller.updateismapcreated();
              },
              markers: {
                // gmaps.Marker(
                //   markerId: gmaps.MarkerId('pickup'),
                //   position: gmaps.LatLng(widget.lat, widget.lng),
                //   infoWindow: gmaps.InfoWindow(title: 'Pickup Location'),
                // ),
                if (controller.driverLatLng != null) ...[
                  gmaps.Marker(
                    markerId: gmaps.MarkerId('driver'),
                    position: controller.driverLatLng!,
                    infoWindow: gmaps.InfoWindow(title: 'Driver Location'),
                    icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
                      gmaps.BitmapDescriptor.hueBlue,
                    ),
                  ),
                ]
              },
              onCameraMove: (position) {
                controller.onCameraMove(position.target); // Your method
              },
              onCameraIdle: () {
                controller.onCameraIdle();
              },
            ),
            if (controller.ismapcreated)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.7,
                  child: Lottie.asset(
                    Assets.imagesMapSearchLottie,
                    fit: BoxFit.contain,
                    width: 20,
                    height: 20,
                    delegates: LottieDelegates(
                      values: [
                        ValueDelegate.color(
                          const ['**'],
                          value: primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            DraggableScrollableSheet(
              initialChildSize: 0.35,
              minChildSize: 0.15,
              maxChildSize: 0.35,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(blurRadius: 10, color: Colors.black26),
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Text(
                          controller.messages[controller.currentMessageIndex],
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: progress,
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Lottie.asset(
                          Assets.imagesFindingDriverAnimation,
                          height: 150,
                          delegates: LottieDelegates(
                            values: [
                              ValueDelegate.color(
                                const ['**'],
                                value: primaryColor,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        CustomButton(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CancelOrderDailog(
                                    orderId: widget.id.toString());
                              },
                            );
                          },
                          color: Colors.red,
                          title: "Cancel",
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    ));
  }
}
