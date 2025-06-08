import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:logistics/data/models/response/goods_type_model.dart';
import 'package:logistics/data/models/response/vehicles_model.dart';

import '../data/models/response/response_model.dart';
import '../data/repositories/auth_repo.dart';
import '../data/repositories/user_repo.dart';

class GoodsController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  final UserRepo userRepo;

  GoodsController({required this.userRepo, required this.authRepo});

  String? selectedTruckName;
  String? selectedGoodsType;
  int? good_type_id;
  int? vehicle_id;
  String? truck_type;

  void updateTruckType(String ? trucktype) {
    truck_type = trucktype;
    update();
  }

  void updateSelectedTruck(String? truckName,int? vehicleId) {
    vehicle_id=vehicleId;
    selectedTruckName = truckName;
    update();
  }

  void updateSelectedGoodsType(String? goodsType,int? goodsTypeid) {
    good_type_id=goodsTypeid;
    selectedGoodsType = goodsType;
    update();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> goodsBooking(dynamic data) async {
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.goodsbooking(data);
      if (response.statusCode == 200) {
        log(response.bodyString.toString());
        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "ERROR AT goodsBooking()!");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++',
          name: "ERROR AT goodsBooking()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  List<VehiclesModel> _vehicleslist = [];
  List<VehiclesModel> get vehiclesList => _vehicleslist;

  Future<ResponseModel> fetchVehicles(dynamic data) async {
    log("fetchVehicles called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.fetchvehicles(data);

      if (response.statusCode == 200) {
        log(response.bodyString.toString(), name: "fetchVehicles");

        _vehicleslist =
            vehiclesModelFromJson(jsonEncode(response.body['data']));

        log(_vehicleslist.toString(), name: "Vehicle List");
        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "ERROR AT getVehciles()!");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++',
          name: "ERROR AT ftechVehciles()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  List<GoodsTypeModel> _goodtypesList = [];
  List<GoodsTypeModel> get goodtypesList => _goodtypesList;

  Future<ResponseModel> getGodsType() async {
    log("getGodsType called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.getgoodstype();

      if (response.statusCode == 200) {
        log(response.bodyString.toString(), name: "getGodsType");

        _goodtypesList = goodsModelFromJson(jsonEncode(response.body['data']));
        log(_vehicleslist.toString(), name: "Goods  List");
        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "ERROR AT getGodsType()!");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++',
          name: "ERROR AT getGodsType()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}
