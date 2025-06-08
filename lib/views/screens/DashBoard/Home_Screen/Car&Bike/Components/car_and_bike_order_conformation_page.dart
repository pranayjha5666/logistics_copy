import 'package:flutter/material.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/views/base/common_button.dart';
import 'package:logistics/views/screens/DashBoard/dashboard.dart';

import '../../../../../../generated/assets.dart';

class CarAndBikeOrderConformationPage extends StatelessWidget {
  const CarAndBikeOrderConformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.pushAndRemoveUntil(
          context,
          getCustomRoute(child: Dashboard()),
          (route) => false,
        );
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Assets.imagesSucessGif,
                width: 200,
                height: 200,
              ),
              Text(
                "Booking Placed!",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Your booking has been placed. Our team will contact you soon.",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(fontSize: 14.0, color: Colors.black87),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    getCustomRoute(child: Dashboard()),
                    (route) => false,
                  );
                  // Navigator.push(context, getCustomRoute(child: Dashboard()));
                },
                title: "Okay",
              ),
            )
          ],
        ),
      ),
    );
  }
}
