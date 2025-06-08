import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logistics/data/models/response/response_model.dart';
import 'package:logistics/main.dart';
import '../data/models/response/location_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../services/constants.dart';
import '../views/screens/DashBoard/Location_Selection/Components/enableLocationDailogue.dart';

class LocationController extends GetxController implements GetxService {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int maxPickup = 4;
  int maxDrop = 4;



  final List<LocationFormControllers> _pickupLocations = [];
  final List<LocationFormControllers> _dropLocations = [];

  List<LocationFormControllers> get pickupLocations => _pickupLocations;
  List<LocationFormControllers> get dropLocations => _dropLocations;

  List<LocationModel> pickaddressList = [];
  List<LocationModel> dropaddressList = [];

  int get totalAddresses => pickaddressList.length + dropaddressList.length;

  DateTime? pickupDate;

  void updatedate(DateTime? date) {
    pickupDate = date;
    update();
  }

  @override
  void onInit() {
    _pickupLocations.add(LocationFormControllers(type: "pickup"));
    _dropLocations.add(LocationFormControllers(type: "drop"));
    super.onInit();
  }



  void updatepickupAddressList() {
    pickaddressList =
        _pickupLocations.map((address) => address.toModel()).toList();
    update();
  }

  void updatedropAddressList() {
    dropaddressList = _dropLocations.map((loc) => loc.toModel()).toList();
    update();
  }

  @override
  void onClose() {
    for (var form in _pickupLocations) {
      form.dispose();
    }
    for (var form in _dropLocations) {
      form.dispose();
    }
    super.onClose();
  }


  // Local Drop Location
  List<LocationFormControllers> localdropLocations = [];


  //Map part

  GoogleMapController? mapController;

  // by default location is gatway of india by fetching current location is update automatically
  LatLng selectedLatLng = LatLng(18.9220, 72.8347);

  bool isServiceAvailable = true;

  // void _showLocationDialog() {
  //   showDialog(
  //     context: navigatorKey.currentState!.context,
  //     builder: (_) => AlertDialog(
  //       title: Text("Location Required"),
  //       content: Text("Please turn on location services and grant permission."),
  //       actions: [
  //         TextButton(
  //           onPressed: () async {
  //             Navigator.pop(navigatorKey.currentState!.context);
  //             await Geolocator.openLocationSettings();
  //           },
  //           child: Text("Open Locatio"),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(navigatorKey.currentState!.context);
  //           },
  //           child: Text("Cancel"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  bool comefromdailogue = false;
  void updatecomefromdailogue(bool val) {
    comefromdailogue = val;
  }

  Future<void> getCurrentLocation() async {
    log("getCurrentLocation Called");

    try {
      // _isLoading = true;
      // update();
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      // if (!serviceEnabled) return;

      if (!serviceEnabled) {
        comefromdailogue = true;

        showDialog(
            context: navigatorKey.currentState!.context,
            builder: (_) => Enablelocationdailogue());

        // _showLocationDialog();

        return;
      }
      // comefromdailogue=false;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition();

      LatLng currentLatLng = LatLng(
        position.latitude,
        position.longitude,
      );

      selectedLatLng = currentLatLng;
      log(selectedLatLng.toString(), name: "Inside selectedLatLng");

      await updateAddressFromLatLng(currentLatLng);
      // _isLoading = false;
      // update();
    } catch (e) {
      // _isLoading = false;
      // update();
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++',
          name: "ERROR AT getCurrentLocation()");
    }
    _isLoading = false;
    update();
  }

  String? addressText;
  String? city;
  String? pincode;
  String? statename;
  Future<void> updateAddressFromLatLng(LatLng latLng) async {
    _isLoading = true;
    update();
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String newAddress =
            "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        addressText = newAddress;
        city = place.locality;
        pincode = place.postalCode;
        statename = place.administrativeArea;
        _isLoading = false;
        update();
      }
    } catch (e) {
      _isLoading = false;
      update();
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++',
          name: "ERROR AT updateAddressFromLatLng()");
    }
  }

  Future<ResponseModel> fetchPlaceDetailsById(String placeId) async {
    log('fetchPlaceDetailsById CALLED');
    ResponseModel responseModel;

    try {
      final url =
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${AppConstants.googleMapApiKey}";
      final response = await http.get(Uri.parse(url));
      log(jsonEncode(response.body), name: "fetchPlaceDetailsById");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data['result'];
        final lat = result['geometry']['location']['lat'];
        final lng = result['geometry']['location']['lng'];
        final address = result['formatted_address'];

        var returndata = {
          'lat': lat,
          'lng': lng,
          'address': address,
        };
        responseModel = ResponseModel(true, "SUCCESS", returndata);
      } else {

        responseModel = ResponseModel(false, response.toString(), "UNSUCCESS");
      }
    } catch (e) {

      responseModel = ResponseModel(false, "UNSUCCESS");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++',
          name: "ERROR AT fetchPlaceDetailsById()");
    }

    return responseModel;
  }

  TextEditingController citynamecontroller = TextEditingController();
  List<dynamic> listOfLocation = [];
  Timer? _timer;
  void placeSuggestionsWithGooge(String input) async {
    if (input.isEmpty) return;
    _isLoading = true;
    update();
    try {
      final url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=${AppConstants.googleMapApiKey}";
      final response = await http.get(Uri.parse(url));
      log(response.body.toString(), name: "placeSuggestionsWithGooge Response");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        listOfLocation = data['predictions'];
        log(listOfLocation.toString(), name: "listOfLocation");
      } else {
        log(response.body.toString(), name: "listOfLocation");
      }
    } catch (e) {
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++',
          name: "ERROR AT placeSuggestionsWithGooge()");
    }
    _isLoading = false;
    update();
  }

  void placeSuggestions(String input) async {
    if (input.isEmpty) return;

    final url =
        "https://nominatim.openstreetmap.org/search?q=$input&countrycodes=in&format=json&addressdetails=1";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      listOfLocation = data;
      log(listOfLocation.toString(), name: "listOfLocation");
      update();
    } else {
      log("HTTP error: ${response.statusCode}", name: "placeSuggestions");
    }
  }

  void onCityNameChanged(String value) {
    if (_timer?.isActive ?? false) _timer!.cancel();
    // _isLoading = true;
    // update();
    // _timer = Timer(const Duration(milliseconds: 500), () {
    //   placeSuggestionsWithGooge(value);
    // });

    placeSuggestionsWithGooge(value);
  }

  void disposeSearch() {
    _timer?.cancel();
    citynamecontroller.dispose();
  }
}

class LocationFormControllers {
  final TextEditingController mapaddress;
  final TextEditingController addressLineOne;
  final TextEditingController addressLineTwo;
  final TextEditingController pincode;
  final TextEditingController city;
  final TextEditingController name;
  final TextEditingController phone;

  final String type;
  String? stateName;
  String? latitude;
  String? longitude;
  int? stateId;

  LocationFormControllers({required this.type})
      : addressLineOne = TextEditingController(),
        addressLineTwo = TextEditingController(),
        pincode = TextEditingController(),
        mapaddress = TextEditingController(),
        city = TextEditingController(),
        name = TextEditingController(),
        phone = TextEditingController();

  LocationModel toModel() {
    return LocationModel(
      mapLocation: mapaddress.text.trim(),
      addressLineOne: addressLineOne.text.trim(),
      addressLineTwo: addressLineTwo.text.trim(),
      latitude: latitude ?? "Na",
      longitude: longitude ?? "Na",
      stateId: stateId ?? 0,
      city: city.text.toString(),
      pincode: pincode.text.trim(),
      type: type,
      name: name.text.trim(),
      phone: phone.text.trim(),
    );
  }

  void dispose() {
    mapaddress.dispose();
    addressLineOne.dispose();
    addressLineTwo.dispose();
    pincode.dispose();
    city.dispose();
  }
}
