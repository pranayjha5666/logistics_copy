import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../../../../controllers/two_wheeler_booking_controller.dart';

class MovingLineContainer extends StatefulWidget {
  @override
  _MovingLineContainerState createState() => _MovingLineContainerState();
}

class _MovingLineContainerState extends State<MovingLineContainer>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var controller = Get.find<TwoWheelerBookingController>();
      controller.initAnimationControllers(this);
    });
  }



  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;

    return GetBuilder<TwoWheelerBookingController>(
      builder: (controller) {
        if (!controller.animationInitialized || controller.hideContainer) {
          return const SizedBox.shrink();
        }
        return !controller.hideContainer
            ? SlideTransition(
                position: controller.slideAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: 50,
                      width: fullWidth,
                      color: Colors.red,
                      child: Stack(
                        children: [
                          Container(
                            height: 5,
                            width: fullWidth,
                            color: Colors.grey,
                          ),
                          AnimatedBuilder(
                            animation: controller.fillAnimation,
                            builder: (context, child) {
                              log("Fill Animation Value: ${controller.fillAnimation.value}", name: "Animation Debug");

                              return Container(
                                height: 5,
                                width: controller.fillAnimation.value * fullWidth,
                                color: Colors.white,
                              );
                            },
                          ),
                          Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink();
      },
    );
  }
}


// start from 30 sec it start form the time remainnng ie timediff