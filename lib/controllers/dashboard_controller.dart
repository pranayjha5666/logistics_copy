import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DashboardController extends GetxController implements GetxService {
  int selectedidx = 0;

  void updateidx(int idx) {
    selectedidx = idx;
    update();
  }
}
