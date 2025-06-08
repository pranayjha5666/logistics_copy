import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:logistics/data/models/response/bookingdetails_model.dart';
import 'package:logistics/main.dart';
import 'package:logistics/services/extensions.dart';

import '../data/models/response/booking_model.dart';
import '../data/models/response/response_model.dart';
import '../data/repositories/auth_repo.dart';
import '../data/repositories/user_repo.dart';
import '../views/base/dialogs/payment_fail_dailogue.dart';
import '../views/base/dialogs/payment_sucess_dailogue.dart';

class BookingController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  final UserRepo userRepo;

  BookingController({required this.userRepo, required this.authRepo});

  final ScrollController scrollController = ScrollController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<BookingModel> _bookingList = [];
  List<BookingModel> get bookingList => _bookingList;

  // BookingList? _bookinddata;
  // BookingList? get bookinddata => _bookinddata;

  bool _isPaginating = false;
  bool get isPaginating => _isPaginating;

  int page = 1;

  void updatepage() {
    page = 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  void scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.7) {
      if (!_isPaginating) {
        fetchNextBookingsPage();
      }
    }
  }

  Future<ResponseModel> getBookings() async {
    log("getBookings called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.getbookings();
      if (response.statusCode == 200) {
        _bookingList =
            bookingModelFromJson(jsonEncode(response.body['data']['data']));

        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
        _isLoading = false;
        update();
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "ERROR AT getBookings()!");
      log(e.toString(), name: "ERROR AT getBookings()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> fetchNextBookingsPage() async {
    if (_isPaginating) return;

    _isPaginating = true;
    update();

    try {
      page++;
      log(page.toString(), name: "Page No");
      Response response = await userRepo.getBookingsByPageUrl(page);
      if (response.statusCode == 200) {
        List<BookingModel> newBookings =
            bookingModelFromJson(jsonEncode(response.body['data']['data']));
        _bookingList.addAll(newBookings);
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

  BookingdetailsModel? _bookingdetailsModel;
  BookingdetailsModel? get bookingdetailsModel => _bookingdetailsModel;

  Future<void> updatebookingdetailsmodel() async {
    _bookingdetailsModel = null;
    update();
  }

  int amount = 0;
  int remainingamount = 0;
  Future<ResponseModel> getBookingsById(String id) async {
    log("getBookingsById called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.getbookingsById(id);
      log(jsonEncode(response.body['data']));
      if (response.statusCode == 200) {
        _bookingdetailsModel = await bookingdetailsModelFromJson(
            jsonEncode(response.body['data']));
        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
        amount = 0;
        remainingamount = 0;
        calcuateRemainingAmount();
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "ERROR AT getBookingsById()!");
      log(e.toString(), name: "ERROR AT getBookingsById()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  void calcuateRemainingAmount() {
    if (_bookingdetailsModel != null) {
      for (int i = 0;
          i < _bookingdetailsModel!.payoutBookingGoodUsers!.length;
          i++) {
        amount += _bookingdetailsModel!.payoutBookingGoodUsers![i].amount!;
      }
      remainingamount = _bookingdetailsModel!.amountForUser! - amount;
      update();
    }
  }

  // Page controller

  PageController pageController = PageController();
  int selectedPage = 0;

  void goToPage(int page) {
    pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  void updateselectedpage(int page) {
    selectedPage = page;
    update();
  }

  // Track Order

  List<Map<String, dynamic>> getTrackingSteps() {
    if (_bookingdetailsModel == null) return [];

    int pickupCount = 0;
    int dropCount = 0;

    final trackingStepslocation =
        _bookingdetailsModel!.locations!.map<Map<String, dynamic>>((location) {
      DateTime? doneAt = location.doneAt;

      String pickupOrDropString;
      if (location.type == "pickup") {
        pickupCount++;
        pickupOrDropString = "Pick up $pickupCount";
      } else {
        dropCount++;
        pickupOrDropString = "Drop $dropCount";
      }

      String date =
          doneAt != null ? DateFormat('MMM dd, yyyy').format(doneAt) : "";
      String time = doneAt != null ? DateFormat.jm().format(doneAt) : "";

      return {
        "title": pickupOrDropString,
        "subtitle": location.addressLineOne ?? "",
        "date": date,
        "time": time,
        "completed": doneAt != null,
      };
    }).toList();
    final isCancelled = _bookingdetailsModel!.cancelled != null;

    List<Map<String, dynamic>> steps = [
      {
        "title": "Order Placed",
        "subtitle": "Your order has been successfully placed.",
        "date": _bookingdetailsModel!.placed != null
            ? DateFormat('MMM dd, yyyy').format(_bookingdetailsModel!.placed!)
            : "",
        "time": _bookingdetailsModel!.placed != null
            ? DateFormat.jm().format(_bookingdetailsModel!.placed!)
            : "",
        "completed": _bookingdetailsModel!.placed != null,
      },
    ];
    if (isCancelled) {
      steps.add(
        {
          "title": "Order Cancelled",
          "subtitle": "Your order has been Cancelled.",
          "date": _bookingdetailsModel!.cancelled != null
              ? DateFormat('MMM dd, yyyy').format(_bookingdetailsModel!.placed!)
              : "",
          "time": _bookingdetailsModel!.cancelled != null
              ? DateFormat.jm().format(_bookingdetailsModel!.placed!)
              : "",
          "completed": _bookingdetailsModel!.cancelled != null,
        },
      );
    } else {
      steps.addAll([
        {
          "title": "Order Accepted",
          "subtitle": "Your order has been Accepted Successfully.",
          "date": _bookingdetailsModel!.confirmed != null
              ? DateFormat('MMM dd, yyyy')
                  .format(_bookingdetailsModel!.confirmed!)
              : "",
          "time": _bookingdetailsModel!.confirmed != null
              ? DateFormat.jm().format(_bookingdetailsModel!.confirmed!)
              : "",
          "completed": _bookingdetailsModel!.confirmed != null,
        },
        {
          "title": "Order Intransit",
          "subtitle": "Your order is being prepared for shipment.",
          "date": _bookingdetailsModel!.intransit != null
              ? DateFormat('MMM dd, yyyy')
                  .format(_bookingdetailsModel!.intransit!)
              : "",
          "time": _bookingdetailsModel!.intransit != null
              ? DateFormat.jm().format(_bookingdetailsModel!.intransit!)
              : "",
          "completed": _bookingdetailsModel!.intransit != null,
        },
        ...trackingStepslocation,
        {
          "title": "Order Delivered",
          "subtitle": "Your order has been Delivered.",
          "date": _bookingdetailsModel!.delivered != null
              ? DateFormat('MMM dd, yyyy')
                  .format(_bookingdetailsModel!.delivered!)
              : "",
          "time": _bookingdetailsModel!.delivered != null
              ? DateFormat.jm().format(_bookingdetailsModel!.delivered!)
              : "",
          "completed": _bookingdetailsModel!.delivered != null,
        },
      ]);
    }

    return steps;
  }

  // Timer page section

  // final int totalSeconds = 900;
  // late Timer _countdownTimer;
  //
  // int remainingTime = 0;
  // double progress = 1.0;
  //
  // void startCountdown(DateTime createdAt) {
  //   int secondPassed = DateTime.now().difference(createdAt).inSeconds;
  //   int timeLeft = totalSeconds - secondPassed;
  //
  //   remainingTime = timeLeft < 0 ? 0 : timeLeft;
  //   progress = remainingTime / totalSeconds;
  //   // update();
  //
  //   _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (remainingTime > 0) {
  //       remainingTime--;
  //       progress = remainingTime / totalSeconds;
  //       update();
  //     } else {
  //       timer.cancel();
  //     }
  //   });
  // }

  @override
  void onClose() {
    scrollController.dispose();
    _timer?.cancel();

    super.onClose();
  }

  // Easebuzz payment controller

  static MethodChannel _channel = MethodChannel('easebuzz');

  Future<ResponseModel> createpayment(dynamic data) async {
    log("createpayment called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.createpayment(data);

      if (response.statusCode == 200) {
        log(response.bodyString.toString(), name: "createpayment");

        await openEaseBuzzPaymentGateway(
            orderId: response.body['data'], payamount: data["amount"]);

        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "ERROR AT createpayment()!");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++',
          name: "ERROR AT createpayment()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> openEaseBuzzPaymentGateway(
      {required String orderId, required String payamount}) async {
    if (orderId.isValid) {
      Object parameters = {
        "access_key": orderId,
        "pay_mode": "test",
        "amount": payamount,
      };
      try {
        final paymentResponse =
            await _channel.invokeMethod("payWithEasebuzz", parameters);
        log(jsonEncode(paymentResponse), name: 'paymentResponse - EASEBUZZ');

        await fetchpayment(paymentResponse['payment_response']['txnid'])
            .then((value) async {
          if (value.isSuccess) {
            showDialog(
                context: navigatorKey.currentContext!,
                builder: (context) => PaymentSucessDailogue());
          } else {
            showDialog(
                context: navigatorKey.currentContext!,
                builder: (context) => PaymentFailDailogue());
          }
        });
      } catch (e) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(msg: 'Server Error!!!');
      }
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Server Error!!!');
    }
  }

  Future<ResponseModel> fetchpayment(String orderId) async {
    log("fetchpayment called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.fetchpayment(orderId: orderId);

      if (response.statusCode == 200) {
        log(response.bodyString.toString(), name: "fetchpayment");

        responseModel =
            ResponseModel(true, '${response.body['success']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "ERROR AT fetchpayment()!");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++',
          name: "ERROR AT fetchpayment()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  // Booking Page selection

  int showlistpage = 0;

  void updateshowlistpage(int page) {
    showlistpage = page;
    update();
  }

  // Goods Place Page Controller
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
  //
  // void startProgressTracking(DateTime startTime) {
  //   _isLoading = true;
  //   update();
  //   _timer?.cancel();
  //
  //   _timer = Timer.periodic(const Duration(seconds: 1), (_) {
  //     final now = DateTime.now().toUtc();
  //     final difference = now.difference(startTime);
  //     final totalSeconds = 15 * 60; // 15 minutes
  //     final passedSeconds = difference.inSeconds;
  //
  //     _progress = (passedSeconds / totalSeconds).clamp(0.0, 1.0);
  //     _isDelayed = passedSeconds >= totalSeconds;
  //
  //     update();
  //
  //     // if (_progress >= 1.0) {
  //     //   _timer?.cancel();
  //     // }
  //     if (_isDelayed) {
  //       _timer?.cancel();
  //     }
  //   });
  //   _isLoading = false;
  //   update();
  // }

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
