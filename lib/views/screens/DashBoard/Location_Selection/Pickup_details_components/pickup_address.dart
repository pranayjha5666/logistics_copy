import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../controllers/auth_controller.dart';
import '../../../../../controllers/location_controller.dart';
import '../../../../../services/input_decoration.dart';
import '../Components/select_state_dailogue.dart';
import '../map_page.dart';

class PickupAddress extends StatelessWidget {
  final int index;
  final LocationFormControllers location;
  final VoidCallback onRemove;
  final bool canRemove;
  const PickupAddress(
      {super.key,
      required this.index,
      required this.location,
      required this.onRemove,
      required this.canRemove});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (controller) {
        return Column(
          children: [
            Row(
              children: [
                Text('Pickup Location ${index + 1}',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const Spacer(),
                if (canRemove)
                  GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: const Color(0xffCF0012),
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline,
                              size: 16, color: Colors.white),
                          SizedBox(width: 4),
                          Text("Delete",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  )
              ],
            ),
            const SizedBox(height: 15),
            TextFormField(
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(overflow: TextOverflow.ellipsis),
              maxLines: 2,
              minLines: 1,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MapPage()),
                );
                if (result != null) {
                  location.mapaddress.text = result['address'];
                  location.latitude = result['lat'].toString();
                  location.longitude = result['lng'].toString();
                  location.stateName = result['state'].toString();
                  final matchedState =
                      Get.find<AuthController>().stateList.firstWhereOrNull(
                            (state) => state['name'] == location.stateName,
                          );

                  if (matchedState != null) {
                    location.stateId = matchedState['id'];
                  }
                  log(location.stateId.toString(), name: "StateId");
                  log(location.stateName.toString(), name: "StateName");
                  location.city.text = result['city'].toString();
                  location.pincode.text = result['pincode'].toString();
                  controller.updatePickupLocation(index);

                }
              },
              readOnly: true,
              validator: (value) =>
                  value!.isEmpty ? "Select Map Location" : null,
              controller: location.mapaddress,
              decoration: CustomDecoration.inputDecoration(
                borderRadius: 8,
                label: 'Select Map Location',
                labelStyle: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Colors.grey[500]),
                // hintStyle: TextStyle(color: Colors.black45),
                suffix: Icon(Icons.location_on_outlined),
              ),
            ),
            if (location.mapaddress.text.isNotEmpty) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: Theme.of(context).textTheme.labelLarge,
                      validator: (value) =>
                          value!.isEmpty ? "Enter Sender Name" : null,
                      controller: location.name,
                      decoration: CustomDecoration.inputDecoration(
                          borderRadius: 8,
                          label: "Sender Name",
                          labelStyle: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: Colors.grey[500])),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      style: Theme.of(context).textTheme.labelLarge,
                      validator: (value) => value!.isEmpty || value.length != 10
                          ? "Enter Sender Mobile No"
                          : null,
                      controller: location.phone,
                      keyboardType: TextInputType.number,
                      decoration: CustomDecoration.inputDecoration(
                          borderRadius: 8,
                          label: 'Mobile Phone',
                          labelStyle: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: Colors.grey[500])),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10)
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(overflow: TextOverflow.ellipsis),
                maxLines: null,
                minLines: 1,
                validator: (value) =>
                    value!.isEmpty ? "Enter Adress Line 1" : null,
                controller: location.addressLineOne,
                decoration: CustomDecoration.inputDecoration(
                    borderRadius: 8,
                    label: 'Address Line 1',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.grey[500])),
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(overflow: TextOverflow.ellipsis),
                maxLines: null,
                minLines: 1,
                controller: location.addressLineTwo,
                decoration: CustomDecoration.inputDecoration(
                    borderRadius: 8,
                    label: 'Address Line 2 (Optional)',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.grey[500])),
              ),
              const SizedBox(height: 20),
              FormField(
                validator: (value) {
                  if (location.stateName == null ||
                      location.stateName!.isEmpty) {
                    return 'Select State';
                  }
                  return null;
                },
                builder: (FormFieldState field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          List<dynamic> allStates =
                              Get.find<AuthController>().stateList;
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus &&
                              currentFocus.focusedChild != null) {
                            currentFocus.focusedChild!.unfocus();
                          }
                          showDialog(
                            context: context,
                            builder: (_) => SelectStateDialogue(
                              allStates: allStates,
                              onStateSelected: (selectedState) {
                                // setState(() {
                                //
                                // });

                                location.stateName = selectedState['name'];
                                location.stateId = selectedState['id'];
                                field.didChange(selectedState['name']);
                              },
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    field.hasError ? Colors.red : Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(location.stateName ?? "Select State",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                          color: location.stateName != null
                                              ? Colors.black
                                              : Colors.grey[500])),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0, left: 12),
                          child: Text(
                            field.errorText ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: Colors.red),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: Theme.of(context).textTheme.labelLarge,
                      validator: (value) =>
                          value!.isEmpty ? "Enter City Name" : null,
                      controller: location.city,
                      decoration: CustomDecoration.inputDecoration(
                          borderRadius: 8,
                          label: "City Name",
                          labelStyle: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: Colors.grey[500])),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      style: Theme.of(context).textTheme.labelLarge,
                      validator: (value) =>
                          value!.isEmpty ? "Enter Pincode" : null,
                      controller: location.pincode,
                      keyboardType: TextInputType.number,
                      decoration: CustomDecoration.inputDecoration(
                          borderRadius: 8,
                          label: 'Pincode No',
                          labelStyle: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: Colors.grey[500])),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6)
                      ],
                    ),
                  ),
                ],
              ),
            ]
          ],
        );
      },
    );
  }
}
