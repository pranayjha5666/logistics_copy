import 'dart:developer';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logistics/controllers/packers_and_movers_controller.dart';
import 'package:logistics/main.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/screens/DashBoard/Home_Screen/Packers_And_Movers/review_packers_and_movers.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../controllers/location_controller.dart';
import '../../../../../services/route_helper.dart';
import '../../dashboard.dart';
import 'add_items.dart';
import 'moving_details.dart';

class PackersAndMoverPage extends StatefulWidget {
  final int? activeStep;

  const PackersAndMoverPage({super.key, this.activeStep});

  @override
  State<PackersAndMoverPage> createState() => _PackersAndMoverPageState();
}

class _PackersAndMoverPageState extends State<PackersAndMoverPage> {
  // int activeStep = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<PackersAndMoversController>().activeStep = widget.activeStep ?? 0;
    if (Get.find<PackersAndMoversController>().homeitems.isEmpty) {
      Get.find<PackersAndMoversController>().gethomeItems();
    }
  }

  final List<String> stepTitles = ['Moving Details', 'Add Items', 'Review'];

  @override
  void dispose() {
    Get.find<LocationController>().pickupLocations.clear();
    Get.find<LocationController>().dropLocations.clear();
    // Get.find<LocationController>().sendermobileno.clear();
    // Get.find<LocationController>().receivername.clear();
    // Get.find<LocationController>().sendername.clear();
    // Get.find<LocationController>().receivermobileno.clear();
    Get.find<LocationController>().updatedate(null);
    Get.find<LocationController>()
        .pickupLocations
        .add(LocationFormControllers(type: "pickup"));
    Get.find<LocationController>()
        .dropLocations
        .add(LocationFormControllers(type: "drop"));
    Get.find<PackersAndMoversController>().updatehomeitems();
    Get.find<PackersAndMoversController>().updateisPickupLiftAvailable(false);
    Get.find<PackersAndMoversController>().updateisDropLiftAvailable(false);
    Get.find<PackersAndMoversController>().updateselectedOptionIndex(0);
    super.dispose();
  }

  Widget getStepContent(int step) {
    switch (step) {
      case 0:
        return MovingDetails();
      case 1:
        return AddItems();
      case 2:
        return ReviewPackersAndMovers();
      default:
        return Center(
            child: Text("Completed!", style: TextStyle(fontSize: 20)));
    }
  }

  void canpop() {
    if (Get.find<PackersAndMoversController>().activeStep != 0) {
      Get.find<PackersAndMoversController>().previousStep();
    } else {
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   getCustomRoute(child: Dashboard()),
      //   (route) => false,
      // );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        log(didPop.toString());
        if (!didPop) {
          if (Get.find<PackersAndMoversController>().activeStep != 0) {
            Get.find<PackersAndMoversController>().previousStep();
          } else {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => canpop(),
            icon: Icon(Icons.arrow_back, size: 25),
            color: Colors.black,
          ),
          title: Text(
            "Packers & Movers",
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontSize: 17),
          ),
        ),
        body: GetBuilder<PackersAndMoversController>(
          builder: (controller) {
            return Column(
              children: [
                Theme(
                  data: ThemeData(),
                  child: EasyStepper(
                    padding: EdgeInsets.zero,
                    showScrollbar: false,
                    disableScroll: true,
                    finishedStepTextColor: Colors.black,
                    activeStep: controller.activeStep,
                    onStepReached: (index) {
                      if (index <= controller.activeStep) {
                        controller.setActiveStep(index);
                      }
                    },
                    lineStyle: LineStyle(
                      lineLength: MediaQuery.of(context).size.width /
                              stepTitles.length -
                          15,
                      lineType: LineType.dashed,
                      defaultLineColor: Colors.grey,
                      finishedLineColor: primaryColor,
                    ),
                    showStepBorder: false,
                    stepRadius: 12.5,
                    stepShape: StepShape.circle,
                    activeStepBorderColor: primaryColor,
                    activeStepBackgroundColor: Colors.white,
                    activeStepTextColor: primaryColor,
                    finishedStepBackgroundColor: Colors.transparent,
                    finishedStepBorderColor: primaryColor,
                    finishedStepBorderType: BorderType.normal,
                    borderThickness: 3,
                    showLoadingAnimation: false,
                    internalPadding: 0,
                    showTitle: true,
                    steps: List.generate(
                      stepTitles.length,
                      (index) => EasyStep(
                        customStep: controller.activeStep <= index
                            ? controller.activeStep == index
                                ? Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: primaryColor, width: 2),
                                        shape: BoxShape.circle),
                                    child: Icon(Icons.circle,
                                        size: 12.5,
                                        color: index <= controller.activeStep
                                            ? primaryColor
                                            : Colors.grey),
                                  )
                                : Icon(Icons.circle,
                                    size: 12.5,
                                    color: index <= controller.activeStep
                                        ? primaryColor
                                        : Colors.grey)
                            : Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: primaryColor, width: 2),
                                    shape: BoxShape.circle),
                                child: Icon(Icons.check,
                                    size: 16, color: primaryColor),
                              ),
                        customTitle: Text(
                          stepTitles[index],
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: controller.activeStep >= index
                                      ? primaryColor
                                      : Colors.grey),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                        // title: stepTitles[index],

                        // customTitle: Text(stepTitles[index],
                        // maxLines: 2,
                        // textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, bottom: 16.0, right: 16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xffE7FBFF),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Free Home Inspection",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "If you don't want to fill this details.",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            final Uri launchUri =
                                Uri(scheme: 'tel', path: '1234567890');
                            if (await canLaunchUrl(launchUri)) {
                              await launchUrl(launchUri);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Could not launch dialer')),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: primaryColor,
                            ),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.phone_outlined,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Call Now",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, bottom: 16.0, right: 16.0),
                    child: getStepContent(controller.activeStep),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
