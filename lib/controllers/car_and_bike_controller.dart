import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:logistics/data/models/response/car_and_bike_model.dart';

import '../data/models/response/response_model.dart';
import '../data/repositories/auth_repo.dart';
import '../data/repositories/user_repo.dart';

class CarAndBikeController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  final UserRepo userRepo;

  CarAndBikeController({required this.userRepo, required this.authRepo});
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? moveType = 'within_city';

  void updatemove(String? val) {
    moveType = val;
    update();
  }

  final Map<String, List<String>> vehicleMap = {
    'Car': ['Hatchback', 'Sedan', 'SUV', 'Luxury', 'Convertible', 'Other'],
    'Bike': ['Less than 200cc', '200 - 500cc', 'More than 500cc'],
    'Scooty': [],
  };

  Set<String> selectedParents = {};
  Map<String, String> selectedSubItems = {};

  Future<ResponseModel> storecarandbikebooking(dynamic data) async {
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.storecarandbikebooking(data);
      if (response.statusCode == 200) {
        log(response.bodyString.toString());
        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel =
          ResponseModel(false, "ERROR AT storecarandbikebooking()!");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++',
          name: "ERROR AT storecarandbikebooking()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }



  final ScrollController carandbikescrollController = ScrollController();
  bool _isPaginating = false;
  bool get isPaginating => _isPaginating;

  int page = 1;

  void updatepage() {
    page = 1;
    update();
  }

  void carandbikesscrollListener() {
    if (carandbikescrollController.position.pixels >=
        carandbikescrollController.position.maxScrollExtent * 0.7) {
      if (!_isPaginating) {
        fetchNextcarandbikebookingPage();
      }
    }
  }

  List<CarAndBikeModel> _carAndBikeBookingList = [];
  List<CarAndBikeModel> get carAndBikeBookingList =>
      _carAndBikeBookingList;

  Future<ResponseModel> getcarandbikebooking() async {
    log("getcarandbikebooking called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.getcarandbikebooking();

      if (response.statusCode == 200) {
        log(jsonEncode(response.body),
            name: "Car and bike Booking List");
        _carAndBikeBookingList = carAndBikeModelFromJson(
            jsonEncode(response.body['data']['data']));

        log(_carAndBikeBookingList.toString(), name: "getcarandbikebooking");
        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
        _isLoading = false;
        update();
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "ERROR AT getcarandbikebooking()!");
      log(e.toString(), name: "ERROR AT getcarandbikebooking()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> fetchNextcarandbikebookingPage() async {
    if (_isPaginating) return;
    _isPaginating = true;
    update();

    try {
      page++;
      log(page.toString(), name: "Page No");
      Response response = await userRepo.getcarandbikeBookingByPageUrl(page);
      if (response.statusCode == 200) {
        // List<TwoWheelerBookingListModel> newBookings =
        // twoWheelerBookingListModelFromJson(
        //     jsonEncode(response.body['data']['data']));
        // _twowheelerbookingList.addAll(newBookings);
        // update();
      } else {
        log("Pagination error: ${response.body['message']}");
      }
    } catch (e) {
      log(e.toString(), name: "ERROR AT fetchNextcarandbikebookingPage()");
    }

    _isPaginating = false;
    update();
  }
}
