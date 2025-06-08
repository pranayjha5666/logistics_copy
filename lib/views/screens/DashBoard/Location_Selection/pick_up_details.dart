import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/auth_controller.dart';
import 'package:logistics/controllers/two_wheeler_controller.dart';
import 'package:logistics/services/extensions.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/base/common_button.dart';
import '../../../../controllers/location_controller.dart';
import 'Pickup_details_components/pickup_address.dart';

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
  List<LocationFormControllers> localPickupLocations = [];
  String? selectedStateName;
  int? selectedStateId;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<LocationController>();

    localPickupLocations = controller.pickupLocations.isNotEmpty
        ? List.from(controller.pickupLocations)
        : [LocationFormControllers(type: "pickup")];

    if (localPickupLocations.first.latitude == null) {
      _fillCurrentLocation(controller);
    }

    log(widget.maxlocaladdress.toString(), name: "MaxAddress");
  }

  void _fillCurrentLocation(LocationController controller) {
    if (localPickupLocations.isNotEmpty) {
      var usermodel = Get.find<AuthController>().userModel!;

      final firstLocation = localPickupLocations.first;

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

  void addPickupLocation() {
    if (localPickupLocations.length < 4) {
      setState(() {
        localPickupLocations.add(LocationFormControllers(type: "pickup"));
      });
    }
  }

  void removePickupLocation(int index) {
    if (localPickupLocations.length > 1) {
      setState(() {
        localPickupLocations.removeAt(index);
      });
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
      ..addAll(localPickupLocations);
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
      body: SingleChildScrollView(
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
                      child:
                          GetBuilder<LocationController>(builder: (controller) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                itemCount: localPickupLocations.length + 1,
                itemBuilder: (context, index) {
                  if (index == localPickupLocations.length) {
                    return localPickupLocations.length <
                            (widget.maxlocaladdress ?? 4)
                        ? GestureDetector(
                            onTap: addPickupLocation,
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
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  )
                                ]),
                              ),
                            ),
                          )
                        : SizedBox.shrink();
                  } else {
                    final location = localPickupLocations[index];
                    return Column(
                      children: [
                        if (index != 0)
                          Container(
                            height: 10,
                            color: Color(0xffF1F1F1),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
                          child: PickupAddress(
                            index: index,
                            location: location,
                            onRemove: () => removePickupLocation(index),
                            canRemove: localPickupLocations.length > 1,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
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
