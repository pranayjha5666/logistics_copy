import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/two_wheeler_controller.dart';
import 'package:logistics/views/base/common_button.dart';

import '../../../../../../../services/theme.dart';

class PaymentBottomModelSheet extends StatefulWidget {
  var alllocations;
  PaymentBottomModelSheet({super.key, required this.alllocations});

  @override
  State<PaymentBottomModelSheet> createState() =>
      _PaymentBottomModelSheetState();
}

class _PaymentBottomModelSheetState extends State<PaymentBottomModelSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwoWheelerController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Payment Methods",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  controller.updatepaymentmode(false);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.wallet_outlined,
                        color: primaryColor,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "UPI/QR,Card,Wallet",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.updatepaymentmode(true,
                    address: widget.alllocations[0]["address"].toString(),
                    index: 0,
                  );
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.money,
                        color: primaryColor,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Cash",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
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
