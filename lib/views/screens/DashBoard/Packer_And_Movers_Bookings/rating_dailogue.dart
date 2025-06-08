import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logistics/services/theme.dart';

import '../../../../generated/assets.dart';
import '../../../../services/input_decoration.dart';
import '../../../base/common_button.dart';

class RatingDialog extends StatefulWidget {
  final Function()? onTap;


  const RatingDialog({
    super.key, this.onTap,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int star = 0;
  bool isStar = false;
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 60, height: 7,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Awesome!'.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              'You rated 4 Star',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            const SizedBox(height: 10),
            const StarRating(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                maxLines: 3,
                decoration: CustomDecoration.inputDecoration(
                  hint: 'Write your comment',
                  bgColor: const Color(0xFFF2F2F2),
                  hintStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: const Color(0xFF949494),
                      ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: CustomButton(
                color: primaryColor,
                onTap: widget.onTap,
                title: 'Submit',
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class StarRating extends StatefulWidget {
  const StarRating({super.key});

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  int selectedStars = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedStars = index + 1;
            });
            log('$selectedStars');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Image.asset(
              index < selectedStars ? Assets.imagesStarFill : Assets.imagesStar,
              width: 35,
              height: 35,
            ),
          ),
        );
      }),
    );
  }
}
