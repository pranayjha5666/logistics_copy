import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/two_wheeler_controller.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/base/common_button.dart';
import '../../../../../../controllers/auth_controller.dart';
import '../../../../../../controllers/location_controller.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../base/custom_image.dart';
import '../../../../business_setting/html_widget_screen.dart';
import 'Components/conformation_dailogue.dart';
import 'Components/promo_code_section.dart';
import 'Components/two_wheeler_payment_mode.dart';
import 'Components/two_wheeler_payment_summary.dart';

class ReviewTwoWheelerBooking extends StatefulWidget {
  const ReviewTwoWheelerBooking({super.key});

  @override
  State<ReviewTwoWheelerBooking> createState() =>
      _ReviewTwoWheelerBookingsState();
}

class _ReviewTwoWheelerBookingsState extends State<ReviewTwoWheelerBooking> {
  String twowheelerweight = Get.find<AuthController>()
          .businessSettings
          .firstWhereOrNull((element) =>
              element.key == "two_wheeler_maximum_weight_per_shipment")
          ?.value ??
      "20";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (context) {
        Get.find<TwoWheelerController>().updatepromocodeval();
        Get.find<TwoWheelerController>().updatepaymentmode(false);
        Get.find<TwoWheelerController>().promocodecontroller.clear();
      },
      child: GetBuilder<TwoWheelerController>(
        builder: (controller) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  surfaceTintColor: Colors.white,
                  backgroundColor: Colors.white,
                  shadowColor: Colors.white,
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
                body: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Bike Section
                        Container(
                          color: const Color(0xffF4F9FE),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (controller.bike)
                                      Image.asset(
                                        Assets.imagesCharacter,
                                        height: 70,
                                        width: 70,
                                      )
                                    else
                                      Image.asset(
                                        Assets.imagesTempo,
                                        height: 70,
                                        width: 70,
                                      ),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          controller.bike ? "Bike" : "Tempo",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        Text(
                                          controller.bike
                                              ? twowheelerweight
                                              : controller.tempotypeweight ??
                                                  "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 95,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    color: Color(0xff019539),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.local_shipping,
                                            color: Colors.white, size: 12),
                                        const SizedBox(width: 6),
                                        Text(
                                          "2 Min Away",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        PromoCodeSection(),
                        SizedBox(height: 15),
                        TwoWheelerPaymentSummary(),
                        SizedBox(height: 15),
                        TwoWheelerPaymentMode(),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: controller.isLoading
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text:
                                    'By tapping next you\'re creating booking order and accepting our  ',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontWeight: FontWeight.normal),
                                children: [
                                  TextSpan(
                                    text: 'Booking policy.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                          fontWeight: FontWeight.normal,
                                          color: primaryColor,
                                          decoration: TextDecoration.underline,
                                        ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            getCustomRoute(
                                                child: HtmlWidgetPage(
                                              title: 'Booking policy',
                                              htmlContent: Get.find<
                                                          AuthController>()
                                                      .businessSettings
                                                      .firstWhereOrNull((element) =>
                                                          element.key ==
                                                          "two_wheeler_booking_policy")
                                                      ?.value ??
                                                  "",
                                            )));
                                      },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            CustomButton(
                              onTap: () async {
                                Map<String, dynamic> data = {
                                  // "pickup_user_name":
                                  //     Get.find<LocationController>()
                                  //         .sendername
                                  //         .text,
                                  // "pickup_user_phone":
                                  //     Get.find<LocationController>()
                                  //         .sendermobileno
                                  //         .text,
                                  // "drop_user_name":
                                  //     Get.find<LocationController>()
                                  //         .receivername
                                  //         .text,
                                  // "drop_user_phone":
                                  //     Get.find<LocationController>()
                                  //         .receivermobileno
                                  //         .text,
                                  "delivery_amount":
                                      Get.find<TwoWheelerController>()
                                          .deliveryamount,
                                  "delivery_amount_for_driver":
                                      Get.find<TwoWheelerController>()
                                          .deliveryamountfordriver,
                                  "two_wheeler_package_type_id":
                                      Get.find<TwoWheelerController>()
                                          .selectedType_id,
                                  "parcel_value":
                                      Get.find<TwoWheelerController>()
                                          .parcelvalue
                                          .text,
                                  "locations": [
                                    ...convertLocationControllersToJson(
                                      Get.find<LocationController>()
                                          .pickupLocations,
                                    ),
                                    ...convertLocationControllersToJson(
                                      Get.find<LocationController>()
                                          .dropLocations,
                                    ),
                                  ],
                                  "booking_type":
                                      controller.bike ? "two_wheeler" : "truck",
                                  if (!controller.bike)
                                    "two_wheeler_truck_id":
                                        controller.tempotypeid,
                                  if (Get.find<TwoWheelerController>()
                                          .promocodedata !=
                                      null)
                                    "promo_code":
                                        Get.find<TwoWheelerController>()
                                            .promocodedata!
                                            .title
                                  else
                                    "promo_code": null,
                                };
                                log(data.toString(), name: "Send Data to APi");
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConformationDailogue(
                                      data: data,
                                    );
                                  },
                                );
                              },
                              title: "Book",
                            ),
                          ],
                        ),
                      ),
              ),

              /// Fullscreen Loading Overlay
              if (controller.isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> convertLocationControllersToJson(
      List<LocationFormControllers> locations) {
    return locations.map((address) {
      final data = address.toModel().toJson();
      if (Get.find<TwoWheelerController>().paymentmode)
        data["take_payment"] = "no";
      else {
        if (address.addressLineOne.text ==
            Get.find<TwoWheelerController>().paymentaddress) {
          data["take_payment"] = "yes";
        } else {
          data["take_payment"] = "no";
        }
      }

      return data;
    }).toList();
  }

  void clearfield() {
    Get.find<LocationController>().pickupLocations.clear();
    Get.find<LocationController>().dropLocations.clear();
    // Get.find<LocationController>().sendermobileno.clear();
    // Get.find<LocationController>().receivername.clear();
    // Get.find<LocationController>().sendername.clear();
    // Get.find<LocationController>().receivermobileno.clear();
    Get.find<LocationController>()
        .pickupLocations
        .add(LocationFormControllers(type: "pickup"));
    Get.find<LocationController>()
        .dropLocations
        .add(LocationFormControllers(type: "drop"));
    Get.find<LocationController>().updatedate(null);
    Get.find<TwoWheelerController>().toggleSelection("", null);
    Get.find<TwoWheelerController>().parcelvalue.clear();
    Get.find<TwoWheelerController>().promocodecontroller.clear();
    Get.find<TwoWheelerController>().deliveryamount = null;
    Get.find<TwoWheelerController>().updatepaymentmode(false);
    Get.find<TwoWheelerController>().updatepromocodeval();
  }
}
