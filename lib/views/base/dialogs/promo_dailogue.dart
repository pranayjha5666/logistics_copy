import 'package:flutter/material.dart';
import 'package:logistics/generated/assets.dart';
import 'package:logistics/services/theme.dart';

class PromoDailogue extends StatefulWidget {
  final String code;
  final String val;
  PromoDailogue({super.key, required this.code, required this.val});

  @override
  State<PromoDailogue> createState() => _PromoDailogueState();
}

class _PromoDailogueState extends State<PromoDailogue> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Dialog(
  //     insetPadding: const EdgeInsets.all(60),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //     elevation: 8,
  //     child: Stack(
  //       clipBehavior: Clip.none,
  //       children: [
  //         Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4),
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   // color: const Color(0xff82d682),
  //                   color: primaryColor,
  //                   borderRadius: const BorderRadius.only(
  //                     topLeft: Radius.circular(20),
  //                     topRight: Radius.circular(20),
  //                   ),
  //                 ),
  //                 padding: const EdgeInsets.symmetric(
  //                     horizontal: 20.0, vertical: 30),
  //                 width: double.infinity,
  //                 child: Column(
  //                   children: [
  //                     Text(
  //                       "\"${widget.code}\" applied!",
  //                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
  //                           fontSize: 12,
  //                           color: Colors.white,
  //                           fontWeight: FontWeight.bold),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     Text(
  //                       "₹ ${widget.val} saved",
  //                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
  //                             color: Colors.white,
  //                             fontSize: 30,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                     ),
  //                     Text(
  //                       "with coupon code",
  //                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
  //                             color: Colors.white,
  //                             fontSize: 20,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             Padding(
  //               padding: const EdgeInsets.all(10),
  //               child: Text(
  //                 "Wohooo! You got BIG savings on this order!",
  //                 textAlign: TextAlign.center,
  //                 style: Theme.of(context).textTheme.labelLarge?.copyWith(
  //                     color: Colors.black, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //           ],
  //         ),
  //         Positioned(
  //           top: -25,
  //           left: 0,
  //           right: 0,
  //           child: Align(
  //             alignment: Alignment.topCenter,
  //             child: Container(
  //               width: 50,
  //               height: 50,
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 // border: Border.all(color: primaryColor),
  //                 // color: Color(0xff006400),
  //                 color: Colors.white,
  //               ),
  //               child: const Center(
  //                   child: Text("🎉", style: TextStyle(fontSize: 24))),
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           top: 0,
  //           left: 50,
  //           right: 50,
  //           child: Align(
  //             alignment: Alignment.topCenter,
  //             child: Image.asset(
  //               Assets.imagesPromoGif,
  //             ),
  //           ),
  //         ),
  //         // Positioned(
  //         //   top: -30,
  //         //   right: 5,
  //         //   child: GestureDetector(
  //         //     onTap: () {
  //         //       Navigator.pop(context);
  //         //     },
  //         //     child: Container(
  //         //       decoration: BoxDecoration(
  //         //         shape: BoxShape.circle,
  //         //         color: Colors.white,
  //         //         boxShadow: [
  //         //           BoxShadow(
  //         //             color: Colors.black12,
  //         //             blurRadius: 4,
  //         //           ),
  //         //         ],
  //         //       ),
  //         //       padding: const EdgeInsets.all(4),
  //         //       child: const Icon(Icons.close, size: 20),
  //         //     ),
  //         //   ),
  //         // ),
  //         Positioned(
  //           top: 10,
  //           right: 10,
  //           child: GestureDetector(
  //             onTap: () {
  //               Navigator.pop(context);
  //             },
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 color: Colors.white,
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black12,
  //                     blurRadius: 4,
  //                   ),
  //                 ],
  //               ),
  //               padding: const EdgeInsets.all(4),
  //               child: const Icon(Icons.close, size: 20),
  //             ),
  //           ),
  //         ),
  //
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Dialog(
          insetPadding: const EdgeInsets.all(60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 30),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            "\"${widget.code}\" applied!",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "₹ ${widget.val} saved",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            "with coupon code",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Wohooo! You got BIG savings on this order!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              Positioned(
                top: -25,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Center(
                        child: Text("🎉", style: TextStyle(fontSize: 24))),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 50,
                right: 50,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    Assets.imagesPromoGif,
                  ),
                ),
              ),
            ],
          ),
        ),
        // CLOSE BUTTON OUTSIDE THE DIALOG
        Positioned(
          top: MediaQuery.of(context).size.height * 0.33,
          right: MediaQuery.of(context).size.width * 0.13,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.close, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}
