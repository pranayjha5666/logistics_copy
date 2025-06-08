import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/auth_controller.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPAutofillController extends GetxController
    with CodeAutoFill
    implements GetxService {
  String currentCode = '';
  final TextEditingController otpController = TextEditingController();
  bool isResendOtpEnabled = false;
  int resendOtpTimer = 30;
  Timer? timer;
  bool isTextVisible = true;

//----------------otp auto fill--------------

  @override
  void codeUpdated() {
    if (code != null) {
      currentCode = code!;
      update();
    }
  }

  updateCurrentCode(String smsCode) {
    currentCode = smsCode;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    listenSmsOTP();
  }

//----listen otp
  listenSmsOTP() async {
    log('Call');
    await SmsAutoFill().listenForCode();
  }

  @override
  void dispose() async {
    super.dispose();
    cancel();
    await SmsAutoFill().unregisterListener();
    timer?.cancel();
  }

//-------------------timer--------------
  void startResendOtpTimer({bool shouldLogin = true}) {
    final auth = Get.find<AuthController>();

    if (shouldLogin) {
      auth.login(phoneNo: auth.numberController.text).then((value) {
        if (value.isSuccess) {
          _startTimerLogic();
        } else {
          Fluttertoast.showToast(msg: value.message);
        }
      });
    } else {
      _startTimerLogic();
    }
  }

  void _startTimerLogic() {
    isResendOtpEnabled = false;
    isTextVisible = true;
    resendOtpTimer = 30;
    update();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendOtpTimer == 0) {
        isResendOtpEnabled = true;
        isTextVisible = false;
        update();
        timer.cancel();
      } else {
        resendOtpTimer--;
        update();
      }
    });
  }

  Future<String> getAppSignature() async {
    return await SmsAutoFill().getAppSignature;
  }
}
