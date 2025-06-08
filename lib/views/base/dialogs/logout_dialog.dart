import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logistics/controllers/auth_controller.dart';

import '../../screens/splash_screen/splash_screen.dart';
import '../common_button.dart';
import '../custom_image.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).primaryColor)),
            child: Center(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Colors.red.withOpacity(0.8), BlendMode.srcATop),
                child: const CustomImage(
                  path: Assets.imagesExclaim,
                  color: Colors.white,
                  height: 30,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Are you sure you want to logout!",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  type: ButtonType.secondary,
                  title: 'Cancel',
                  height: 20,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                GetBuilder<AuthController>(
                  builder: (auth) {
                    return CustomButton(
                      type: ButtonType.primary,
                      title: 'Logout',
                      height: 20,
                      onTap: () async {
                        await auth.logOutUser().then((value) {
                          if (value.isSuccess) {
                            auth.clearTextField();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SplashScreen()),
                                (route) => false);
                          } else {
                            auth.clearTextField();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SplashScreen()),
                                (route) => false);
                          }
                        });
                      },
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
