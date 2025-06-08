import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logistics/data/models/response/packages_type_model.dart';
import 'package:logistics/data/models/response/promo_code_model.dart';
import 'package:logistics/data/models/response/tempo_list_model.dart';
import 'package:logistics/services/extensions.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/views/screens/DashBoard/Home_Screen/Packers_And_Movers/booking_placed_page.dart';

import '../data/models/response/response_model.dart';
import '../data/repositories/auth_repo.dart';
import '../data/repositories/user_repo.dart';
import '../main.dart';
import '../views/base/dialogs/payment_fail_dailogue.dart';
import '../views/base/dialogs/payment_sucess_dailogue.dart';
import '../views/screens/DashBoard/Booking_Screen/TwoWheelerList/TwoWheeler_BookingDetails/Pending_Order_Page/pending_order_page.dart';
import 'location_controller.dart';

class TwoWheelerController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  final UserRepo userRepo;

  TwoWheelerController({required this.userRepo, required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool bike = true;
  void updatebike(bool isbike) {
    bike = isbike;
    update();
  }

  TextEditingController parcelvalue = TextEditingController();
  // List<String> selectedTypes = [];
  String _selectedType = "";
  int? selectedType_id;
  String get selectedType => _selectedType;

  void toggleSelection(String type, int? id) {
    if (_selectedType != type) {
      _selectedType = type;
      selectedType_id = id;
    } else {
      _selectedType = "";
      selectedType_id = null;
    }
    update();
  }

  bool paymentmode = true;
  String? paymentaddress;
  int? paymentaddressindex;

  void updatepaymentmode(bool iscash, {String? address, int? index}) {
    if (iscash) {
      paymentmode = false;
      paymentaddress = address;
      paymentaddressindex = index;
    } else {
      paymentmode = true;
      paymentaddress = null;
      paymentaddressindex = null;
    }
    update();
  }

  // packages types

  List<PackagesTypeModel> _packagestype = [];
  List<PackagesTypeModel> get packagestypeList => _packagestype;

  Future<ResponseModel> getpackagestypes() async {
    log("getpackagestypes called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.getpackagestypes();
      if (response.statusCode == 200) {
        _packagestype =
            packagesTypeModelFromJson(jsonEncode(response.body['data']));

        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
        _isLoading = false;
        update();
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "ERROR AT getpackagestypes()!");
      log(e.toString(), name: "ERROR AT getpackagestypes()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  // Tempo List

  List<TempoListModel> _tempolist = [];
  List<TempoListModel> get tempolist => _tempolist;

  int tempotypeidx = 0;
  int? tempotypeid;
  String? tempotypeweight;

  Future<ResponseModel> gettempolist() async {
    log("gettempolist called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.gettempolist();
      if (response.statusCode == 200) {
        _tempolist = tempoListModelFromJson(jsonEncode(response.body['data']));
        tempotypeid = _tempolist.first.id;
        tempotypeweight=_tempolist.first.weight;
        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);

        log(_tempolist.toString(), name: "Tempo List");
        _isLoading = false;
        update();
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "ERROR AT gettempolist()!");
      log(e.toString(), name: "ERROR AT gettempolist()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  void updatetempotypeidx(int idx, int? id,String? weight) {
    tempotypeidx = idx;
    tempotypeid = id;
    tempotypeweight=weight;
    update();
  }

  // Calculate Two Wheeler Delivery Amount
  double? deliveryamount;
  double? deliveryamountfordriver;
  double? totalamount;
  String? error;

  void updatedeliveryamount() {
    deliveryamount = null;
    totalamount = null;
    deliveryamountfordriver = null;
  }

  Future<ResponseModel> calculatetwowheelerdeliveryamount(dynamic data) async {
    log("calculatetwowheelerdeliveryamount called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response =
          await userRepo.calculatetwowheelerdeliveryamount(data);
      if (response.statusCode == 200) {
        log(response.bodyString.toString(),
            name: "calculatetwowheelerdeliveryamount");
        deliveryamount = (response.body["delivery_amount"] as num).toDouble();
        deliveryamountfordriver =
            (response.body["delivery_amount_for_driver"] as num).toDouble();

        totalamount = deliveryamount;
        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
        error = null;
      } else if (response.statusCode == 422) {
        deliveryamount = null;
        totalamount = null;
        error = response.body["message"];
        responseModel = ResponseModel(false, response.body['message']);
      } else {
        deliveryamount = null;
        totalamount = null;
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      deliveryamount = null;
      totalamount = null;
      responseModel =
          ResponseModel(false, "ERROR AT calculatetwowheelerdeliveryamount()!");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  // Verify Promo Code
  TextEditingController promocodecontroller = TextEditingController();
  bool _ispromocodeapplied = false;
  bool get ispromocodeapplied => _ispromocodeapplied;

  void updatepromocodeapplied(bool updateval) {
    _ispromocodeapplied = updateval;
    if (!updateval) {
      promocodedata = null;
      promocodeval = null;
      calculateamount(null, null);
    }
    update();
  }

  PromoCodeModel? promocodedata;
  double? promocodeval;

  void updatepromocodeval() {
    _ispromocodeapplied = false;
    promocodedata = null;
    promocodeval = null;
    calculateamount(null, null);
    update();
  }

  Future<ResponseModel> verifypromocode(dynamic data) async {
    log("verifypromocode called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.verifypromocode(data);
      if (response.statusCode == 200) {
        log(response.bodyString.toString(), name: "verifypromocode");
        promocodedata =
            promoCodeModelFromJson(jsonEncode(response.body['data']));
        calculateamount(promocodedata!.type!, promocodedata!.value!.toDouble());
        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
      } else {
        promocodedata = null;
        promocodeval = null;
        calculateamount(null, null);
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      promocodedata = null;
      promocodeval = null;
      calculateamount(null, null);
      responseModel = ResponseModel(false, "ERROR AT verifypromocode()!");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  void calculateamount(String? type, double? value) {
    if (deliveryamount == null) {
      return;
    }

    if (type == "percentage") {
      if (value! > 0) {
        promocodeval = (deliveryamount! * value).ceilToDouble() / 100;
      }
    } else if (type == "flat") {
      promocodeval = value!;
    }

    double rawTotal = deliveryamount! - (promocodeval ?? 0);
    totalamount = (rawTotal * 100).ceilToDouble() / 100;
  }

  // store two wheeler bookings
  static MethodChannel _channel = MethodChannel('easebuzz');
  Future<ResponseModel> storetwowheelerbookings(dynamic data) async {
    log("storetwowheelerbookings called");
    _isLoading = true;
    update();
    ResponseModel responseModel;

    try {
      Response response = await userRepo.storetwowheelerbookings(data);
      if (response.statusCode == 200) {
        log(response.bodyString.toString(), name: "storetwowheelerbookings");

        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel =
          ResponseModel(false, "ERROR AT storetwowheelerbookings()!");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  // Easebuzz for two wheeler

  Future<ResponseModel> createtwowheelerpayment(dynamic data) async {
    log("createtwowheelerpayment called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.createtwowheelerpayment(data);

      if (response.statusCode == 200) {
        log(response.bodyString.toString(), name: "createtwowheelerpayment");

        await opentwowheelerEaseBuzzPaymentGateway(
            orderId: response.body['data']);

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

  Future<void> opentwowheelerEaseBuzzPaymentGateway(
      {required String orderId}) async {
    if (orderId.isValid) {
      Object parameters = {
        "access_key": orderId,
        "pay_mode": "test",
      };
      try {
        final paymentResponse =
            await _channel.invokeMethod("payWithEasebuzz", parameters);
        log(jsonEncode(paymentResponse),
            name: 'paymentResponse - EASEBUZZ two wheeler');

        await fetchtwowheelerpayment(
                paymentResponse['payment_response']['txnid'])
            .then((value) async {
          if (value.isSuccess) {
            // Navigator.push(navigatorKey.currentContext!, getCustomRoute(child: BookingPlacedPage()));

            // showDialog(
            //     context: navigatorKey.currentContext!,
            //     builder: (context) => PaymentSucessDailogue());

            // Navigator.push(
            //   navigatorKey.currentContext!,
            //   getCustomRoute(
            //     child: PendingOrderPage(
            //         lat: double.parse(
            //             locationcontroller
            //                 .pickupLocations
            //                 .first
            //                 .latitude!),
            //         lng: double.parse(
            //             locationcontroller
            //                 .pickupLocations
            //                 .first
            //                 .longitude!),
            //         id: value.data["data"]),
            //   ),
            // );
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

  Future<ResponseModel> fetchtwowheelerpayment(String orderId) async {
    log("fetchtwowheelerpayment called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response =
          await userRepo.fetchtwowheelerpayment(orderId: orderId);

      if (response.statusCode == 200) {
        log(response.bodyString.toString(), name: "fetchtwowheelerpayment");


        final locationcontroller = Get.find<LocationController>();

        Navigator.push(
          navigatorKey.currentContext!,
          getCustomRoute(
            child: PendingOrderPage(
                lat: double.parse(
                    locationcontroller.pickupLocations.first.latitude!),
                lng: double.parse(
                    locationcontroller.pickupLocations.first.longitude!),
                id: response.body["data"]),
          ),
        );

        responseModel =
            ResponseModel(true, '${response.body['success']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel =
          ResponseModel(false, "ERROR AT fetchtwowheelerpayment()!");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++',
          name: "ERROR AT fetchtwowheelerpayment()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    parcelvalue.dispose();
    promocodecontroller.dispose();

    super.dispose();
  }
}
