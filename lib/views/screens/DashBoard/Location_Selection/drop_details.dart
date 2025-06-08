import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/views/screens/DashBoard/Location_Selection/Drop_details_components/saved_address_page.dart';
import 'package:logistics/views/screens/DashBoard/Location_Selection/Pickup_details_components/recent_address_model_and_list.dart';
import '../../../../controllers/location_controller.dart';
import '../../../../controllers/two_wheeler_controller.dart';
import 'Components/change_location_dailogue.dart';
import 'Drop_details_components/drop_address.dart';
import '../../../base/common_button.dart';
import 'Drop_details_components/recent_address_section.dart';
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

class DropDetails extends StatefulWidget {
  final int? maxlocaladdress;
  final bool? istwowheeler;

  const DropDetails({super.key, this.maxlocaladdress, this.istwowheeler});

  @override
  State<DropDetails> createState() => _DropDetailsState();
}

class _DropDetailsState extends State<DropDetails> {
  final formkey = GlobalKey<FormState>();
  final controller = Get.find<LocationController>();

  @override
  void initState() {
    super.initState();
    controller.localdropLocations = controller.dropLocations.isNotEmpty
        ? List.from(controller.dropLocations)
        : [LocationFormControllers(type: "drop")];
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

  void submitDropLocations() {
    if (formkey.currentState!.validate()) {
      controller.dropLocations.clear();
      controller.dropLocations.addAll(controller.localdropLocations);
      controller.updatedropAddressList();

      if (widget.istwowheeler != null) {
        final data = {
          "locations": [
            ...converthomelistmap(controller.pickupLocations),
            ...converthomelistmap(controller.dropLocations),
          ],
          "booking_type":
              Get.find<TwoWheelerController>().bike ? "two_wheeler" : "truck",
          if (!Get.find<TwoWheelerController>().bike)
            "two_wheeler_truck_id":
                Get.find<TwoWheelerController>().tempotypeid,
        };
        log(data.toString(),
            name: "Send Api Data calculatetwowheelerdeliveryamount");
        Get.find<TwoWheelerController>()
            .calculatetwowheelerdeliveryamount(data);
      }
      Navigator.pop(context);
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Dropping Details",
          style:
              Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 17),
        ),
      ),
      body: GetBuilder<LocationController>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.localdropLocations.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.localdropLocations.length) {
                        return controller.localdropLocations.length <
                                (widget.maxlocaladdress ?? 4)
                            ? GestureDetector(
                                onTap: controller.addDropLocation,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Color(0xffEBF2F3),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Row(children: [
                                      Icon(Icons.add),
                                      SizedBox(width: 5),
                                      Text(
                                        "Add more drop location",
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
                        final location = controller.localdropLocations[index];
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
                              child: DropAddress(
                                index: index,
                                location: location,
                                onRemove: () =>
                                    controller.removeDropLocation(index),
                                canRemove:
                                    controller.localdropLocations.length > 1,
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
                        controller.updateDropLocation(controller.localdropLocations.length - 1);
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
                    locallocation: controller.localdropLocations,
                    onAddressSelected: controller.updateDropLocation,
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
          Container(
            padding: EdgeInsets.all(16),
            child: CustomButton(
              onTap: submitDropLocations,
              title: "SUBMIT",
            ),
          ),
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
