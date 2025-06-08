import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:logistics/views/base/snack_bar.dart';

import '../data/api/api_checker.dart';
import '../data/models/contact_number.dart';
import '../data/models/response/business_settings.dart';
import '../data/models/response/response_model.dart';
import '../data/models/response/user_model.dart';
import '../data/repositories/auth_repo.dart';
import '../data/repositories/user_repo.dart';
import '../services/constants.dart';
import '../services/extensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  final UserRepo userRepo;

  AuthController({required this.userRepo, required this.authRepo});

  bool _isLoading = false;
  bool _acceptTerms = true;

  late final number = ContactNumber(number: '', countryCode: '+91');
  TextEditingController numberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  bool get isLoading => _isLoading;
  bool get acceptTerms => _acceptTerms;

  Future<ResponseModel> login({required String phoneNo}) async {
    ResponseModel responseModel;
    _isLoading = true;
    update();
    log("response.body.toString()${AppConstants.baseUrl}${AppConstants.loginUri}",
        name: "login");
    try {
      Response response = await userRepo.login(phone: phoneNo);
      log(response.statusCode.toString());
      log(response.body.toString());
      if (response.statusCode == 200) {
        log(response.body.toString());
        if (response.body.containsKey('errors')) {
          _isLoading = false;
          update();
          return ResponseModel(
              false, response.statusText!, response.body['errors']);
        }
        if (response.body.containsKey('token')) {
          authRepo.saveUserToken(response.body['token'].toString());
        }
        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.statusText!);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "ERROR AT login()");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++',
          name: "ERROR AT login()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  String? userStatus;
  Future<ResponseModel> verifyOTP(dynamic data) async {
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.verifyOTP(data);
      log(response.statusCode.toString());
      log(response.body.toString(), name: "VerifyOtp");
      if (response.statusCode == 200) {
        log(response.body.toString());

        if (response.body.containsKey('errors')) {
          _isLoading = false;
          update();
          return ResponseModel(
              false, response.statusText!, response.body['errors']);
        }
        if (response.body.containsKey('token')) {
          authRepo.saveUserToken(response.body['token'].toString());
        }
        // authRepo.saveUserType(jsonEncode(response.body['data']['type']));
        if (response.body.containsKey('user_type')) {
          userStatus = response.body['user_type'];
          update();
        }
        responseModel =
            ResponseModel(true, '${response.body['user_type']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Server Error!!");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++',
          name: "ERROR AT login()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> logOutUser() async {
    ResponseModel responseModel;
    _isLoading = true;
    update();
    try {
      Response response = await userRepo.logout();
      if (response.statusCode == 200) {
        log(response.bodyString!, name: "logOutUser");
        responseModel = ResponseModel(true, 'success');
      } else {
        ApiChecker.checkApi(response);
        responseModel = ResponseModel(false, "${response.statusText}");
      }
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT logOutUser()");
      responseModel = ResponseModel(false, "$e");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> registerUser(dynamic data) async {
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.registerUser(data);
      if (response.statusCode == 200) {
        log(response.bodyString.toString());
        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "ERROR AT registerUser()!");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++',
          name: "ERROR AT addClient()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }


  Future<ResponseModel> editprofile(dynamic data) async {
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.editprofile(data);
      if (response.statusCode == 200) {
        log(response.bodyString.toString());
        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "ERROR AT editprofile()!");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++',
          name: "ERROR AT editprofile()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }


  void clearTextField() {
    numberController.clear();
    otpController.clear();
    authRepo.clearSharedData();
    update();
  }

  Future<ResponseModel> getUserProfileData() async {
    log("getUserProfileData called");

    ResponseModel responseModel;
    _isLoading = true;
    try {
      Response response = await authRepo.getUser();

      if (response.statusCode == 200) {
        log(response.bodyString.toString(), name: "getUserProfileData");
        _userModel = userModelFromJson(jsonEncode(response.body['data']));

        log(_userModel.toString(), name: "UserModel Data");

        update();
        responseModel = ResponseModel(true, 'success');
      } else {
        ApiChecker.checkApi(response);
        responseModel = ResponseModel(false, "${response.statusText}");
      }
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT getUserProfileData()");
      responseModel = ResponseModel(false, "$e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  List<BusinessSettings> businessSettings = [];

  Future<ResponseModel> getBusinessSettings() async {
    ResponseModel responseModel;
    _isLoading = true;
    update();
    log("${AppConstants.baseUrl}${AppConstants.businessSettings}",
        name: "getBusinessSettings");
    try {
      Response response = await userRepo.getBusinessSettings();
      log(jsonEncode(response.body), name: "getBusinessSettings");
      if (response.statusCode == 200) {
        businessSettings =
            businessSettingsFromJson(jsonEncode(response.body['data']));
        log('responseBusiness ${jsonEncode(response.body['data'])}',
            name: "Business data body");
        responseModel = ResponseModel(true, '${response.body}', response.body);
      } else {
        responseModel = ResponseModel(false, '${response.body}', response.body);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "CATCH");
      log('++++ ${e.toString()} +++++++',
          name: "ERROR AT getBusinessSettings()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  List<dynamic> stateList = [];
  Future<ResponseModel> getStates() async {
    ResponseModel responseModel;
    _isLoading = true;
    update();
    log("${AppConstants.baseUrl}${AppConstants.states}", name: "getStates");
    try {
      Response response = await userRepo.getStates();
      log(jsonEncode(response.body), name: "getStates");
      if (response.statusCode == 200) {
        stateList = response.body['data'];
        update();
        log('getStates ${jsonEncode(response.body['data'])}',
            name: "States data body");
        responseModel = ResponseModel(true, '${response.body}', response.body);
      } else {
        responseModel = ResponseModel(false, '${response.body}', response.body);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "CATCH");
      log('++++ ${e.toString()} +++++++',
          name: "ERROR AT getStates()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  String? localPath;
  bool isPdf = false;

  Future<void> prepareFile(String fileUrl) async {
    _isLoading = true;
    update();
    try {
      isPdf = fileUrl.toLowerCase().endsWith(".pdf");
      if (isPdf) {
        final response = await http.get(Uri.parse(fileUrl));
        if (response.statusCode == 200) {
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/temp.pdf');
          await file.writeAsBytes(response.bodyBytes);
          localPath = file.path; // ✅ Update controller field
        } else {
          log("Failed to download PDF: ${response.statusCode}");
        }
      } else {
        localPath = fileUrl; // ✅ For image, just use the URL
      }
    } catch (e) {
      log("Error in prepareFile: $e");
    }

    _isLoading = false;
    update(); // ✅ Must call update to rebuild the UI
  }

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  void setUserToken(String id) {
    authRepo.saveUserToken(id);
  }

  bool checkUserData() {
    try {
      if (_userModel!.name.isValid && _userModel!.phone.isValid
          // && _userModel!.email.isValid
          ) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
