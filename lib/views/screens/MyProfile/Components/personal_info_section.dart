import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/auth_controller.dart';

class PersonalInfoSection extends StatefulWidget {
  const PersonalInfoSection({super.key});

  @override
  State<PersonalInfoSection> createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<PersonalInfoSection> {
  Widget _rowContent(IconData icon, String text, String subtext) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(
          width: 15,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey, fontFamily: "Poppins", fontSize: 10),
            ),
            Text(
              subtext,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w500, fontFamily: "Poppins"),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        final userdetails = controller.userModel!;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Personal Information",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                  ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade300)),
              child: Column(
                children: [
                  _rowContent(
                      Icons.person_outline, "Your name", userdetails.name!),
                  if (userdetails.email != null) ...[
                    SizedBox(
                      height: 10,
                    ),
                    _rowContent(
                        Icons.email_outlined, "Email ID", userdetails.email!),
                  ],
                  SizedBox(
                    height: 10,
                  ),
                  _rowContent(
                      Icons.phone_outlined, "Phone Number", userdetails.phone!),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
