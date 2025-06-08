import 'package:flutter/material.dart';

class Nodriverdialogue extends StatelessWidget {
  const Nodriverdialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Block default back navigation
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pop();
          Navigator.of(context).maybePop();
        }
      },
      child: AlertDialog(
        title: const Text("No Driver Found"),
        content: Text(
          "No driver accepted the booking. Please try again later.",
          style: Theme.of(context).textTheme.labelSmall,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).maybePop();
            },
            child: const Text("Okay"),
          ),
        ],
      ),
    );
  }
}
