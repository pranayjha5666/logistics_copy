import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/auth_controller.dart';
import 'package:logistics/controllers/two_wheeler_controller.dart';
import 'package:logistics/services/extensions.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/base/common_button.dart';
import '../../../../controllers/location_controller.dart';
import '../../../../services/route_helper.dart';
import 'Components/change_location_dailogue.dart';
import 'Drop_details_components/recent_address_section.dart';
import 'Drop_details_components/saved_address_page.dart';
import 'Pickup_details_components/pickup_address.dart';
import 'Pickup_details_components/recent_address_model_and_list.dart';
import 'Pickup_details_components/saved_address_model_and_list.dart';

List<RecentAddress> recentaddress = [
  RecentAddress(
    mapAddress: "Pokhran Road No. 2, Thane West",
    addressLineOne: "Rustomjee Urbania",
    addressLineTwo: "Tower B, Flat 1204",
    pincode: "400610",
    city: "Thane",
    name: "Ankita Deshmukh",
    phone: "9876543210",
    stateName: "Maharashtra",
    latitude: "19.2183",
    longitude: "72.9781",
    stateId: 27,
  ),
  RecentAddress(
    mapAddress: "Ghodbunder Road, Thane West",
    addressLineOne: "Hiranandani Estate",
    addressLineTwo: "Building Orchid, Flat 403",
    pincode: "400607",
    city: "Thane",
    name: "Rohan Mehta",
    phone: "8888888888",
    stateName: "Maharashtra",
    latitude: "19.2508",
    longitude: "72.9636",
    stateId: 27,
  ),
  RecentAddress(
    mapAddress: "Majiwada, Eastern Express Highway",
    addressLineOne: "Lodha Paradise",
    addressLineTwo: "Tower 9, Flat 903",
    pincode: "400601",
    city: "Thane",
    name: "Sneha Patil",
    phone: "7777777777",
    stateName: "Maharashtra",
    latitude: "19.2013",
    longitude: "72.9780",
    stateId: 27,
  ),
  RecentAddress(
    mapAddress: "Vartak Nagar, Thane West",
    addressLineOne: "Kores Towers",
    addressLineTwo: "Near Sulochana Devi School",
    pincode: "400606",
    city: "Thane",
    name: "Amit Kulkarni",
    phone: "6666666666",
    stateName: "Maharashtra",
    latitude: "19.2090",
    longitude: "72.9614",
    stateId: 27,
  ),
];

class PickUpDetailsPage extends StatefulWidget {
  final int? maxlocaladdress;
  final bool? istwowheeler;
  final bool? iscarandbike;
  PickUpDetailsPage(
      {super.key, this.maxlocaladdress, this.istwowheeler, this.iscarandbike});

  @override
  State<PickUpDetailsPage> createState() => _PickUpDetailsPageState();
}

class _PickUpDetailsPageState extends State<PickUpDetailsPage> {
  final formkey = GlobalKey<FormState>();
  // String? selectedStateName;
  // int? selectedStateId;
  final controller = Get.find<LocationController>();

  @override
  void initState() {
    super.initState();
    controller.localPickupLocations = controller.pickupLocations.isNotEmpty
        ? List.from(controller.pickupLocations)
        : [LocationFormControllers(type: "pickup")];

    if (controller.localPickupLocations.first.latitude == null) {
      _fillCurrentLocation(controller);
    }
  }

  void _fillCurrentLocation(LocationController controller) {
    if (controller.localPickupLocations.isNotEmpty) {
      var usermodel = Get.find<AuthController>().userModel!;

      final firstLocation = controller.localPickupLocations.first;

      firstLocation.name.text = usermodel.name.toString();
      firstLocation.phone.text = usermodel.phone.toString();
      firstLocation.mapaddress.text = controller.addressText ?? '';
      firstLocation.city.text = controller.city ?? '';
      firstLocation.pincode.text = controller.pincode ?? '';
      firstLocation.stateName = controller.statename;
      final matchedState =
          Get.find<AuthController>().stateList.firstWhereOrNull(
                (state) => state['name'] == controller.statename,
              );

      if (matchedState != null) {
        firstLocation.stateId = matchedState['id'];
      }
      firstLocation.latitude = controller.selectedLatLng.latitude.toString();
      firstLocation.longitude = controller.selectedLatLng.longitude.toString();
      log(firstLocation.stateName.toString(), name: "StateName");
      log(firstLocation.stateId.toString(), name: "StateId");
      setState(() {});
    }
  }

  List<Map<String, dynamic>> converthomelistmap(
      List<LocationFormControllers> location) {
    return location.map((items) {
      return {
        "type": items.type,
        "latitude": items.latitude,
        "longitude": items.longitude,
      };
    }).toList();
  }

  void submitPickupLocations() {
    if (!formkey.currentState!.validate()) return;

    final locationController = Get.find<LocationController>();
    locationController.pickupLocations
      ..clear()
      ..addAll(controller.localPickupLocations);
    locationController.updatepickupAddressList();

    if (widget.istwowheeler != null) {
      final data = {
        "locations": [
          ...converthomelistmap(locationController.pickupLocations),
          ...converthomelistmap(locationController.dropLocations),
        ],
        "booking_type":
            Get.find<TwoWheelerController>().bike ? "two_wheeler" : "truck",
        if (!Get.find<TwoWheelerController>().bike)
          "two_wheeler_truck_id": Get.find<TwoWheelerController>().tempotypeid,
      };

      log(data.toString(),
          name: "Send Api Data calculatetwowheelerdeliveryamount");

      if (locationController.dropLocations.isNotEmpty &&
          locationController.dropLocations.first.latitude != null) {
        Get.find<TwoWheelerController>()
            .calculatetwowheelerdeliveryamount(data);
      }
    }

    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != Get.find<LocationController>().pickupDate) {
      Get.find<LocationController>().updatedate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Pick up Details",
          style:
              Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 17),
        ),
        // centerTitle: true,
      ),
      body: GetBuilder<LocationController>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.istwowheeler == null &&
                      widget.iscarandbike != true) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black, width: .5),
                          ),
                          child: GetBuilder<LocationController>(
                              builder: (controller) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller.pickupDate == null
                                        ? "Select Pickup Date"
                                        : "${controller.pickupDate!.dMyDash}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: controller.pickupDate == null
                                              ? Colors.grey[500]
                                              : Colors.black,
                                        ),
                                  ),
                                  Icon(
                                    Icons.calendar_month,
                                    color: controller.pickupDate == null
                                        ? Colors.grey[500]
                                        : Colors.black,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                      color: Color(0xffF1F1F1),
                    ),
                  ],
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.localPickupLocations.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.localPickupLocations.length) {
                        return controller.localPickupLocations.length <
                                (widget.maxlocaladdress ?? 4)
                            ? GestureDetector(
                                onTap: controller.addPickupLocation,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Color(0xffEBF2F3),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Row(children: [
                                      Icon(
                                        Icons.add,
                                        color: primaryColor,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Add more pickup location",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      )
                                    ]),
                                  ),
                                ),
                              )
                            : SizedBox.shrink();
                      } else {
                        final location = controller.localPickupLocations[index];
                        return Column(
                          children: [
                            if (index != 0)
                              Container(
                                height: 10,
                                color: Color(0xffF1F1F1),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 16.0,
                                  top: 8.0),
                              child: PickupAddress(
                                index: index,
                                location: location,
                                onRemove: () =>
                                    controller.removePickupLocation(index),
                                canRemove:
                                    controller.localPickupLocations.length > 1,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      final selectedAddress = await Navigator.push(
                        context,
                        getCustomRoute(child: SavedAddressPage()),
                      );
                      if (selectedAddress != null &&
                          selectedAddress is SavedAddress) {
                        final location = controller.localdropLocations.last;
                        if (location.mapaddress.text.isNotEmpty) {
                          bool res = await showConfirmationDialog(context);
                          if (res) {
                            _updateAddress(location, selectedAddress);
                          }
                        } else {
                          _updateAddress(location, selectedAddress);
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Color(0xffEBF2F3),
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: [
                            Icon(Icons.favorite),
                            SizedBox(width: 5),
                            Expanded(
                                child: Text(
                              "Saved Addresss",
                              style: Theme.of(context).textTheme.labelMedium,
                            )),
                            Icon(Icons.arrow_forward_ios, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  RecentAddressSection(
                    recentaddress: recentaddress,
                    locallocation: controller.localPickupLocations,
                    onAddressSelected: controller.updatePickupLocation,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: CustomButton(
              onTap: submitPickupLocations,
              title: "SUBMIT",
            ),
          )
        ],
      ),
    );
  }
}

Future<bool> showConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) {
          return ChangeLocationDailogue();
        },
      ) ??
      false;
}

void _updateAddress(LocationFormControllers location, SavedAddress address) {
  location.mapaddress.text = address.mapAddress;
  location.addressLineOne.text = address.addressLineOne;
  location.addressLineTwo.text = address.addressLineTwo;
  location.pincode.text = address.pincode;
  location.city.text = address.city;
  location.name.text = address.name;
  location.phone.text = address.phone;
  location.latitude = address.latitude;
  location.longitude = address.longitude;
  location.stateName = address.stateName;
  location.stateId = address.stateId;
}
