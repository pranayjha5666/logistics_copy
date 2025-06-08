import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/base/common_button.dart';
import 'package:logistics/views/screens/DashBoard/dashboard.dart';

import '../../../../../generated/assets.dart';
import '../../Booking_Screen/GoodsList/Goods_Placed_Screen/goods_placed_screen.dart';
import '../../Packer_And_Movers_Bookings/Packer_And_Mover_Placed_Screen/pacers_and_mover_placed_screen.dart';
import '../../Packer_And_Movers_Bookings/packer_and_mover_bookings.dart';

// class BookingPlacedPage extends StatefulWidget {
//   final bool? ispakerandmover;
//
//   const BookingPlacedPage({Key? key, this.ispakerandmover}) : super(key: key);
//
//   @override
//   State<BookingPlacedPage> createState() => _BookingPlacedPageState();
// }
//
// class _BookingPlacedPageState extends State<BookingPlacedPage> {
//   bool _showSuccess = true;
//   late Timer _hideImageTimer;
//   late Timer _countdownTimer;
//   late Timer _navigationTimer;
//
//   int _remainingTime = 15 * 60;
//   double _progress = 1.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _hideImageTimer = Timer(const Duration(seconds: 3), () {
//       setState(() {
//         _showSuccess = false;
//       });
//
//       _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//         if (_remainingTime > 0) {
//           setState(() {
//             _remainingTime--;
//             _progress = _remainingTime / (15 * 60);
//           });
//         } else {
//           timer.cancel();
//         }
//       });
//       _navigationTimer = Timer(const Duration(minutes: 15), () {
//         if (mounted) {
//           _navigateToNextScreen();
//         }
//       });
//     });
//   }
//
//   void _navigateToNextScreen() {
//     Navigator.pushAndRemoveUntil(
//       context,
//       getCustomRoute(child: PackerAndMoverBookings()),
//       (route) => false,
//     );
//   }
//
//   @override
//   void dispose() {
//     _hideImageTimer.cancel();
//     _countdownTimer.cancel();
//     _navigationTimer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvoked: (didPop) {
//         Navigator.pushAndRemoveUntil(
//           context,
//           getCustomRoute(child: Dashboard()),
//           (route) => false,
//         );
//       },
//       child: Scaffold(
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 if (_showSuccess)
//                   Image.asset(
//                     Assets.imagesSucessGif,
//                     width: 200,
//                     height: 200,
//                   ),
//                 if (!_showSuccess)
//                   Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       SizedBox(
//                         width: 120,
//                         height: 120,
//                         child: CircularProgressIndicator(
//                           value: _progress,
//                           strokeWidth: 10,
//                           backgroundColor: Colors.white,
//                           valueColor:
//                               AlwaysStoppedAnimation<Color>(primaryColor),
//                         ),
//                       ),
//                       Text(
//                         "${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}",
//                         style: const TextStyle(
//                             fontSize: 22, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 SizedBox(
//                   height: 25,
//                 ),
//                 Text(
//                   _showSuccess ? "Booking Placed!" : "Wait 15 Min",
//                   style: Theme.of(context).textTheme.displayLarge,
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "Your booking has been placed. Our team will contact you soon.",
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context)
//                       .textTheme
//                       .displaySmall
//                       ?.copyWith(fontSize: 18.0, color: Colors.black87),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (!_showSuccess)
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: CustomButton(
//                   onTap: () {
//                     Navigator.pushAndRemoveUntil(
//                       context,
//                       getCustomRoute(
//                           child: Dashboard(
//                         initialIndex: 1,
//                       )),
//                       (route) => false,
//                     );
//                   },
//                   title: "Okay",
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logistics/services/route_helper.dart';
import '../../../../../generated/assets.dart';

class BookingPlacedPage extends StatefulWidget {
  final int id;
  final double lat;
  final double lng;
  final DateTime date;
  final bool? ispakerandmover;

  const BookingPlacedPage(
      {Key? key,
      this.ispakerandmover,
      required this.id,
      required this.lat,
      required this.lng,
      required this.date})
      : super(key: key);

  @override
  State<BookingPlacedPage> createState() => _BookingPlacedPageState();
}

class _BookingPlacedPageState extends State<BookingPlacedPage> {
  @override
  void initState() {
    super.initState();
    // Navigate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        if(widget.ispakerandmover!=null){
          Navigator.push(
            context,
            getCustomRoute(
                child: PacersAndMoverPlacedScreen(
                  id: widget.id,
                  date: widget.date,
                  lat: widget.lat,
                  lng: widget.lng,
                )),
          );
        }else{
          Navigator.push(
            context,
            getCustomRoute(
                child: GoodsPlacedScreen(
                  id: widget.id,
                  date: widget.date,
                  lat: widget.lat,
                  lng: widget.lng,
                )),
          );

        }

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.pushAndRemoveUntil(
          context,
          getCustomRoute(child: Dashboard()),
          (route) => false,
        );
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.imagesSucessGif,
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 25),
              Text(
                "Booking Placed!",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "Your booking has been placed. Our team will contact you soon.",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontSize: 18.0, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
