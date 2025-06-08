import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/two_wheeler_booking_controller.dart';
import 'package:logistics/services/theme.dart';

class AddressSection extends StatefulWidget {
  const AddressSection({super.key});

  @override
  State<AddressSection> createState() => _AddressSectionState();
}

class _AddressSectionState extends State<AddressSection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwoWheelerBookingController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Pickup & Drop off",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
            Divider(height: 0, color: Colors.grey[300]),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount:
                  controller.twowheelerbookingdetailsModel!.locations!.length,
              itemBuilder: (context, index) {
                var val =
                    controller.twowheelerbookingdetailsModel!.locations![index];
                bool isExpanded = controller.expandedStates[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 16.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      controller.expandedpickupdrop(index);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            val.type == "pickup" ? "Pickup" : "Drop",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                val.addressLineOne ?? "Na",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              if (isExpanded) ...[
                                const SizedBox(height: 4),
                                Text(
                                  val.name,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                Text(
                                  val.phone,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ]
                            ],
                          ),
                        ),
                        Icon(
                          controller.twowheelerbookingdetailsModel!
                                      .locations![index].status ==
                                  "done"
                              ? Icons.check
                              : isExpanded
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }
}
