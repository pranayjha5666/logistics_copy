import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/services/extensions.dart';

import '../../../../../controllers/homeservices_controller.dart';
import '../../../../../services/theme.dart';
import '../../../../base/custom_image.dart';
import '../../../../base/shimmer.dart';

class CustomSliderWidget extends StatefulWidget {
  const CustomSliderWidget({
    super.key,
  });

  @override
  State<CustomSliderWidget> createState() => _CustomSliderWidgetState();
}

class _CustomSliderWidgetState extends State<CustomSliderWidget> {
  int _currentPage = 0;

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     Get.find<HomeServiceController>().getSliders();
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeServiceController>(
        builder: (HomeServiceController controller) {
      if (controller.sliders.isEmpty && controller.isLoading) {
        return CustomShimmer(
          isLoading: true,
          child: Container(
            height: 280,
            color: Colors.grey,
          ),
        );
      }

      if (controller.sliders.isEmpty) return const SizedBox.shrink();
      return Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
            items: controller.sliders.map((slider) {
              return Builder(
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Material(
                      elevation: 4, // You can tweak this for more/less shadow
                      borderRadius: BorderRadius.circular(8),
                      shadowColor: Colors.black26,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImage(
                          path: slider.image!.getIfValid,
                          width: double.infinity,
                          fit: BoxFit.fill,
                          radius: 0,
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(controller.sliders.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: _currentPage == index ? 5 : 5,
                  width: _currentPage == index ? 35 : 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    color: _currentPage == index ? primaryColor : Colors.grey,
                  ),
                );
              })
            ],
          ),
        ],
      );
    });
  }
}
