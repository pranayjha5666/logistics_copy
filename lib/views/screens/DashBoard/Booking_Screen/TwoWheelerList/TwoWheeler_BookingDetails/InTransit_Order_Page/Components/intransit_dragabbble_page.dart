import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../controllers/two_wheeler_booking_controller.dart';
import '../../Delivered_Page/Components/address_section.dart';
import '../../Delivered_Page/Components/driver_detais_section.dart';
import '../../Delivered_Page/Components/payment_section.dart';

class IntransitDragabbblePage extends StatelessWidget {
  final int id;

  const IntransitDragabbblePage({super.key, required this.id});

  Widget _content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 10, color: const Color(0xffF1F1F1)),
        DriverDetaisSection(
          isbooked: false,
        ),
        Container(height: 10, color: const Color(0xffF1F1F1)),
        AddressSection(),
        Container(height: 10, color: const Color(0xffF1F1F1)),
        PaymentSection(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _content(context);
  }
}
