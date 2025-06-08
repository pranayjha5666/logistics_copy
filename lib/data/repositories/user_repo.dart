import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logistics/controllers/otp_autofill_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/constants.dart';
import '../api/api_client.dart';

class UserRepo {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;
  UserRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> login({required String phone}) async =>
      await apiClient.postData(AppConstants.loginUri, {
        'phone': phone,
        "app_signature":
            await Get.find<OTPAutofillController>().getAppSignature()
      });

  Future<Response> verifyOTP(dynamic data) async =>
      await apiClient.postData(AppConstants.verifyOtp, data);

  Future<Response> logout() async =>
      await apiClient.getData(AppConstants.logOutUri);

  Future<Response> registerUser(dynamic data) async =>
      await apiClient.postData(AppConstants.registerUri, data);

  Future<Response> getBusinessSettings() async =>
      await apiClient.getData(AppConstants.businessSettings);

  Future<Response> getStates() async =>
      await apiClient.getData(AppConstants.states);

  Future<Response> getSliders() async =>
      await apiClient.getData(AppConstants.banner);

  Future<Response> goodsbooking(dynamic data) async =>
      await apiClient.postData(AppConstants.storegoodsbooking, data);

  Future<Response> fetchvehicles(dynamic data) async =>
      await apiClient.postData(AppConstants.fetchvehicles, data);

  Future<Response> getgoodstype() async =>
      await apiClient.getData(AppConstants.getgoodstype);

  Future<Response> getbookings() async =>
      await apiClient.getData(AppConstants.getbookings);

  Future<Response> getBookingsByPageUrl(int page) async =>
      await apiClient.getData("${AppConstants.getbookings}?page=$page");

  Future<Response> getbookingsById(String id) async =>
      await apiClient.getData("${AppConstants.getbookings}/$id");

  Future<Response> gethomeItems() async =>
      await apiClient.getData(AppConstants.gethomeitems);

  // Packers And Movers
  Future<Response> packerandmoverbooking(dynamic data) async =>
      await apiClient.postData(AppConstants.storepackerandmoverbooking, data);

  Future<Response> getlistpackerandmoversbookings() async =>
      await apiClient.getData(AppConstants.getlistpackerandmoversbookings);

  Future<Response> getPackersandMoversBookingsByPageUrl(int page) async =>
      await apiClient.getData("${AppConstants.getbookings}?page=$page");

  // Easebuzz Payment
  Future<Response> createpayment(dynamic data) async =>
      await apiClient.postData(AppConstants.createpayment, data);

  Future<Response> fetchpayment({required orderId}) async =>
      await apiClient.getData("${AppConstants.fetchpayment}/$orderId");

  // Two Wheeler

  Future<Response> getpackagestypes() async =>
      await apiClient.getData(AppConstants.getpackagestypes);

  Future<Response> calculatetwowheelerdeliveryamount(dynamic data) async =>
      await apiClient.postData(
          AppConstants.calculatetwowheelerdeliveryamount, data);

  Future<Response> verifypromocode(dynamic data) async =>
      await apiClient.postData(AppConstants.verifypromocode, data);

  Future<Response> storetwowheelerbookings(dynamic data) async =>
      await apiClient.postData(AppConstants.storetwowheelerbookings, data);

  Future<Response> gettwowheelerbookings() async =>
      await apiClient.getData(AppConstants.gettwowheelerbookings);

  Future<Response> gettwowheelerBookingsByPageUrl(int page) async =>
      await apiClient
          .getData("${AppConstants.gettwowheelerbookings}?page=$page");

  Future<Response> gettwowheelerbookingsById(String id) async =>
      await apiClient.getData("${AppConstants.gettwowheelerbookings}/$id");

  Future<Response> gettempolist() async =>
      await apiClient.getData(AppConstants.gettempolist);

// Two wheeler eazebuzz
  Future<Response> createtwowheelerpayment(dynamic data) async =>
      await apiClient.postData(AppConstants.createtwowheelerpayment, data);

  Future<Response> fetchtwowheelerpayment({required orderId}) async =>
      await apiClient
          .getData("${AppConstants.fetchtwowheelerpayment}/$orderId");

  Future<Response> cancelTwoWheelerOrder(String id) async =>
      await apiClient.getData("${AppConstants.cancelTwoWheelerOrder}/$id");

  Future<Response> editprofile(dynamic data) async =>
      await apiClient.postData(AppConstants.editprofile, data);

  // car and bike
  Future<Response> storecarandbikebooking(dynamic data) async =>
      await apiClient.postData(AppConstants.carandbikebooking, data);



  Future<Response> getcarandbikebooking() async =>
      await apiClient.getData(AppConstants.fetchcarandbikebooking);


  Future<Response> getcarandbikeBookingByPageUrl(int page) async =>
      await apiClient
          .getData("${AppConstants.fetchcarandbikebooking}?page=$page");


  // Faqs
  Future<Response> getFaqs() async =>
      await apiClient.getData(AppConstants.faqs);

}
