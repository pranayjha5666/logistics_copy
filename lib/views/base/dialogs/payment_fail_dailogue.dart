import 'package:flutter/material.dart';

import '../common_button.dart';

class PaymentFailDailogue extends StatefulWidget {
  const PaymentFailDailogue({super.key});

  @override
  State<PaymentFailDailogue> createState() => _PaymentFailDailogueState();
}

class _PaymentFailDailogueState extends State<PaymentFailDailogue> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              "Payment Failed!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your payment is Failed.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomButton(
              onTap: () {
                Navigator.pop(context);
              },
              title: "Done",
            ),
          ],
        ),
      ),
    );
  }
}
