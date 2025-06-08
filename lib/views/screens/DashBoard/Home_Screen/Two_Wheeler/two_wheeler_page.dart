import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/two_wheeler_controller.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/base/common_button.dart';
import 'package:logistics/views/screens/DashBoard/Components/location_section_widget.dart';
import 'package:logistics/views/screens/DashBoard/Home_Screen/Two_Wheeler/Components/packages_type_row.dart';
import 'package:logistics/views/screens/DashBoard/Home_Screen/Two_Wheeler/Review_two_wheeler/review_two_wheeler_booking.dart';

import '../../../../../controllers/auth_controller.dart';
import '../../../../../controllers/location_controller.dart';
import '../../../../../services/constants.dart';
import 'Components/select_vehicle_type.dart';
import 'Components/tempo_list.dart';

class TwoWheelerPage extends StatefulWidget {
  const TwoWheelerPage({super.key});

  @override
  State<TwoWheelerPage> createState() => _TwoWheelerPageState();
}

class _TwoWheelerPageState extends State<TwoWheelerPage> {

  void submitdelivery() {
    if (Get.find<LocationController>()
                .pickupLocations
                .first
                .addressLineOne
                .text ==
            "" ||
        Get.find<LocationController>()
                .dropLocations
                .first
                .addressLineOne
                .text ==
            "")
      return showCustomToast("Enter Location Details", color: Colors.black);
    else if (Get.find<TwoWheelerController>().selectedType == "") {
      return showCustomToast("Please Select What are you sending?",
          color: Colors.black);
    } else if (Get.find<TwoWheelerController>().parcelvalue.text == "") {
      return showCustomToast("Please Enter Pacel Value?", color: Colors.black);
    } else
      Navigator.push(context, getCustomRoute(child: ReviewTwoWheelerBooking()));
  }

  @override
  void dispose() {
    Get.find<LocationController>().pickupLocations.clear();
    Get.find<LocationController>().dropLocations.clear();
    Get.find<LocationController>().updatedate(null);
    Get.find<LocationController>()
        .pickupLocations
        .add(LocationFormControllers(type: "pickup"));
    Get.find<LocationController>()
        .dropLocations
        .add(LocationFormControllers(type: "drop"));
    Get.find<TwoWheelerController>().toggleSelection("", null);
    Get.find<TwoWheelerController>().parcelvalue.clear();
    Get.find<TwoWheelerController>().promocodecontroller.clear();
    Get.find<TwoWheelerController>().deliveryamount = null;
    Get.find<TwoWheelerController>().updatebike(true);

    super.dispose();
  }

  String twowheelerweight = Get.find<AuthController>()
          .businessSettings
          .firstWhereOrNull((element) =>
              element.key == "two_wheeler_maximum_weight_per_shipment")
          ?.value ??
      "20";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
          ),
          title: Text(
            "Local Bike & Tempo",
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontSize: 17),
          ),
        ),
        body: GetBuilder<TwoWheelerController>(
          builder: (controller) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectVehicleType(),
                    SizedBox(
                      height: 10,
                    ),
                    if (!controller.bike) ...[
                      TempoList(),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                    Container(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: LocationSectionWidget(
                          maxpickupaddress: 1,
                          istwowheeler: true,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Package Details",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(fontWeight: FontWeight.w700, fontSize: 17),
                      ),
                    ),
                    if (controller.bike) ...[
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: primaryColor,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Note : Maximum weight per shipment: ${twowheelerweight} kg",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],

                    PackagesTypeRow(),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: GetBuilder<TwoWheelerController>(
          builder: (controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.error != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Text(
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: Colors.white),
                              controller.error!,
                              maxLines: null,
                            )),
                          ],
                        )),
                  ),
                if (controller.deliveryamount != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GetBuilder<TwoWheelerController>(
                      builder: (controller) {
                        return CustomButton(
                          isLoading: controller.isLoading,
                          onTap: submitdelivery,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Delivery Fee: ₹${controller.deliveryamount}",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ));
  }
}
