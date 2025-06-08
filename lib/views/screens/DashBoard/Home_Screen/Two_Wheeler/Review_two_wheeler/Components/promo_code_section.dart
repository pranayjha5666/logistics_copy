import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/services/constants.dart';
import 'package:logistics/views/base/dialogs/promo_dailogue.dart';

import '../../../../../../../controllers/two_wheeler_controller.dart';
import '../../../../../../../services/input_decoration.dart';
import '../../../../../../../services/theme.dart';

class PromoCodeSection extends StatefulWidget {
  const PromoCodeSection({super.key});

  @override
  State<PromoCodeSection> createState() => _PromoCodeSectionState();
}

class _PromoCodeSectionState extends State<PromoCodeSection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwoWheelerController>(
      builder: (controller) {
        return TextFormField(
          onChanged: (value) {
            log(value);
            if (controller.ispromocodeapplied)
              controller.updatepromocodeapplied(false);
            log(controller.ispromocodeapplied.toString());
          },
          controller: controller.promocodecontroller,
          style: Theme.of(context).textTheme.labelLarge,
          decoration: CustomDecoration.inputDecoration(
              label: "Promo Code",
              borderColor: Colors.grey.shade400,
              borderRadius: 8,
              labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.grey[500], fontWeight: FontWeight.w600),
              hintStyle: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Colors.grey[500]),
              suffix: Padding(
                padding: const EdgeInsets.all(14.0),
                child: controller.ispromocodeapplied
                    ? Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                      ),
                    ],
                  ),

                  child: Icon(Icons.check,
                  color: Colors.white,size: 15,),
                    )
                    : GestureDetector(
                        onTap: () async {
                          var data = {
                            "promo_code": controller.promocodecontroller.text
                          };
                          await controller.verifypromocode(data).then(
                            (value) {
                              if (value.isSuccess) {
                                controller.updatepromocodeapplied(true);
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus &&
                                    currentFocus.focusedChild != null) {
                                  currentFocus.focusedChild!.unfocus();
                                }
                                showGeneralDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  barrierLabel: '',
                                  transitionDuration:
                                      const Duration(milliseconds: 600),
                                  pageBuilder: (context, anim1, anim2) {
                                    return const SizedBox.shrink();
                                  },
                                  transitionBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin:
                                            const Offset(0, 1), // From bottom
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.ease,
                                      )),
                                      child: Center(
                                          child: PromoDailogue(
                                        code:
                                            controller.promocodecontroller.text,
                                        val: controller.promocodeval.toString(),
                                      )),
                                    );
                                  },
                                );
                              } else {
                                showCustomToast("Invalid PromoCode",
                                    color: Colors.black);
                              }
                            },
                          );
                        },
                        child: Text(
                          "Apply",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor),
                        ),
                      ),
              )),
        );
      },
    );
  }
}
