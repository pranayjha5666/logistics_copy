import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../../controllers/location_controller.dart';
import '../../../../services/constants.dart';
import '../../../../services/route_helper.dart';
import '../../../../services/theme.dart';
import '../Location_Selection/drop_details.dart';
import '../Location_Selection/pick_up_details.dart';

class LocationSectionWidget extends StatefulWidget {
  final int? maxpickupaddress;
  final int? maxdropaddress;
  final bool? istwowheeler;
  final bool? iscarandbike;

  LocationSectionWidget(
      {super.key,
      this.maxpickupaddress,
      this.maxdropaddress,
      this.istwowheeler,
      this.iscarandbike});

  @override
  State<LocationSectionWidget> createState() => _LocationSectionWidgetState();
}

class _LocationSectionWidgetState extends State<LocationSectionWidget> {
  String _shorten(String name) {
    if (name.length <= 10) return name;
    return name.substring(0, 10) + "...";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (controller) {
        final allLocations = [
          ...controller.pickupLocations.map((e) => {
                "address": e.addressLineOne.text.trim(),
                "name": e.name.text.trim(),
                "phone": e.phone.text.trim(),
                "isPickUp": true,
              }),
          ...controller.dropLocations.map((e) => {
                "address": e.addressLineOne.text.trim(),
                "name": e.name.text.trim(),
                "phone": e.phone.text.trim(),
                "isPickUp": false,
              }),
        ];

        int pickupCounter = 0;
        int dropCounter = 0;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: allLocations.length,
          itemBuilder: (context, index) {
            bool isFirst = index == 0;
            bool isLast = index == allLocations.length - 1;
            var step = allLocations[index];
            bool isPickup = step["isPickUp"] == true;

            if (allLocations[index]["isPickUp"] == true) {
              pickupCounter++;
            } else {
              dropCounter++;
            }

            bool isFirstDrop = !isPickup && dropCounter == 1;

            bool pickupadresslineoneisnotempty =
                controller.pickupLocations.first.addressLineOne.text.isNotEmpty;
            bool dropadresslineoneisnotempty =
                controller.dropLocations.first.addressLineOne.text.isNotEmpty;

            return InkWell(
              onTap: () {
                if (isFirst || isFirstDrop) if (isPickup) {
                  Navigator.push(
                    context,
                    getCustomRoute(
                        child: PickUpDetailsPage(
                      maxlocaladdress: widget.maxpickupaddress,
                      istwowheeler: widget.istwowheeler,
                      iscarandbike: widget.iscarandbike,
                    )),
                  );
                } else {
                  Navigator.push(
                    context,
                    getCustomRoute(
                        child: DropDetails(
                      maxlocaladdress: widget.maxdropaddress,
                      istwowheeler: widget.istwowheeler,
                    )),
                  );
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Location timeline part
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: pickupadresslineoneisnotempty &&
                                    dropadresslineoneisnotempty
                                ? 5
                                : 0),
                        child: Container(
                          // margin: const EdgeInsets.only(top: 4),
                          margin: EdgeInsets.only(
                              top: !pickupadresslineoneisnotempty ||
                                      !dropadresslineoneisnotempty
                                  ? 8
                                  : 2.5),
                          width: isFirst || isLast ? 40 : 20,
                          height: isFirst || isLast ? 30 : 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isPickup
                                ? const Color(0xFF00C060)
                                : const Color(0xFFEB0404),
                          ),
                          child: Icon(
                            isFirst || isLast
                                ? Icons.location_on
                                : Icons.circle,
                            color: Colors.white,
                            size: isFirst || isLast ? 16.5 : 10,
                          ),
                        ),
                      ),
                      if (!isLast)
                        controller.pickupLocations.length > 1 ||
                                controller.dropLocations.length > 1
                            ? SizedBox(
                                width: 40,
                                height: 35,
                                child: DottedBorder(
                                  strokeWidth: 2,
                                  dashPattern: const [5, 5],
                                  color: Colors.grey,
                                  customPath: (size) {
                                    return Path()
                                      ..moveTo(size.width / 2, 4)
                                      ..lineTo(size.width / 2, 50);
                                  },
                                  child: const SizedBox.shrink(),
                                ),
                              )
                            : SizedBox(
                                width: 40,
                                height: 20,
                              )
                    ],
                  ),
                  const SizedBox(width: 14),

                  // Location address details part
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (step["address"] != null &&
                            step["address"].toString().isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: isFirst ? 10.0 : 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style:
                                          const TextStyle(color: Colors.black),
                                      children: [
                                        if (isPickup &&
                                            controller
                                                .pickaddressList.isNotEmpty)
                                          TextSpan(
                                            text: "Pick up $pickupCounter    ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium
                                                ?.copyWith(
                                                    color:
                                                        const Color(0xff787878),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                          ),
                                        if (!isPickup &&
                                            controller
                                                .dropaddressList.isNotEmpty)
                                          TextSpan(
                                            text: "Drop off $dropCounter    ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium
                                                ?.copyWith(
                                                    color:
                                                        const Color(0xff787878),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                          ),
                                        TextSpan(
                                          text:
                                              "${_shorten(step["name"].toString())}   ${step["phone"]}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                color: const Color(0xff787878),
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (isFirst || isFirstDrop)
                                  InkWell(
                                    onTap: () {
                                      if (isPickup) {
                                        Navigator.push(
                                          context,
                                          getCustomRoute(
                                              child: PickUpDetailsPage(
                                                  maxlocaladdress:
                                                      widget.maxpickupaddress,
                                                  istwowheeler:
                                                      widget.istwowheeler,
                                                iscarandbike: widget.iscarandbike,
                                              )),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          getCustomRoute(
                                              child: DropDetails(
                                            maxlocaladdress:
                                                widget.maxdropaddress,
                                            istwowheeler: widget.istwowheeler,
                                          )),
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              color: primaryColor,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isPickup)
                              if (!pickupadresslineoneisnotempty)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      getCustomRoute(
                                          child: PickUpDetailsPage(
                                        maxlocaladdress:
                                            widget.maxpickupaddress,
                                        istwowheeler: widget.istwowheeler,
                                            iscarandbike: widget.iscarandbike,

                                          )),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 16),
                                    // margin:
                                    //     EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Select pick up location",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              else
                                Text(
                                  step["address"].toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                            if (!isPickup)
                              if (controller.dropLocations.first.addressLineOne
                                  .text.isEmpty)
                                GestureDetector(
                                  onTap: () {
                                    pickupadresslineoneisnotempty
                                        ? Navigator.push(
                                            context,
                                            getCustomRoute(
                                                child: DropDetails(
                                              maxlocaladdress:
                                                  widget.maxdropaddress,
                                              istwowheeler: widget.istwowheeler,
                                            )),
                                          )
                                        : showCustomToast(
                                            "Enter Pickup Details",
                                            color: Colors.black);
                                    ;
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 16),
                                    // margin:
                                    //     EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                        color: pickupadresslineoneisnotempty
                                            ? primaryColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.grey)),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Select drop location",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                  color:
                                                      pickupadresslineoneisnotempty
                                                          ? Colors.white
                                                          : Colors.black,
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.add_circle_outline,
                                          color: !pickupadresslineoneisnotempty
                                              ? Colors.black
                                              : Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              else
                                Text(
                                  step["address"].toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                          ],
                        ),
                        if (index != allLocations.length - 1)
                          Divider(
                            color: Color(0xffE4E4E4),
                            thickness: 1,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
