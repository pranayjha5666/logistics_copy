import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logistics/controllers/goods_controller.dart';
import 'package:logistics/data/models/response/vehicles_model.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/screens/DashBoard/Home_Screen/Goods/goods_review_screen.dart';

import '../../../../../services/constants.dart';
import '../../../../../services/route_helper.dart';
import '../../../../base/common_button.dart';
import 'Components/goodtypedialogue.dart';

class SelectTruckTypeScreen extends StatefulWidget {
  const SelectTruckTypeScreen({super.key});

  @override
  State<SelectTruckTypeScreen> createState() => _SelectTruckTypeScreenState();
}

class _SelectTruckTypeScreenState extends State<SelectTruckTypeScreen> {
  int selectedOptionIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> data = {"type": "open_truck"};
    Get.find<GoodsController>().fetchVehicles(data);
    Get.find<GoodsController>().getGodsType();
    Get.find<GoodsController>().updateTruckType("open_truck");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffD9D9D9)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Icon(Icons.arrow_back_ios, size: 16),
                )),
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Truck Type",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.w800, fontSize: 19.5),
            ),
            const SizedBox(
              height: 20,
            ),
            GetBuilder<GoodsController>(builder: (GoodsController) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            GoodsController.updateSelectedTruck(null, null);
                            GoodsController.updateSelectedGoodsType(null, null);
                            Map<String, dynamic> data = {"type": "open_truck"};
                            GoodsController.updateTruckType("open_truck");
                            GoodsController.fetchVehicles(data);
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color:
                                      GoodsController.truck_type == "open_truck"
                                          ? const Color(0xff09596F)
                                          : Colors.grey,
                                  width:
                                      GoodsController.truck_type == "open_truck"
                                          ? 2
                                          : 1),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Open Truck",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            GoodsController.updateSelectedTruck(null, null);
                            GoodsController.updateSelectedGoodsType(null, null);

                            GoodsController.updateTruckType("body_pack_truck");
                            Map<String, dynamic> data = {
                              "type": "body_pack_truck"
                            };
                            GoodsController.fetchVehicles(data);
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: GoodsController.truck_type ==
                                          "body_pack_truck"
                                      ? const Color(0xff09596F)
                                      : Colors.grey,
                                  width: GoodsController.truck_type ==
                                          "body_pack_truck"
                                      ? 2
                                      : 1),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Body Pack Containers",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        isDismissible: true,
                        context: context,
                        builder: (context) {
                          return TrcukDetails();
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            GoodsController.selectedTruckName == null
                                ? "Select Truck"
                                : GoodsController.selectedTruckName!,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    color: GoodsController.selectedTruckName ==
                                            null
                                        ? Color(0xff7E7E7E)
                                        : Colors.black,
                                    fontWeight: FontWeight.w700),
                          ),
                          const Icon(
                            Icons.expand_more,
                            color: Color(0xff7E7E7E),
                            size: 25,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Goodtypedialogue();
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              GoodsController.selectedGoodsType == null
                                  ? "Select Goods Type"
                                  : GoodsController.selectedGoodsType!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                      color:
                                          GoodsController.selectedGoodsType ==
                                                  null
                                              ? Color(0xff7E7E7E)
                                              : Colors.black,
                                      fontWeight: FontWeight.w700),
                            ),
                          ),
                          const Icon(
                            Icons.expand_more,
                            color: Color(0xff7E7E7E),
                            size: 25,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            })
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                onTap: () {
                  if (Get.find<GoodsController>().selectedTruckName == null)
                    return showCustomToast("Select TruckName",
                        color: Colors.black);
                  if (Get.find<GoodsController>().selectedGoodsType == null)
                    return showCustomToast("Select GodsType",
                        color: Colors.black);
                  Navigator.push(
                      context, getCustomRoute(child: GoodsReviewScreen()));
                },
                title: 'Next',
              ))
        ],
      ),
    );
  }
}

class TrcukDetails extends StatefulWidget {
  TrcukDetails({super.key});

  @override
  State<TrcukDetails> createState() => _TrcukDetailsState();
}

class _TrcukDetailsState extends State<TrcukDetails> {
  int? selectedIndex;

  final List<VehiclesModel> truckList =
      Get.find<GoodsController>().vehiclesList;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<GoodsController>(builder: (GoodsController) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 3,
                  color: const Color(0xffD9D9D9),
                ),
                const SizedBox(
                  height: 5,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: truckList.length,
                  itemBuilder: (context, index) {
                    var truck = truckList[index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                            GoodsController.updateSelectedTruck(
                                truck.name, truck.id);

                            Future.delayed(const Duration(milliseconds: 200))
                                .then((v) {
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selectedIndex == index
                                  ? primaryColor
                                  : Colors.white,
                            ),
                            padding: const EdgeInsets.only(right: 8),
                            height: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // SvgPicture.asset(
                                //   truck.image,
                                //   height: 38,
                                //   width: 135,
                                // ),
                                Text(
                                  truck.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontSize: 13),
                                ),
                                Text(
                                  "${truck.weight} kg",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (index != truckList.length - 1)
                          const SizedBox(
                            height: 10,
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
