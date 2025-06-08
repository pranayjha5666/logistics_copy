import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logistics/data/models/response/goods_type_model.dart';

import '../../../../../../controllers/goods_controller.dart';

class Goodtypedialogue extends StatelessWidget {
  Goodtypedialogue({super.key});
  final List<GoodsTypeModel> goodstypelist =
      Get.find<GoodsController>().goodtypesList;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: goodstypelist.length,
            itemBuilder: (context, index) {
              var type = goodstypelist[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                onTap: () {
                  Get.find<GoodsController>()
                      .updateSelectedGoodsType(type.title,type.id);
                  Navigator.pop(context);
                },
                title: Text(type.title),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                thickness: 1,
                color: Colors.grey,
              );
            },
          ),
        ),
      ),
    );
  }
}
