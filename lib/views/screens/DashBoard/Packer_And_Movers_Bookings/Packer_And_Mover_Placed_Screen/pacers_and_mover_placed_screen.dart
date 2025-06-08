import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/packers_and_mover_booking_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import '../../../../../generated/assets.dart';
import '../../../../../services/route_helper.dart';
import '../../../../../services/theme.dart';
import '../../dashboard.dart';

class PacersAndMoverPlacedScreen extends StatefulWidget {
  final bool? fromdetails;
  final int id;
  final double lat;
  final double lng;
  final DateTime date;
  const PacersAndMoverPlacedScreen(
      {super.key,
      this.fromdetails,
      required this.id,
      required this.lat,
      required this.lng,
      required this.date});

  @override
  State<PacersAndMoverPlacedScreen> createState() =>
      _PacersAndMoverPlacedScreenState();
}

class _PacersAndMoverPlacedScreenState
    extends State<PacersAndMoverPlacedScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<PackersAndMoverBookingController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startProgressTracking(widget.date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (widget.fromdetails != null) {
            Navigator.pop(context);
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              getCustomRoute(child: Dashboard()),
              (route) => false,
            );
          }
        }
      },
      child: Scaffold(
        body: GetBuilder<PackersAndMoverBookingController>(
          builder: (controller) {
            return controller.isLoading
                ? CircularProgressIndicator()
                : Stack(
                    children: [
                      gmaps.GoogleMap(
                        initialCameraPosition: gmaps.CameraPosition(
                          target: gmaps.LatLng(widget.lat, widget.lng),
                          zoom: 14,
                        ),
                        onMapCreated: (mapcontroller) {
                          controller.updateismapcreated();
                        },
                        markers: {},
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
                      if (controller.ismapcreated)
                        DraggableScrollableSheet(
                          initialChildSize: 0.30,
                          minChildSize: 0.15,
                          maxChildSize: 0.30,
                          builder: (context, scrollController) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10, color: Colors.black26),
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
                                      textAlign: TextAlign.center,
                                      controller.isDelayed
                                          ? "It’s taking longer than expected to process your booking. Our team will contact you soon."
                                          : "Your booking has been placed. Our team will contact you soon.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18),
                                    ),
                                    const SizedBox(height: 12),
                                    Stack(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        //
                                        FractionallySizedBox(
                                          widthFactor: controller.progress,
                                          child: Container(
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Lottie.asset(
                                      Assets.lottieTimerLottieAnimation,
                                      height: 150,
                                    ),
                                    const SizedBox(height: 4),
                                    // CustomButton(
                                    //   onTap: () {
                                    //     // showDialog(
                                    //     //   context: context,
                                    //     //   builder: (context) {
                                    //     //     return CancelOrderDailog(
                                    //     //         orderId: widget.id.toString());
                                    //     //   },
                                    //     // );
                                    //   },
                                    //   color: Colors.red,
                                    //   title: "Cancel",
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
