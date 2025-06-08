import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookingShimmer extends StatelessWidget {
  const BookingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) {
        return buildShimmerContainer();
      },
    );
  }
}

Widget buildShimmerContainer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 16,
                  width: 100,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 16,
                width: 100,
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade200),

          const SizedBox(height: 12),
          buildShimmerLocationItem(),
          const SizedBox(height: 12),
          buildShimmerLocationItem(),
          const SizedBox(height: 12),

          Divider(color: Colors.grey.shade200),

          // Delivery date and status
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 16,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 7,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Container(
                    height: 16,
                    width: 60,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget buildShimmerLocationItem() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(right: 12),
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 14, width: 60, color: Colors.white),
            const SizedBox(height: 6),
            Container(height: 14, width: 100, color: Colors.white),
            const SizedBox(height: 6),
            Container(height: 14, width: double.infinity, color: Colors.white),
            const SizedBox(height: 6),
            Container(height: 14, width: double.infinity, color: Colors.white),
          ],
        ),
      ),
    ],
  );
}
