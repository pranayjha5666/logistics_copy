import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../controllers/two_wheeler_booking_controller.dart'; // <-- Update import as per your structure

class FlipTimerIconWidget extends StatefulWidget {
  @override
  State<FlipTimerIconWidget> createState() => _FlipTimerIconWidgetState();
}

class _FlipTimerIconWidgetState extends State<FlipTimerIconWidget>
    with TickerProviderStateMixin {
  bool showTimer = true;

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      final remaining = Get.find<TwoWheelerBookingController>().remainingtime;
      if (remaining > 0) {
        setState(() => showTimer = !showTimer);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwoWheelerBookingController>(
      builder: (controller) {
        if (controller.remainingtime == 0) return SizedBox();

        return AnimatedSwitcher(
          duration: Duration(milliseconds: 600),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final rotateAnim = Tween(begin: 1.0, end: 0.0).animate(animation);
            return AnimatedBuilder(
              animation: rotateAnim,
              child: child,
              builder: (context, child) {
                final isUnder = (ValueKey(showTimer) != child!.key);
                final value =
                    isUnder ? min(rotateAnim.value, 0.5) : rotateAnim.value;
                return Transform(
                  transform: Matrix4.rotationY(value * pi),
                  alignment: Alignment.center,
                  child: child,
                );
              },
            );
          },
          child: Container(
            key: ValueKey(showTimer),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFFFF3B30), // Perfect red
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: showTimer
                ? Text(
                    '${controller.remainingtime}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Icon(Icons.delete, color: Colors.white),
          ),
        );
      },
    );
  }
}
