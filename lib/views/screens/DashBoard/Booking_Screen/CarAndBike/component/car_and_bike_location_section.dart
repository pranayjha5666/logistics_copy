import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:logistics/data/models/response/car_and_bike_model.dart';

class CarAndBikeLocationSection extends StatelessWidget {
  final CarAndBikeModel booking;

  const CarAndBikeLocationSection({super.key, required this.booking});

  Widget _buildLocationRow(
    BuildContext context, {
    required String address,
    required String pincode,
    required bool isPickup,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: isPickup ? 10 : 5, left: isLast ? 10 : 0),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPickup
                      ? const Color(0xFF00C060)
                      : const Color(0xFFEB0404),
                ),
                child: const Icon(Icons.circle, color: Colors.white, size: 10),
              ),
            ),
            if (!isLast)
              SizedBox(
                width: 40,
                height: 20,
                child: DottedBorder(
                  strokeWidth: 2,
                  dashPattern: const [2, 2],
                  color: Colors.grey,
                  customPath: (size) {
                    return Path()
                      ..moveTo(size.width / 2, 4)
                      ..lineTo(size.width / 2, 40);
                  },
                  child: const SizedBox(),
                ),
              ),
          ],
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Container(
            padding:
                EdgeInsets.only(top: isPickup ? 12 : 8, left: isLast ? 10 : 0),
            child: Text(
              "$address, $pincode",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 12,
                    color: const Color(0xFF353535),
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 0.0, right: 4.0, bottom: 16.0),
      child: Column(
        children: [
          _buildLocationRow(
            context,
            address: booking.pickupAddressLineOne ?? "Na",
            pincode: booking.pickupPincode ?? "Na",
            isPickup: true,
            isLast: false,
          ),
          _buildLocationRow(
            context,
            address: booking.dropAddressLineOne ?? "Na",
            pincode: booking.dropPincode ?? "Na",
            isPickup: false,
            isLast: true,
          ),
        ],
      ),
    );
  }
}
