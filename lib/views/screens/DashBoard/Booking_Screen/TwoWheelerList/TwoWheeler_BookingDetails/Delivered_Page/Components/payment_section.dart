import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../controllers/two_wheeler_booking_controller.dart';

class PaymentSection extends StatefulWidget {
  const PaymentSection({super.key});

  @override
  State<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Colors.grey[600])),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwoWheelerBookingController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Payment Info",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.black, fontWeight: FontWeight.w800),
              ),
            ),
            Divider(
              height: 0,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  infoRow(
                      "Base Fee",
                      controller.twowheelerbookingdetailsModel!.subTotalForUser
                          .toString()),
                  if (controller.twowheelerbookingdetailsModel!
                          .promoCodeDiscountAmount !=
                      0)
                    infoRow(
                        "Promo Code Discount",
                        controller.twowheelerbookingdetailsModel!
                            .promoCodeDiscountAmount
                            .toString()),
                ],
              ),
            ),
            Divider(
              height: 0,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      controller.twowheelerbookingdetailsModel!.paymentMode ==
                              "cod"
                          ? "Total Payable Amount"
                          : "Total Paid Amount",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w600)),
                  Text(
                      controller.twowheelerbookingdetailsModel!
                          .totalPayableAmountForUser
                          .toString(),
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
