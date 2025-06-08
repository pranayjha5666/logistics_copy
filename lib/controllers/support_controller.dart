import 'dart:convert';
import 'dart:developer';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../data/api/api_checker.dart';
import '../data/models/response/faqs_model.dart';
import '../data/models/response/response_model.dart';
import '../data/repositories/user_repo.dart';

class SupportController extends GetxController implements GetxService {
  final UserRepo userRepo;
  SupportController({
    required this.userRepo,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<FaqsModel> _faqslist = [];
  List<FaqsModel> get faqlist => _faqslist;

  Future<ResponseModel> getFaqs() async {
    log("getFaqs called");

    ResponseModel responseModel;
    _isLoading = true;
    try {
      Response response = await userRepo.getFaqs();

      if (response.statusCode == 200) {
        log(response.bodyString.toString(), name: "getFaqs");
        _faqslist = faqsModelFromJson(jsonEncode(response.body['data']));

        log(_faqslist.toString(), name: "FaqsModel Data");

        update();
        responseModel = ResponseModel(true, 'success');
      } else {
        ApiChecker.checkApi(response);
        responseModel = ResponseModel(false, "${response.statusText}");
      }
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT getFaqs()");
      responseModel = ResponseModel(false, "$e");
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}
