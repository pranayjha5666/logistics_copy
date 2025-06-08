import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../base/common_button.dart';

class ChangeLocationDailogue extends StatelessWidget {
  final bool? isrecent;
  final bool? ispickup;
  const ChangeLocationDailogue({super.key, this.isrecent, this.ispickup});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Are you sure?",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            "You have already entered an address. Do you want to change it to the selected ${isrecent != null ? "recent" : "saved"} address?",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: CustomButton(
                  type: ButtonType.secondary,
                  title: 'No',
                  height: 20,
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CustomButton(
                  title: 'Yes',
                  height: 20,
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
