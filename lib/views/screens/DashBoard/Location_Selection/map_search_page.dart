import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../../controllers/location_controller.dart';
import '../../../../services/input_decoration.dart';
import '../../Shimmer/map_search_shimmer.dart';

class MapSearchPage extends StatelessWidget {
  const MapSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return GetBuilder<LocationController>(builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: TextFormField(
                controller: controller.citynamecontroller,
                onChanged: (value) {
                  controller.onCityNameChanged(value);
                },
                autofocus: true,
                style: Theme.of(context).textTheme.labelLarge,
                decoration: CustomDecoration.inputDecoration(
                    hint: "Search location...",
                    hintStyle: TextStyle(color: Colors.grey),
                    suffix: Icon(Icons.search)),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: controller.isLoading
                ? Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: controller.isLoading
                        ? MapSearchShimmer()
                        : controller.listOfLocation.isEmpty
                            ? Center(child: Text("No locations found"))
                            : ListView.builder(
                                itemCount: controller.listOfLocation.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          ClipOval(
                                            child: Container(
                                              color: Colors.grey[200]
                                                  ?.withOpacity(0.7),
                                              padding: EdgeInsets.all(5),
                                              child: Icon(
                                                Icons.location_on,
                                                color: Colors.grey[600],
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  controller.listOfLocation[
                                                              index][
                                                          'structured_formatting']
                                                      ["main_text"],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),
                                                Text(
                                                  controller.listOfLocation[
                                                              index]
                                                          ['description'] ??
                                                      '',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Poppins",
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                                Divider(
                                                    height: 7,
                                                    color: Colors.grey[400]),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () async {
                                        await controller
                                            .fetchPlaceDetailsById(
                                                controller.listOfLocation[index]
                                                    ['place_id'])
                                            .then((value) {
                                          if (value.isSuccess &&
                                              value.data != null) {
                                            final details = {
                                              'lat': value.data['lat'],
                                              'lng': value.data['lng'],
                                              'address': value.data['address'],
                                            };
                                            log(details.toString(),
                                                name: "Details");
                                            if (context.mounted) {
                                              Navigator.pop(context, details);
                                            }
                                          } else {
                                            log("Failed to fetch place details",
                                                name: "PlaceDetailsError");
                                          }
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                  ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(
                bottom: isKeyboardVisible
                    ? MediaQuery.of(context).viewInsets.bottom
                    : 0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 26.0, top: 16.0, bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await controller.getCurrentLocation();
                            final details = {
                              'lat': controller.selectedLatLng.latitude,
                              'lng': controller.selectedLatLng.longitude,
                              'address': controller.addressText.toString(),
                            };
                            log(details.toString(), name: "Details");
                            Navigator.pop(context, details);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.location_on),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Current Location",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 20,
                          color: Colors.grey[400],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.location_on),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Locate On Map",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
