import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logistics/controllers/booking_controller.dart';
import 'package:logistics/data/models/response/bookingdetails_model.dart';
import 'package:logistics/services/extensions.dart';

class PaymentInfoSection extends StatelessWidget {
  PaymentInfoSection({super.key});

  Widget _paymentHistory(
      BuildContext context, BookingdetailsModel bookingdetailsModel) {
    final payouts = bookingdetailsModel.payoutBookingGoodUsers ?? [];
    return payouts.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                color: Colors.grey[200],
                thickness: 1,
                height: 5,
              ),
              const SizedBox(height: 10),
              Text(
                "Payment History",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
              ),
              const SizedBox(height: 10),
              ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                shrinkWrap: true,
                itemCount: payouts.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final payout = payouts[index];
                  String date = payout.createdAt != null
                      ? payout.createdAt!.dateTime
                      : DateTime.now().dMy;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: const Color(0xff868686),
                              fontSize: 9,
                            ),
                      ),
                      Text(
                        "₹ ${payout.amount ?? 0}",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: const Color(0xff868686),
                            ),
                      )
                    ],
                  );
                },
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(
      builder: (controller) {
        final bookingdetailsModel = controller.bookingdetailsModel;

        if (bookingdetailsModel == null) {
          return const SizedBox.shrink();
        }

        final amountForUser = bookingdetailsModel.amountForUser ?? 0;
        final remainingAmount = controller.remainingamount ?? 0;
        final payouts = bookingdetailsModel.payoutBookingGoodUsers ?? [];

        return Container(
          padding: const EdgeInsets.all(15),
          // decoration: BoxDecoration(
          //   border: Border.all(color: Colors.grey.shade300),
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(2),
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Payment Info",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 10),
              Divider(
                color: Colors.grey[200],
                height: 5,
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Amount",
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  )),
                      Text(
                        "₹ $amountForUser",
                        style: Theme.of(context).textTheme.labelMedium,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (payouts.isNotEmpty)
                    _paymentHistory(context, bookingdetailsModel),
                  Divider(
                    color: Colors.grey[200],
                    height: 5,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Remaining Payable Amount",
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  )),
                      Text(
                        "₹ $remainingAmount",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
