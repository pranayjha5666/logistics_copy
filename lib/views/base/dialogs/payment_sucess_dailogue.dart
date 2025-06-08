import 'package:flutter/material.dart';
import 'package:logistics/views/base/common_button.dart';

class PaymentSucessDailogue extends StatefulWidget {
  const PaymentSucessDailogue({super.key});

  @override
  State<PaymentSucessDailogue> createState() => _PaymentSucessDailogueState();
}

class _PaymentSucessDailogueState extends State<PaymentSucessDailogue> {
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
              Icons.check_circle_outline,
              color: Colors.green,
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              "Payment Successful!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your payment has been processed successfully.",
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
