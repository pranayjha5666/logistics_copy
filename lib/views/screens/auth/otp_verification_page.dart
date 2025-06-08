import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/screens/DashBoard/dashboard.dart';
import 'package:logistics/views/screens/auth/register_user_page.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/otp_autofill_controller.dart';
import '../../../generated/assets.dart';
import '../../../services/route_helper.dart';
import '../../base/common_button.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Get.find<OTPAutofillController>()
            .startResendOtpTimer(shouldLogin: false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: GetBuilder<OTPAutofillController>(dispose: (state) {
        Get.find<OTPAutofillController>().currentCode = '';
      }, builder: (otpController) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child:
                        SvgPicture.asset(Assets.imagesOtpverficationlockicon)),
                SizedBox(height: 25),
                Text(
                  "Verify Your Code",
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 15),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'We have sent the verification to ',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontSize: 14),
                    children: [
                      TextSpan(
                        text: Get.find<AuthController>().numberController.text,
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Change Phone Number?",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 13, color: Color(0xff009F0B)),
                  ),
                ),
                SizedBox(height: 20),
                PinFieldAutoFill(
                  currentCode: otpController.currentCode,
                  decoration: BoxLooseDecoration(
                    strokeColorBuilder: const FixedColorBuilder(Colors.grey),
                  ),
                  onCodeChanged: (code) async {
                    if (code == null) return;
                    otpController.updateCurrentCode(code);
                    if (otpController.currentCode.length == 6) {
                      FocusScope.of(context).unfocus();
                      verifyOtp(
                          context, otpController, Get.find<AuthController>());
                    }
                  },
                  codeLength: 6,
                ),
                SizedBox(height: 20),
                if (otpController.isTextVisible)
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          'Please wait for ${otpController.resendOtpTimer} seconds to resend the OTP',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: 14),
                      children: [
                        TextSpan(
                          text: '\nResend OTP',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: otpController.isResendOtpEnabled
                                    ? primaryColor
                                    : Colors.grey,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = otpController.isResendOtpEnabled
                                ? otpController.startResendOtpTimer
                                : null,
                        ),
                      ],
                    ),
                  ),
                if (!otpController.isTextVisible)
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '\nResend OTP',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: otpController.isResendOtpEnabled
                                ? primaryColor
                                : Colors.grey,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = otpController.startResendOtpTimer,
                    ),
                  ),
                SizedBox(height: 20),
                GetBuilder<AuthController>(
                  builder: (auth) {
                    return CustomButton(
                      isLoading: auth.isLoading,
                      onTap: () {
                        if (auth.otpController.text.length == 6) {
                          dynamic data = {
                            'phone': auth.numberController.text,
                            'otp': otpController.currentCode,
                          };

                          auth.verifyOTP(data).then((value) async {
                            if (value.isSuccess) {
                              log('${auth.userStatus}');
                              if (auth.userStatus == 'old') {
                                await Get.find<AuthController>()
                                    .getUserProfileData()
                                    .then((value) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    getCustomRoute(child: Dashboard()),
                                    (route) => false,
                                  );
                                });
                              } else {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  getCustomRoute(child: RegisterUserPage()),
                                  (route) => false,
                                );
                              }
                            } else {
                              Fluttertoast.showToast(msg: value.message);
                            }
                          });
                        }
                      },
                      title: "Verify Otp",
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void verifyOtp(BuildContext context, OTPAutofillController otpController,
      AuthController authController) {
    Map<String, dynamic> data = {
      "phone": authController.numberController.text.trim(),
      "otp": otpController.currentCode,
    };
    log("$data");
    if (otpController.currentCode.isNotEmpty) {
      authController.verifyOTP(data).then((value) async {
        if (value.isSuccess) {
          log(value.message);
          if (value.message == 'new') {
            Navigator.pushAndRemoveUntil(
              context,
              getCustomRoute(child: const RegisterUserPage()),
              (route) => false,
            );
          } else if (value.message == 'old') {
            await Get.find<AuthController>().getUserProfileData().then((value) {
              Navigator.pushAndRemoveUntil(
                context,
                getCustomRoute(child: Dashboard()),
                (route) => false,
              );
            });
          }
        } else {
          Fluttertoast.showToast(msg: value.message);
        }
      });
    } else {
      Fluttertoast.showToast(msg: 'Please Enter OTP!');
    }
  }
}
