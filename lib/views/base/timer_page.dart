import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/booking_controller.dart';
import 'package:logistics/controllers/timer_controller.dart';
import 'package:logistics/services/route_helper.dart';

import '../../services/theme.dart';
import 'common_button.dart';
import '../screens/DashBoard/Booking_Screen/GoodsList/Goods_Booking_Details_Screen/booking_details_page.dart';


class TimerPage extends StatefulWidget {
  final DateTime time;
  final int id;
  const TimerPage({super.key, required this.time, required this.id});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<TimerController>().startCountdown(widget.time);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Get.find<BookingController>()
            .getBookingsById(widget.id.toString());
        if (Get.find<BookingController>().bookingdetailsModel!.status !=
            "placed")
          Navigator.pushReplacement(context,
              getCustomRoute(child: BookingDetailsPage(id: widget.id)));
      },
      child: Scaffold(
        body: GetBuilder<TimerController>(
          builder: (controller) {
            final remaining = controller.remainingTime;
            final progress = controller.progress;
            return Center(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (remaining > 0)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 10,
                                backgroundColor: Colors.white,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(primaryColor),
                              ),
                            ),
                            Text(
                              "${(remaining ~/ 60).toString()}:${(remaining % 60).toString().padLeft(2, '0')}",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ],
                        )
                      else
                        const Icon(Icons.warning_amber_rounded,
                            size: 80, color: Colors.red),
                      const SizedBox(height: 25),
                      Text(
                        remaining > 0
                            ? "Wait 15 Min"
                            : "Sorry, it's taking time",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        remaining > 0
                            ? "Your booking has been placed. Our team will contact you soon."
                            : "It’s taking longer than expected to process your booking. Our team will contact you soon.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontSize: 18.0, color: Colors.black87),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                onTap: () {
                  Navigator.pop(context);
                },
                title: "Okay",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
