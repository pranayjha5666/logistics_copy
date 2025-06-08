import 'package:logistics/data/models/response/car_and_bike_model.dart';
import 'package:logistics/services/extensions.dart';
import 'package:logistics/services/theme.dart';
import 'package:flutter/material.dart';
import 'package:logistics/views/screens/DashBoard/Booking_Screen/CarAndBike/component/car_and_bike_location_section.dart';

class CarAndBikeBookingCard extends StatelessWidget {
  final CarAndBikeModel booking;
  const CarAndBikeBookingCard({super.key, required this.booking});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffD9D9D9)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "ID: ${booking.id != null ? booking.id!.toString().toUpperCase() : "NA"}",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 8),
          Divider(
            color: Colors.grey[200],
            height: 1,
          ),

          CarAndBikeLocationSection(booking: booking),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xffF6F6F6),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${booking.estimatedMovingDate!.dateTime}",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff646363)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
