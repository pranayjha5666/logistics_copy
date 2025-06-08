import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/views/screens/DashBoard/Home_Screen/Two_Wheeler/Review_two_wheeler/Components/payment_bottom_model_sheet.dart';

import '../../../../../../../controllers/location_controller.dart';
import '../../../../../../../controllers/two_wheeler_controller.dart';
import '../../../../../../../services/theme.dart';

class TwoWheelerPaymentMode extends StatefulWidget {
  const TwoWheelerPaymentMode({super.key});

  @override
  State<TwoWheelerPaymentMode> createState() => _TwoWheelerPaymentModeState();
}

class _TwoWheelerPaymentModeState extends State<TwoWheelerPaymentMode> {
  @override
  Widget build(BuildContext context) {
    // bool _initialized = false;

    final allLocations = [
      ...Get.find<LocationController>().pickupLocations.map((e) => {
            "address": e.addressLineOne.text.trim(),
            "isPickUp": true,
          }),
      ...Get.find<LocationController>().dropLocations.map((e) => {
            "address": e.addressLineOne.text.trim(),
            "isPickUp": false,
          }),
    ];

    return GetBuilder<TwoWheelerController>(
      builder: (controller) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Payment Mode",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: primaryColor, fontWeight: FontWeight.w600),
                ),
              ),
              Divider(height: 10, color: Colors.grey.shade200),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => PaymentBottomModelSheet(
                        alllocations: allLocations,
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      // color: primaryColor.withOpacity(0.1),
                      color: const Color(0xffF4F9FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                            controller.paymentmode
                                ? Icons.wallet_outlined
                                : Icons.money,
                            color: primaryColor),
                        const SizedBox(width: 10),
                        Text(
                          controller.paymentmode
                              ? "UPI/QR,Card,Wallet"
                              : "Cash",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const Spacer(),
                        Icon(Icons.keyboard_double_arrow_down,
                            size: 15, color: primaryColor),
                      ],
                    ),
                  ),
                ),
              ),
              if (!controller.paymentmode)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: allLocations.length,
                    itemBuilder: (context, index) {
                      final location = allLocations[index];
                      final address = location["address"].toString();
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          controller.updatepaymentmode(true,
                              address: address, index: index);
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        controller.paymentaddressindex == index
                                            ? primaryColor
                                            : Colors.grey.shade200,
                                    width: 2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                controller.paymentaddressindex == index
                                    ? Icons.circle
                                    : null,
                                size: 10,
                                color: controller.paymentaddressindex == index
                                    ? primaryColor
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                address,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
