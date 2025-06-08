import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/auth_controller.dart';
import 'package:logistics/services/constants.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/views/screens/MyProfile/Components/fileview_page.dart';

class AdditionalInfoSection extends StatefulWidget {
  const AdditionalInfoSection({super.key});

  @override
  State<AdditionalInfoSection> createState() => _AdditionalInfoSectionState();
}

class _AdditionalInfoSectionState extends State<AdditionalInfoSection> {
  Widget _rowContent(IconData icon, String text, String subtext,
      {bool? canview, VoidCallback? onTap}) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 15),
        Expanded(
          child: Column(
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
                maxLines: null,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w500, fontFamily: "Poppins"),
              ),
            ],
          ),
        ),
        if (canview != null) ...[
          SizedBox(width: 15),
          GestureDetector(
            onTap: onTap,
            child: Icon(Icons.visibility, size: 20),
          )
        ]
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
              "Additional Informations",
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
                  if (userdetails.companyName != null) ...[
                    _rowContent(Icons.business_outlined, "Company name",
                        userdetails.companyName!),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                  if (userdetails.gstNumber != null) ...[
                    _rowContent(Icons.receipt_long_outlined, "GST Number",
                        userdetails.gstNumber!),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                  if (userdetails.gstCertificate != null) ...[
                    _rowContent(
                      Icons.receipt_long,
                      "GST CERTIFICATE",
                      userdetails.gstCertificate!,
                      canview: true,
                      onTap: () {
                        Navigator.push(
                            context,
                            getCustomRoute(
                                child: FileViewerScreen(
                                    fileUrl: AppConstants.baseUrl +
                                        userdetails.gstCertificate!)));
                        log("GST Certificate Tap${AppConstants.baseUrl + userdetails.gstCertificate!}",
                            name: "GST certificate");
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                  if (userdetails.msmeCertificate != null) ...[
                    _rowContent(
                      Icons.receipt_long,
                      "MSME CERTIFICATE",
                      userdetails.msmeCertificate!,
                      canview: true,
                      onTap: () {
                        Navigator.push(
                            context,
                            getCustomRoute(
                                child: FileViewerScreen(
                                    fileUrl: AppConstants.baseUrl +
                                        userdetails.msmeCertificate!)));
                        log("Msme Certificate Tap${AppConstants.baseUrl + userdetails.msmeCertificate!}",
                            name: "Msme certificate");
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
