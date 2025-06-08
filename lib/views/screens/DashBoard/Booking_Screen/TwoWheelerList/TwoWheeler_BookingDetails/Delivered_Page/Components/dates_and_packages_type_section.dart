import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:logistics/services/extensions.dart';
import '../../../../../../../../controllers/two_wheeler_booking_controller.dart';
import '../../../../../../../../services/theme.dart';

class DatesAndPackagesTypeSection extends StatelessWidget {
  bool? isbooked;
  DatesAndPackagesTypeSection({super.key, this.isbooked});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwoWheelerBookingController>(
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical:isbooked !=null ?10:6, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                controller.twowheelerbookingdetailsModel!.createdAt!.dMy,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              if(isbooked!=null)
                Container(
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Row(
                  children: [
                    Text(
                      "OTP  ",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      controller.twowheelerbookingdetailsModel!.startOtp!.toString(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                child: Text(
                  controller.twowheelerbookingdetailsModel!
                      .twoWheelerPackageType!.title
                      .toString(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
