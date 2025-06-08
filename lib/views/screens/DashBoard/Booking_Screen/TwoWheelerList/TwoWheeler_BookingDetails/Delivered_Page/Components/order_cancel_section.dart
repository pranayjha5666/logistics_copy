import 'package:flutter/material.dart';

class OrderCancelSection extends StatefulWidget {
  const OrderCancelSection({super.key});

  @override
  State<OrderCancelSection> createState() => _OrderCancelSectionState();
}

class _OrderCancelSectionState extends State<OrderCancelSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.cancel,
            color: Colors.red,
            size: 100,
          ),
          Text(
            "This booking has been cancelled. If you have any questions, please contact support.",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: 16
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
