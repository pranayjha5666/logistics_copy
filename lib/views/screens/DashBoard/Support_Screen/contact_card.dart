import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/main.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key});

  Widget _rowContent(IconData icon, String text, String subtext) {
    return Row(
      children: [
        Icon(icon,size: 26,),
        SizedBox(
          width: 15,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: Theme.of(navigatorKey.currentState!.context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(
                      color: Colors.grey, fontFamily: "Poppins", fontSize: 15),
            ),
            Text(
              subtext,
              style: Theme.of(navigatorKey.currentState!.context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(
                      fontWeight: FontWeight.w500, fontFamily: "Poppins",fontSize: 17),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        children: [
          _rowContent(Icons.email_outlined, "Email", "abc@gmail.com"),
          SizedBox(
            height: 10,
          ),
          _rowContent(Icons.phone_outlined, "Phone", "1234567890"),
        ],
      ),
    );
  }
}
