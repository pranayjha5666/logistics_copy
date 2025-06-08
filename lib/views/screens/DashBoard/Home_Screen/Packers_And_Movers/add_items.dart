import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/packers_and_movers_controller.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/base/common_button.dart';
import 'Components/category_drop_down.dart';

class AddItems extends StatefulWidget {
  const AddItems({super.key});

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<PackersAndMoversController>(
              builder: (controller) {
                return Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(height: 5),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.grouped.length,
                      itemBuilder: (context, index) {
                        final category = controller.grouped[index];
                        return CategoryDropdown(
                          categoryName: category.categoryName,
                          subCategories: category.items,
                          initiallyExpanded: index==0,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          CustomButton(
            onTap: () {

              Get.find<PackersAndMoversController>().nextStep();



              // Get.find<PackersAndMoversController>().getSelectedItems();
              // if (Get.find<PackersAndMoversController>()
              //     .selectedItems
              //     .isNotEmpty) {
              //   Get.find<PackersAndMoversController>().nextStep();
              // } else {
              //   Fluttertoast.showToast(msg: "Please Select Atleast 1 Items");
              // }
            },
            title: 'Next',
          ),

        ],
      ),
    );
  }
}
