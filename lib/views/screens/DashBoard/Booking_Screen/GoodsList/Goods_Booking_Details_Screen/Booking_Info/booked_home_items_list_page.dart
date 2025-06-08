import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../controllers/packers_and_movers_controller.dart';
import '../../../../../../../data/models/response/bookingdetails_model.dart';

class HomeItemsListPage extends StatefulWidget {
  final List<BookingGoodHomeItem> homeitems;
  HomeItemsListPage({super.key, required this.homeitems});

  @override
  State<HomeItemsListPage> createState() => _HomeItemsListPageState();
}

class _HomeItemsListPageState extends State<HomeItemsListPage> {
  Map<String, List<Map<String, dynamic>>> groupedItem = {};

  @override
  void initState() {
    super.initState();
    Get.find<PackersAndMoversController>()
        .groupItemsByCategoryName(widget.homeitems);
    groupedItem = Get.find<PackersAndMoversController>().groupedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Home Items",
          style:
              Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 17),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: widget.homeitems.isEmpty
              ? Center(child: Text("No Items Found"))
              : ListView.builder(
                  itemCount: groupedItem.length,
                  itemBuilder: (context, index) {
                    final categoryTitle = groupedItem.keys.elementAt(index);
                    final items = groupedItem.values.elementAt(index);
                    return Theme(
                      data: ThemeData(),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
                                    color: Colors.black.withOpacity(0.2)),
                              ]),
                          child: ExpansionTile(
                            iconColor: Colors.black,
                            initiallyExpanded: index == 0,
                            shape: Border(),
                            title: Text(
                              categoryTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            children: items.map((item) {
                              return Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 20.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['title'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[700]),
                                        ),
                                      ),
                                      Text(
                                        "x ${item['quantity']}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  },
                )),
    );
  }
}
