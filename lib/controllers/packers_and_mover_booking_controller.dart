import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../data/models/response/packer_and_mover_booking_model.dart';
import '../data/models/response/response_model.dart';
import '../data/repositories/auth_repo.dart';
import '../data/repositories/user_repo.dart';

class PackersAndMoverBookingController extends GetxController
    implements GetxService {
  final AuthRepo authRepo;
  final UserRepo userRepo;

  PackersAndMoverBookingController(
      {required this.authRepo, required this.userRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final ScrollController scrollController = ScrollController();

  List<PackerAndMoverBookingModel> _packerandmoverbookingList = [];
  List<PackerAndMoverBookingModel> get packerandmoverbookingList =>
      _packerandmoverbookingList;

  void updatepackerandmoverbookingList() {
    _packerandmoverbookingList = [];
    update();
  }

  bool _isPaginating = false;
  bool get isPaginating => _isPaginating;

  int page = 1;

  void updatepage() {
    page = 1;
    update();
  }

  void scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.7) {
      if (!_isPaginating) {
        fetchNextPackerandmoverBookings();
      }
    }
  }

  Future<ResponseModel> getpackersandmoversBookings() async {
    log("getpackersandmoversBookings called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    _packerandmoverbookingList = [];

    try {
      Response response = await userRepo.getlistpackerandmoversbookings();
      if (response.statusCode == 200) {
        _packerandmoverbookingList = packerAndMoverBookingModelFromJson(
            jsonEncode(response.body['data']['data']));

        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
        _isLoading = false;
        update();
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel =
          ResponseModel(false, "ERROR AT getpackersandmoversBookings()!");
      log(e.toString(), name: "ERROR AT getpackersandmoversBookings()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> fetchNextPackerandmoverBookings() async {
    if (_isPaginating) return;
    _isPaginating = true;
    update();

    try {
      page++;
      log(page.toString(), name: "Page No");
      Response response =
          await userRepo.getPackersandMoversBookingsByPageUrl(page);
      if (response.statusCode == 200) {
        List<PackerAndMoverBookingModel> newBookings =
            packerAndMoverBookingModelFromJson(
                jsonEncode(response.body['data']['data']));
        _packerandmoverbookingList.addAll(newBookings);
        update();
      } else {
        log("Pagination error: ${response.body['message']}");
      }
    } catch (e) {
      log(e.toString(), name: "ERROR AT fetchNextBookingsPage()");
    }

    _isPaginating = false;
    update();
  }



  // Packer And Mover Place Page Controller
  bool _ismapcreated = false;
  bool get ismapcreated => _ismapcreated;
  void updateismapcreated() {
    _ismapcreated = true;
    update();
  }

  double _progress = 0.0;
  double get progress => _progress;
  bool _isDelayed = false;
  bool get isDelayed => _isDelayed;

  Timer? _timer;

  void startProgressTracking(DateTime startTime) {
    _isLoading = true;
    update();

    _timer?.cancel();

    void updateProgress() {
      final now = DateTime.now().toUtc();
      final difference = now.difference(startTime);
      final totalSeconds = 15 * 60;
      final passedSeconds = difference.inSeconds;

      _progress = (passedSeconds / totalSeconds).clamp(0.0, 1.0);
      _isDelayed = passedSeconds >= totalSeconds;

      update();

      if (_isDelayed) {
        _timer?.cancel();
      }
    }

    updateProgress();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      updateProgress();
    });

    _isLoading = false;
    update();
  }

}
