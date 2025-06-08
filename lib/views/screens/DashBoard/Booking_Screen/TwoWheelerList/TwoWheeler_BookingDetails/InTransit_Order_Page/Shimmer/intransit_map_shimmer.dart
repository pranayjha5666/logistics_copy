import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class IntransitMapShimmer extends StatelessWidget {
  const IntransitMapShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.3,
              top: MediaQuery.of(context).size.height * 0.4,
              child: _buildShimmerMarker(),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width * 0.2,
              top: MediaQuery.of(context).size.height * 0.5,
              child: _buildShimmerMarker(),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.5,
              bottom: MediaQuery.of(context).size.height * 0.2,
              child: _buildShimmerMarker(size: 25),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerMarker({double size = 30}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
