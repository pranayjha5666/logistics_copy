import 'package:flutter/material.dart';
import 'package:logistics/generated/assets.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/views/base/custom_image.dart';
import 'package:logistics/views/screens/DashBoard/Home_Screen/Car&Bike/car_and_bike.dart';
import 'package:logistics/views/screens/DashBoard/Home_Screen/Goods/goods.dart';
import 'package:logistics/views/screens/DashBoard/Home_Screen/Two_Wheeler/Components/select_vehicle_page.dart';
import 'package:logistics/views/screens/DashBoard/Home_Screen/Two_Wheeler/two_wheeler_page.dart';

import '../Packers_And_Movers/packers_and_mover_page.dart';

class MidSection extends StatefulWidget {
  const MidSection({super.key});

  @override
  State<MidSection> createState() => _MidSectionState();
}

class _MidSectionState extends State<MidSection> {
  Widget choosetransporttype({
    required Color bgcolor,
    required String type,
    required String imagepath,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: bgcolor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(child: CustomImage(path: imagepath,),),
            ),
            Text(
              type,
              textAlign: TextAlign.center,
              style:Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins"
              )
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      padding: const EdgeInsets.only(left: 16, right: 16.0, bottom: 16.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, getCustomRoute(child: TwoWheelerPage()));
            // Navigator.push(context, getCustomRoute(child: SelectVehiclePage()));
          },
          child: choosetransporttype(
            bgcolor: const Color(0xffFFE6AD),
            type: "Local Bike & Tempo",
            imagepath: Assets.imagesLocal,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, getCustomRoute(child: Goods()));
          },
          child: choosetransporttype(
            bgcolor: const Color(0xffB9D9FF),
            type: "Tempo Truck Container",
            imagepath: Assets.imagesTruck,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, getCustomRoute(child: PackersAndMoverPage()));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xff0EABB1),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 10,
                  left: 60,
                  bottom: 25,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      Assets.imagesPackerAndMover,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Packers & Movers",
                        textAlign: TextAlign.center,
                        style:Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins"
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),



        GestureDetector(
          onTap: () {
            Navigator.push(context, getCustomRoute(child: CarAndBike()));
          },
          child: choosetransporttype(
            bgcolor: const Color(0xffFFE3BD),
            type: "Car & Bike",
            imagepath: Assets.imagesCarAndBike,
          ),
        ),
      ],
    );
  }
}
