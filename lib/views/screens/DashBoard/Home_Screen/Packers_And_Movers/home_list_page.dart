import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/packers_and_movers_controller.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/screens/DashBoard/Home_Screen/Packers_And_Movers/packers_and_mover_page.dart';

import '../../../../../data/models/response/home_items_model.dart';

class HomeListPage extends StatefulWidget {
  const HomeListPage({super.key});

  @override
  State<HomeListPage> createState() => _HomeListPageState();
}

class _HomeListPageState extends State<HomeListPage> {
  List<HomeItemsModel> homeitems = [];

  Map<String, List<Map<String, dynamic>>> groupedItem = {};

  @override
  void initState() {
    // TODO: implement initState
    Get.find<PackersAndMoversController>().getSelectedItems();
    homeitems = Get.find<PackersAndMoversController>().selectedItems;
    groupedItem = Get.find<PackersAndMoversController>().groupselecteditems;
    super.initState();
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 25),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primaryColor),
              ),
              child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                        context,
                        getCustomRoute(
                            child: PackersAndMoverPage(
                          activeStep: 1,
                        )));
                  },
                  icon: Icon(
                    Icons.edit,
                    size: 20,
                    color: primaryColor,
                  )),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.builder(
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
                          border:
                              Border.all(color: Colors.black.withOpacity(0.2)),
                          // boxShadow: [
                          //   BoxShadow(
                          //       blurRadius: 4,
                          //       offset: Offset(0, 1),
                          //       color: Colors.black.withOpacity(0.2)),
                          // ]
                        ),
                        child: ExpansionTile(
                          initiallyExpanded: true,
                          iconColor: Colors.black,
                          shape: Border(),
                          title: Row(
                            children: [
                              Text(
                                categoryTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          children: [
                            Divider(
                                thickness: 1,
                                height: 1,
                                color: Colors.grey.shade300),
                            for (var i in items)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 20.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        i['title'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(color: Colors.grey[800]),
                                      ),
                                    ),
                                    Text(
                                      "x ${i['quantity']}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ))));
          },
        ),
      ),
    );
  }
}
