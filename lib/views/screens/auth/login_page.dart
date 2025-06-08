import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/base/common_button.dart';
import 'package:logistics/views/screens/auth/otp_verification_page.dart';
import '../../../controllers/auth_controller.dart';
import '../../../services/input_decoration.dart';
import '../../../services/route_helper.dart';
import '../business_setting/html_widget_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What’s your \n phone number?",
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 25),
              Form(
                key: _formKey, // Step 2: Assign formKey
                child: TextFormField(
                  controller: Get.find<AuthController>().numberController,
                  keyboardType: Platform.isIOS
                      ? const TextInputType.numberWithOptions(
                      signed: true, decimal: true)
                      : TextInputType.number,
                  decoration: CustomDecoration.inputDecoration(
                    floating: true,
                    label: 'Mobile Number',
                    icon: Icon(
                      Icons.phone_in_talk_outlined,
                      size: 19,
                      color: Color(0xFF130F26),
                    ),
                    hint: 'Enter your mobile number',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length != 10) {
                      return 'Please enter a valid 10-digit number';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 25),
              // (unchanged) Terms and Conditions Text
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:
                  'By tapping next you\'re creating an account and you agree to the ',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontWeight: FontWeight.normal),
                  children: [
                    TextSpan(
                      text: 'Terms & conditons',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        Navigator.push(
                            context,
                            getCustomRoute(
                                child: HtmlWidgetPage(
                                  title: 'Terms And Conditions',
                                  htmlContent: Get.find<AuthController>()
                                      .businessSettings
                                      .firstWhereOrNull((element) =>
                                  element.key == "terms_and_condition")
                                      ?.value ??
                                      "",
                                )));

                      },
                    ),
                    TextSpan(
                      text: ' and acknowledge ',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: 'Privacy policy',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        Navigator.push(
                            context,
                            getCustomRoute(
                                child: HtmlWidgetPage(
                                  title: 'Privacy Policy',
                                  htmlContent: Get.find<AuthController>()
                                      .businessSettings
                                      .firstWhereOrNull((element) =>
                                  element.key == "privacy_policy")
                                      ?.value ??
                                      "",
                                )));

                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              GetBuilder<AuthController>(
                builder: (auth) {
                  return CustomButton(
                    isLoading: auth.isLoading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        auth
                            .login(phoneNo: auth.numberController.text,)
                            .then((value) {
                          if (value.isSuccess) {
                            Navigator.push(
                              context,
                              getCustomRoute(child: OtpVerificationPage()),
                            );
                          } else {
                            Fluttertoast.showToast(msg: value.message);
                          }
                        });
                      }
                    },
                    title: "Next",
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
