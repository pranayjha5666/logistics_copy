import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logistics/services/theme.dart';

import '../../../../../main.dart';

class Enablelocationdailogue extends StatelessWidget {
  const Enablelocationdailogue({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Location Required",
        style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 20),
      ),
      content: Text(
        "Please turn on location services and grant permission.",
        style: Theme.of(context).textTheme.labelSmall,
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(navigatorKey.currentState!.context);
            await Geolocator.openLocationSettings();
          },
          child: Text(
            "Open Location",
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: primaryColor, fontWeight: FontWeight.w600),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(navigatorKey.currentState!.context);
          },
          child: Text(
            "Cancel",
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: primaryColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
