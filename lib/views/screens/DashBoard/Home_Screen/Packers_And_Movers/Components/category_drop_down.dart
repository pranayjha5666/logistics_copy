import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/packers_and_movers_controller.dart';
import 'package:logistics/data/models/response/home_items_model.dart';

import '../../../../../../services/theme.dart';

class CategoryDropdown extends StatefulWidget {
  final String categoryName;
  final List<HomeItemsModel> subCategories;
  final bool initiallyExpanded; // <<--- ADD THIS

  CategoryDropdown({
    required this.categoryName,
    required this.subCategories,
    required this.initiallyExpanded,
  });

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedBackgroundColor: Colors.white,
      initiallyExpanded: widget.initiallyExpanded,
      shape: Border(),
      title: Text(widget.categoryName,
          style: Theme.of(context).textTheme.labelLarge),
      children: [
        ListView.builder(
          itemCount: widget.subCategories.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var i = widget.subCategories[index];
            bool isLast = index == widget.subCategories.length - 1;

            return Container(
                decoration: BoxDecoration(
                  color: Color(0xffF2F2F2),
                  // borderRadius:isLast
                  //     ? BorderRadius.only(
                  //         bottomLeft: Radius.circular(30),
                  //         bottomRight: Radius.circular(30),
                  //       )
                  //     : BorderRadius.zero,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(i.title ?? "Na",
                        style: Theme.of(context).textTheme.labelMedium),
                    SizedBox(
                      width: Get.find<PackersAndMoversController>()
                                  .homeitems
                                  .firstWhere(
                                    (item) => item.id == i.id,
                                    orElse: () => i,
                                  )
                                  .quantity ==
                              0
                          ? 50
                          : 105,
                      child: Get.find<PackersAndMoversController>()
                                  .homeitems
                                  .firstWhere(
                                    (item) => item.id == i.id,
                                    orElse: () => i,
                                  )
                                  .quantity ==
                              0
                          ? GestureDetector(
                              onTap: () =>
                                  Get.find<PackersAndMoversController>()
                                      .updateItemCount(i, true),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: primaryColor,
                                ),
                                width: 30,
                                height: 30,
                                child: Icon(Icons.add, color: Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      Get.find<PackersAndMoversController>()
                                          .updateItemCount(i, false),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: primaryColor,
                                    ),
                                    width: 30,
                                    height: 30,
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    Get.find<PackersAndMoversController>()
                                        .homeitems
                                        .firstWhere(
                                          (item) => item.id == i.id,
                                          orElse: () => i,
                                        )
                                        .quantity
                                        .toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () =>
                                      Get.find<PackersAndMoversController>()
                                          .updateItemCount(i, true),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: primaryColor,
                                    ),
                                    width: 30,
                                    height: 30,
                                    child: Icon(Icons.add, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                    )
                  ],
                ));
          },
        )
      ],
    );
  }
}
