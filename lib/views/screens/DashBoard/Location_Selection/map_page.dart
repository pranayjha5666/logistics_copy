import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logistics/controllers/location_controller.dart';
import 'package:logistics/views/base/common_button.dart';
import 'package:logistics/views/screens/DashBoard/Location_Selection/map_search_page.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<LocationController>(
        builder: (controller) {
          return Stack(
            children: [
              GoogleMap(
                onMapCreated: (mapcontrller) =>
                    controller.mapController = mapcontrller,
                initialCameraPosition: CameraPosition(
                  target: controller.selectedLatLng,
                  zoom: 15,
                ),
                onCameraMove: (CameraPosition position) {
                  controller.selectedLatLng = position.target;
                },
                onCameraIdle: () {
                  Get.find<LocationController>()
                      .updateAddressFromLatLng(controller.selectedLatLng);
                },
              ),

              Center(
                child: Icon(
                  Icons.location_pin,
                  size: 50,
                  color: Colors.red,
                ),
              ),

              Positioned(
                top: 40,
                left: 20,
                right: 20,
                child: CustomButton(
                  color: Colors.grey[100],
                  radius: 10,
                  onTap: () async {
                    controller.listOfLocation = [];
                    controller.citynamecontroller.text = "";
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MapSearchPage()),
                    );
                    if (result != null) {
                      double lat = result['lat'];
                      double lng = result['lng'];
                      String address = result['address'];
                      controller.selectedLatLng = LatLng(lat, lng);
                      controller.addressText = address;
                      controller.mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.search,
                        size: 25,
                        color: Colors.green,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Search Destination",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: "Poppins",
                                fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              if (controller.addressText != null)
                Positioned(
                  bottom: 100,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 4),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(controller.addressText!),
                  ),
                ),

              // Confirm Button
              Positioned(
                bottom: 30,
                left: 20,
                right: 50,
                child: CustomButton(
                  onTap: () {
                    Navigator.pop(context, {
                      'lat': controller.selectedLatLng.latitude,
                      'lng': controller.selectedLatLng.longitude,
                      'address': controller.addressText,
                      'city': controller.city,
                      'state': controller.statename,
                      'pincode': controller.pincode,
                    });
                  },
                  title: "Confirm Location",
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
