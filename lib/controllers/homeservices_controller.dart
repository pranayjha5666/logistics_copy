import 'dart:developer';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../data/models/response/response_model.dart';
import '../data/models/response/slider_model.dart';
import '../data/repositories/auth_repo.dart';
import '../data/repositories/user_repo.dart';

class HomeServiceController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  final UserRepo userRepo;

  HomeServiceController({required this.userRepo, required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<SliderModel> sliders = [];

  Future<ResponseModel> getSliders() async {
    log('--------- getSliders() Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();
    try {
      Response response = await userRepo.getSliders();
      if (response.statusCode == 200 &&
          response.body['success'] == true &&
          response.body['data'] is List) {
        sliders = (response.body['data'] as List<dynamic>)
            .map((slider) => SliderModel.fromJson(slider))
            .toList();

        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "CATCH");
      log('++++++++++++++++ ${e.toString()} +++++++++++++',
          name: "ERROR AT getSliders()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}
