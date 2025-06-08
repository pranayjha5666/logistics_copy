
import 'dart:async';

import 'package:get/get_state_manager/get_state_manager.dart';

class TimerController extends GetxController implements GetxService{
  final int totalSeconds = 900;
  Timer? _countdownTimer;

  int remainingTime = 0;
  double progress = 1.0;

  void startCountdown(DateTime createdAt) {
    _countdownTimer?.cancel();

    int secondPassed = DateTime.now().difference(createdAt).inSeconds;
    int timeLeft = totalSeconds - secondPassed;

    remainingTime = timeLeft < 0 ? 0 : timeLeft;
    progress = remainingTime / totalSeconds;
    // update();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
        progress = remainingTime / totalSeconds;
        update();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }
}