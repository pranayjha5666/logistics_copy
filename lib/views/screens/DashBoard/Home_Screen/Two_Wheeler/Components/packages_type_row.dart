import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/two_wheeler_controller.dart';

import '../../../../../../services/input_decoration.dart';
import '../../../../../../services/theme.dart';

class PackagesTypeRow extends StatefulWidget {
  const PackagesTypeRow({super.key});

  @override
  State<PackagesTypeRow> createState() => _PackagesTypeRowState();
}

class _PackagesTypeRowState extends State<PackagesTypeRow> {


  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwoWheelerController>(
      builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "What are you sending?",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.grey.shade800, fontSize: 13),
              ),
            ),
            if (controller.selectedType != "")
              GestureDetector(
                onTap: () => controller.toggleSelection("",null),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.selectedType,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.close,
                        size: 17,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                height: 35,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.packagestypeList.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    String text =
                        controller.packagestypeList[index].title.toString();
                    int id=controller.packagestypeList[index].id!;
                    bool isSelected = controller.selectedType == text;
                    return GestureDetector(
                      onTap: () => controller.toggleSelection(text,id),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor : Color(0xffF2F2F2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                        child: Text(text,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                )),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 15),
            TextFormField(
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(overflow: TextOverflow.ellipsis),
              minLines: 1,
              controller: controller.parcelvalue,
              keyboardType: TextInputType.number,
              decoration: CustomDecoration.inputDecoration(
                  label: 'Parcel Value',
                  labelStyle: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Colors.grey[500]),
                  borderRadius: 8,
                  suffix: Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                      "INR",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  )),
            ),
          ],
        );
      },
    );
  }
}
