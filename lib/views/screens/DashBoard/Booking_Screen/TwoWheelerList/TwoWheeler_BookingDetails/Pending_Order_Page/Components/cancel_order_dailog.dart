import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logistics/controllers/two_wheeler_booking_controller.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/views/screens/DashBoard/dashboard.dart';

import '../../../../../../../base/common_button.dart';

class CancelOrderDailog extends StatelessWidget {
  bool? isintransit;
  final String orderId;
  CancelOrderDailog({super.key, required this.orderId, this.isintransit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Are you sure you want to cancel this order?",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: CustomButton(
                  type: ButtonType.secondary,
                  title: 'No',
                  height: 20,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: GetBuilder<TwoWheelerBookingController>(
                  builder: (controller) {
                    return CustomButton(
                      isLoading: controller.isLoading,
                      type: ButtonType.primary,
                      title: 'Yes, Cancel',
                      height: 20,
                      onTap: () {
                        controller.cancelTwoWheelerOrder(orderId).then(
                          (value) {
                            if (value.isSuccess) {
                              if (isintransit == null) {
                                Navigator.pop(context);
                                Navigator.maybePop(context);
                              } else {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  getCustomRoute(
                                      child: Dashboard(
                                    initialIndex: 1,
                                    bookingpage: 1,
                                  )),
                                  (route) => false,
                                );
                              }
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
