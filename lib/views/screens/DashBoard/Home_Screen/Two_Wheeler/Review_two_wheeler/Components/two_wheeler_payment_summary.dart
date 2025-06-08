import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/two_wheeler_controller.dart';
import 'package:logistics/services/theme.dart';

class TwoWheelerPaymentSummary extends StatefulWidget {
  const TwoWheelerPaymentSummary({super.key});

  @override
  State<TwoWheelerPaymentSummary> createState() =>
      _TwoWheelerPaymentSummaryState();
}

class _TwoWheelerPaymentSummaryState extends State<TwoWheelerPaymentSummary> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwoWheelerController>(
      builder: (controller) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Payment Summary",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: primaryColor, fontWeight: FontWeight.w600),
                ),
              ),
              Divider(
                height: 10,
                color: Colors.grey.shade200,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Quoted amount",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Text(controller.deliveryamount.toString(),
                            style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                    if (controller.promocodeval != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Promo Code Discount",
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 2.0),
                              //   child: Text(
                              //       "(${controller.promocodedata!.title})",
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .labelSmall
                              //           ?.copyWith(
                              //               color: Colors.green, fontSize: 8)),
                              // ),
                            ],
                          ),
                          Text(controller.promocodeval.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: Colors.green)),
                        ],
                      ),
                    Divider(
                      height: 10,
                      color: Colors.grey[200],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Payable Amount",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                        Text(controller.totalamount.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
