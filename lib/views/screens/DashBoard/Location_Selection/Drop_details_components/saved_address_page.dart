import 'package:flutter/material.dart';

import '../Pickup_details_components/saved_address_model_and_list.dart';

class SavedAddressPage extends StatelessWidget {
  const SavedAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
            )),
        title: Text(
          "Saved Address",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Saved Address",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(),
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: savedAddresses.length,
                  itemBuilder: (context, index) {
                    var address = savedAddresses[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, savedAddresses[index]);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey.shade200)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.favorite),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        address.addresstype,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      Text(
                                        "${address.name},${address.phone}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: Colors.grey,
                                            ),
                                      )
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                )
                              ],
                            ),
                            Divider(
                              color: Colors.grey.shade400,
                            ),
                            Text(
                              "Address Line One: ${address.addressLineOne}",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                            Text(
                              address.mapAddress,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<SavedAddress> savedAddresses = [
  SavedAddress(
    addresstype: "Home1",
    mapAddress: "Pokhran Road No. 2, Thane West",
    addressLineOne: "Rustomjee Urbania",
    addressLineTwo: "Tower B, Flat 1204",
    pincode: "400610",
    city: "Thane",
    name: "Ankita Deshmukh",
    phone: "9876543210",
    type: "pickup",
    stateName: "Maharashtra",
    latitude: "19.2183",
    longitude: "72.9781",
    stateId: 27,
  ),
  SavedAddress(
    addresstype: "Home2",
    mapAddress: "Ghodbunder Road, Thane West",
    addressLineOne: "Hiranandani Estate",
    addressLineTwo: "Building Orchid, Flat 403",
    pincode: "400607",
    city: "Thane",
    name: "Rohan Mehta",
    phone: "8888888888",
    type: "drop",
    stateName: "Maharashtra",
    latitude: "19.2508",
    longitude: "72.9636",
    stateId: 27,
  ),
  SavedAddress(
    addresstype: "Office",
    mapAddress: "Majiwada, Eastern Express Highway",
    addressLineOne: "Lodha Paradise",
    addressLineTwo: "Tower 9, Flat 903",
    pincode: "400601",
    city: "Thane",
    name: "Sneha Patil",
    phone: "7777777777",
    type: "pickup",
    stateName: "Maharashtra",
    latitude: "19.2013",
    longitude: "72.9780",
    stateId: 27,
  ),
  SavedAddress(
    addresstype: "Home",
    mapAddress: "Vartak Nagar, Thane West",
    addressLineOne: "Kores Towers",
    addressLineTwo: "Near Sulochana Devi School",
    pincode: "400606",
    city: "Thane",
    name: "Amit Kulkarni",
    phone: "6666666666",
    type: "drop",
    stateName: "Maharashtra",
    latitude: "19.2090",
    longitude: "72.9614",
    stateId: 27,
  ),
];
