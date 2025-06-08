import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final int starCount;
  final double rating;
  final Color? color;

  const StarRatingWidget({
    super.key,
    this.starCount = 5, // Default to 5 stars
    this.rating = 0.0, // Default rating is 0
    this.color, // Optional: custom color for stars
  });

  // Method to build each individual star based on the rating and index
  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = const Icon(
        Icons.star_border, // Empty star
        size: 16,
        color: Colors.grey, // Light gray for empty stars
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half, // Half star
        size: 16,
        color: color ?? Colors.amber, // Default to gold color or custom color
      );
    } else {
      icon = Icon(
        Icons.star, // Full star
        size: 16,
        color: color ?? Colors.amber, // Default to gold color or custom color
      );
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Ensures it doesn't take full width
      children: List.generate(
        starCount, // Generate a row with 'starCount' stars
        (index) => buildStar(context, index),
      ),
    );
  }
}
