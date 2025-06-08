import 'package:flutter/material.dart';
import 'package:logistics/views/screens/DashBoard/Location_Selection/Pickup_details_components/recent_address_model_and_list.dart';
import '../../../../../controllers/location_controller.dart';
import '../Components/change_location_dailogue.dart';

class RecentAddressSection extends StatefulWidget {
  final List<RecentAddress> recentaddress;
  final List<LocationFormControllers> locallocation;
  final Function(int) onAddressSelected;

  const RecentAddressSection({
    super.key,
    required this.recentaddress,
    required this.locallocation,
    required this.onAddressSelected,
  });

  @override
  State<RecentAddressSection> createState() => _RecentAddressSectionState();
}

class _RecentAddressSectionState extends State<RecentAddressSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Drops",
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: Colors.grey.shade400),
          ),
          SizedBox(
            height: 15,
          ),
          ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey,
              );
            },
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.recentaddress.length,
            itemBuilder: (context, index) {
              var address = widget.recentaddress[index];
              return InkWell(
                onTap: () async {
                  final location = widget.locallocation.last;

                  // Check if the mapaddress text is not empty
                  if (location.mapaddress.text.isNotEmpty) {
                    // Show confirmation dialog and await the result
                    bool res = await showConfirmationDialog(context);
                    if (res) {
                      _updateAddress(location, address);
                      widget.onAddressSelected(index);
                    }
                  } else {
                    _updateAddress(location, address);
                    widget.onAddressSelected(index);
                  }
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.timer_outlined, color: Colors.black12),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(address.city + address.pincode),
                            Text(address.mapAddress),
                            Text("${address.name} . ${address.phone}")
                          ],
                        ),
                      ),
                      Icon(Icons.favorite_outline),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<bool> showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return ChangeLocationDailogue();
          },
        ) ??
        false;
  }

  void _updateAddress(LocationFormControllers location, RecentAddress address) {
    location.mapaddress.text = address.mapAddress;
    location.addressLineOne.text = address.addressLineOne;
    location.addressLineTwo.text = address.addressLineTwo;
    location.pincode.text = address.pincode;
    location.city.text = address.city;
    location.name.text = address.name;
    location.phone.text = address.phone;
    location.latitude = address.latitude;
    location.longitude = address.longitude;
    location.stateName = address.stateName;
    location.stateId = address.stateId;
  }
}
