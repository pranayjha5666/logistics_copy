import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/views/base/common_button.dart';
import 'package:logistics/views/screens/DashBoard/Booking_Screen/TwoWheelerList/TwoWheeler_BookingDetails/InTransit_Order_Page/Components/intransit_dragabbble_page.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../../controllers/two_wheeler_booking_controller.dart';
import '../../../../../../../services/route_helper.dart';
import '../../../../../../../services/theme.dart';
import '../../../../dashboard.dart';
import '../Delivered_Page/Components/dates_and_packages_type_section.dart';
import '../Delivered_Page/two_wheeler_delivered_page.dart';
import '../Pending_Order_Page/Components/cancel_order_dailog.dart';
import 'Components/intransit_map.dart';
import 'Components/timer.dart';
import 'Components/timer_cancel_widget.dart';
import 'Components/timer_dismissal_bar.dart';
import 'Shimmer/intrasnit_page_shimmer.dart';

class IntransitOrderPage extends StatefulWidget {
  final int id;
  IntransitOrderPage({super.key, required this.id});

  @override
  State<IntransitOrderPage> createState() => _IntransitOrderPage();
}

class _IntransitOrderPage extends State<IntransitOrderPage> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<TwoWheelerBookingController>();
      controller.gettwowheelerbookingsById(widget.id.toString()).then((value) {
        controller.checkIfShouldShowContainer(
            controller.twowheelerbookingdetailsModel!.accepted!);
      });
    });

    super.initState();
  }

  DraggableScrollableController _draggableController =
      DraggableScrollableController();

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
            bookingpage: 0,
          )),
          (route) => false,
        );
      },
      child: Scaffold(
        body: SafeArea(
          child: GetBuilder<TwoWheelerBookingController>(
            builder: (controller) {
              if (controller.isLoading) return IntrasnitPageShimmer();
              if (controller.twowheelerbookingdetailsModel == null)
                return Container(
                  child: Text("Order Not Found"),
                );
              else {
                return Stack(
                  children: [
                    IntransitMap(),
                    Positioned(
                      left: 10,
                      top: 20,
                      child: GestureDetector(
                        onTap: () {
                          Get.find<TwoWheelerBookingController>()
                              .gettwowheelerbookingsById(widget.id.toString())
                              .then(
                            (value) {
                              if (value.isSuccess) {
                                if (controller.twowheelerbookingdetailsModel!
                                        .status ==
                                    "delivered") {
                                  Navigator.push(
                                      context,
                                      getCustomRoute(
                                          child: TwoWheelerDeliveredPage(
                                              id: widget.id)));
                                }
                              }
                            },
                          );

                          Get.find<TwoWheelerBookingController>()
                              .remainingtimeforcancel();
                          Get.find<TwoWheelerBookingController>()
                              .checkIfShouldShowContainer(controller
                                  .twowheelerbookingdetailsModel!.accepted!);
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                          ),
                          child: Icon(Icons.refresh, color: Colors.white),
                        ),
                      ),
                    ),
                    DraggableScrollableSheet(
                      controller: _draggableController,
                      initialChildSize: 0.45,
                      minChildSize: 0.35,
                      maxChildSize: 0.65,
                      builder: (context, sheetScrollController) {
                        return Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(blurRadius: 10, color: Colors.black26)
                            ],
                          ),
                          child: CustomScrollView(
                            controller: sheetScrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            slivers: [
                              SliverAppBar(
                                toolbarHeight: 71,
                                pinned: true,
                                backgroundColor: Colors.white,
                                flexibleSpace: FlexibleSpaceBar(
                                  titlePadding: EdgeInsets.zero,
                                  title: Column(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 5,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      DatesAndPackagesTypeSection(
                                        isbooked: false,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SliverList(
                                delegate: SliverChildListDelegate.fixed(
                                  [
                                    IntransitDragabbblePage(id: widget.id),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CancelOrderDailog(
                                orderId: widget.id.toString(),
                                isintransit: true,
                              );
                            },
                          );
                        },
                        child: TimedDismissibleBar(
                          accepted: controller
                              .twowheelerbookingdetailsModel!.accepted!,
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
