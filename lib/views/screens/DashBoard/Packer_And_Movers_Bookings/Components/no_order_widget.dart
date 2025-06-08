import 'package:flutter/material.dart';
import 'package:logistics/views/base/common_button.dart';
import 'package:lottie/lottie.dart';

import '../../../../../generated/assets.dart';

class NoOrderWidget extends StatefulWidget {
  const NoOrderWidget({super.key});

  @override
  State<NoOrderWidget> createState() => _NoOrderWidgetState();
}

class _NoOrderWidgetState extends State<NoOrderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            height: 250,
            Assets.lottieNoDataFound,
            reverse: false,
            repeat: true,
          ),
          Text(
            "No Bookings Yet",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.black),
          ),
          // SizedBox(
          //   height: 30,
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          //   child: CustomButton(
          //     onTap: widget.onTap,
          //     title: "Book Now",
          //   ),
          // )
        ],
      ),
    );
  }
}
