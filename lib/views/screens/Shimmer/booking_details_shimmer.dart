import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookingDetailsShimmer extends StatelessWidget {
  const BookingDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child:  Container(
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),),
          Divider(color: Colors.grey[300]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Container(height: 20, width: 140, color: Colors.white),
                        const Spacer(),
                        Container(height: 20, width: 100, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 20),
      
                    // Location Timeline box
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 20),
      
                    // Est. Delivery Date Section
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Container(height: 16, width: 120, color: Colors.white),
                          const Spacer(),
                          Container(height: 16, width: 80, color: Colors.white),
                          const SizedBox(width: 12),
                          Container(height: 20, width: 70, color: Colors.white),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
      
                    // Trip Start OTP
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Container(height: 20, width: 140, color: Colors.white),
                          const Spacer(),
                          Container(height: 20, width: 60, color: Colors.white),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
      
                    // Delivery Charges
                    Container(height: 300, color: Colors.white),
      
                  ],
                ),
              ),
            ),
          ),

        ],
      
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(child: shimmerBox(height: 50, width: double.infinity)),
            const SizedBox(width: 10),
            Expanded(child: shimmerBox(height: 50, width: double.infinity)),
          ],
        ),
      ),

    );

  }


  Widget shimmerBox({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
