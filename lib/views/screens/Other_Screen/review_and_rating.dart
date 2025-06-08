import 'package:flutter/material.dart';
import 'package:logistics/views/base/common_button.dart';

import '../../../services/input_decoration.dart';

class ReviewAndRating extends StatefulWidget {
  const ReviewAndRating({super.key});

  @override
  State<ReviewAndRating> createState() => _ReviewAndRatingState();
}

class _ReviewAndRatingState extends State<ReviewAndRating> {
  int _selectedRating = 4; // Default rating set to 4

  String getRatingText(int rating) {
    switch (rating) {
      case 1:
        return "Bad";
      case 2:
        return "Okay";
      case 3:
        return "Medium";
      case 4:
        return "Good";
      case 5:
        return "Very Good";
      default:
        return "Tap a star to rate";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Review & Rating",
          style: Theme.of(context)
              .textTheme
              .displayMedium
              ?.copyWith(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Rate Your Experience",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Share your thoughts and help others make informed decisions",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 20),
                // Star Rating Widget
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        Icons.star,
                        color: index < _selectedRating
                            ? const Color(0xff09596F)
                            : const Color(0xffD9D9D9),
                        size: 40,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedRating = index + 1;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 10),
                Text(
                  getRatingText(_selectedRating),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            // Pushes the following elements to the bottom
          ],
        ),
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  decoration: CustomDecoration.inputDecoration(
                    label: 'Type your review',
                    borderRadius: 5,
                    suffix: const Icon(
                      Icons.sentiment_very_satisfied,
                      color: Color(0xff09596F),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  onTap: () {},
                  color: const Color(0xff09596F),
                  child: const Text("SUBMIT",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
