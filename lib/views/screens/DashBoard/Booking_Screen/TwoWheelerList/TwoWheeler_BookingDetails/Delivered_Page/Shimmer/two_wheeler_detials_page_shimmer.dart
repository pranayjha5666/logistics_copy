import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTwoWheelerDeliveredPage extends StatelessWidget {
  const ShimmerTwoWheelerDeliveredPage({super.key});

  Widget _shimmerBox(
      {double height = 16,
      double width = double.infinity,
      BorderRadius? radius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius ?? BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _shimmerCircle({double size = 75}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _horizontalDivider() =>
      Container(height: 10, color: const Color(0xffF1F1F1));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _shimmerBox(width: 100, height: 14),
                _shimmerBox(width: 60, height: 24),
                _shimmerBox(width: 90, height: 24),
              ],
            ),
          ),
          _horizontalDivider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    _shimmerBox(width: 120, height: 14),
                    Spacer(),
                    _shimmerBox(width: 60, height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _shimmerCircle(),
                    const SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(width: 100, height: 14),
                        const SizedBox(height: 10),
                        _shimmerBox(width: 100, height: 14),
                        const SizedBox(height: 10),
                        _shimmerBox(width: 100, height: 14),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        _shimmerBox(
                            width: 50,
                            height: 50,
                            radius: BorderRadius.circular(8)),
                        const SizedBox(height: 5),
                        _shimmerBox(width: 70, height: 10),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          _horizontalDivider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          _horizontalDivider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 120, height: 16),
                const SizedBox(height: 10),
                ...List.generate(
                  2,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(width: 60, height: 14),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _shimmerBox(height: 14),
                              const SizedBox(height: 6),
                              _shimmerBox(height: 14, width: 100),
                              const SizedBox(height: 6),
                              _shimmerBox(height: 14, width: 80),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _horizontalDivider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 120, height: 16),
                const SizedBox(height: 10),
                _shimmerBox(height: 14),
                const SizedBox(height: 10),
                _shimmerBox(height: 14),
                const SizedBox(height: 10),
                _shimmerBox(height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
