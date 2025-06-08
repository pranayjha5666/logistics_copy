import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:logistics/data/models/response/home_items_model.dart';
import '../data/models/response/bookingdetails_model.dart';
import '../data/models/response/response_model.dart';
import '../data/repositories/auth_repo.dart';
import '../data/repositories/user_repo.dart';

class PackersAndMoversController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  final UserRepo userRepo;

  PackersAndMoversController({required this.authRepo, required this.userRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int selectedOptionIndex = 0;

  void updateselectedOptionIndex(int idx) {
    selectedOptionIndex = idx;
    update();
  }

  bool isPickupLiftAvailable = false;
  void updateisPickupLiftAvailable(bool isavailable) {
    isPickupLiftAvailable = isavailable;
    update();
  }

  bool isDropLiftAvailable = false;
  void updateisDropLiftAvailable(bool isavailable) {
    isDropLiftAvailable = isavailable;
    update();
  }

  int activeStep = 0;

  void setActiveStep(int step) {
    activeStep = step;
    update();
  }

  void nextStep() {
    if (activeStep < 2) {
      activeStep++;
      update();
    }
  }

  void previousStep() {
    if (activeStep > 0) {
      activeStep--;
      update();
    }
  }

  List<HomeItemsModel> _homeitems = [];
  List<HomeItemsModel> get homeitems => _homeitems;

  Future<ResponseModel> gethomeItems() async {
    log("getBookingsById called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.gethomeItems();
      if (response.statusCode == 200) {
        log(response.body.toString(), name: "gethomeItems");
        _homeitems =
            await homeItemsModelFromJson(jsonEncode(response.body['data']));
        log(_homeitems.toString(), name: "HomeItems Model");
        responseModel =
            ResponseModel(true, '${response.body['success']}', response.body);
        groupItemsByCategory();
      } else {
        responseModel = ResponseModel(false, response.body['success']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "ERROR AT gethomeItems()!");
      log(e.toString(), name: "ERROR AT gethomeItems()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  List<CategoryGroup> grouped = [];

  void groupItemsByCategory() {
    log("groupItemsByCategory called");

    final Map<String, List<HomeItemsModel>> groupedMap = {};

    for (var item in _homeitems) {
      final category = item.homeItemCategory?.title ?? "Unknown";
      if (!groupedMap.containsKey(category)) {
        groupedMap[category] = [];
      }
      groupedMap[category]!.add(item);
    }

    grouped = groupedMap.entries
        .map((e) => CategoryGroup(categoryName: e.key, items: e.value))
        .toList();

    update();
  }

  void updateItemCount(HomeItemsModel item, bool increment) {
    int index = _homeitems.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      if (increment) {
        _homeitems[index].quantity += 1;
      } else {
        if (_homeitems[index].quantity > 0) {
          _homeitems[index].quantity -= 1;
        }
      }
      update();
    }
  }

  List<HomeItemsModel> selectedItems = [];

  void updatehomeitems() {
    _homeitems = [];
    update();
  }

  void getSelectedItems() {
    selectedItems = _homeitems.where((item) => item.quantity > 0).toList();
    _groupselecteditems = {};
    groupSelectedItemsByCategoryName(selectedItems);
  }

  Map<String, List<Map<String, dynamic>>> _groupselecteditems = {};
  Map<String, List<Map<String, dynamic>>> get groupselecteditems =>
      _groupselecteditems;

  void updategroupselecteditems() {
    _groupselecteditems = {};
    update();
  }

  void groupSelectedItemsByCategoryName(List<HomeItemsModel> items) {
    for (var item in items) {
      final categoryTitle = item.homeItemCategory?.title ?? "Unknown Category";
      final title = item.title ?? "Unknown Item";
      final quantity = item.quantity ?? 0;

      if (!_groupselecteditems.containsKey(categoryTitle)) {
        _groupselecteditems[categoryTitle] = [];
      }

      _groupselecteditems[categoryTitle]!.add({
        'title': title,
        'quantity': quantity,
      });
    }
  }

  // store packers and movers

  Future<ResponseModel> packerandmoverbooking(dynamic data) async {
    log("packerandmoverbooking called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.packerandmoverbooking(data);
      if (response.statusCode == 200) {
        log(response.bodyString.toString());
        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "ERROR AT packerandmoverbooking()!");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++',
          name: "ERROR AT packerandmoverbooking()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Map<String, List<Map<String, dynamic>>> _groupedItems = {};
  Map<String, List<Map<String, dynamic>>> get groupedItems => _groupedItems;

  void updategroupedItems() {
    _groupedItems = {};
    update();
  }

  void groupItemsByCategoryName(List<BookingGoodHomeItem> items) {
    _groupedItems = {};
    for (var item in items) {
      final categoryTitle =
          item.homeItemData?.homeItemCategory?.title ?? "Unknown Category";
      final title = item.homeItemData?.title ?? "Unknown Item";
      final quantity = item.quantity ?? 0;

      if (!_groupedItems.containsKey(categoryTitle)) {
        _groupedItems[categoryTitle] = [];
      }

      _groupedItems[categoryTitle]!.add({
        'title': title,
        'quantity': quantity,
      });
    }
  }
}
