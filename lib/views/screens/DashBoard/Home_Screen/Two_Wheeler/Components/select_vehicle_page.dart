// import 'package:flutter/material.dart';
//
// import '../../../../../../generated/assets.dart';
// import '../../../../../../services/route_helper.dart';
// import '../two_wheeler_page.dart';
//
// class SelectVehiclePage extends StatefulWidget {
//   const SelectVehiclePage({super.key});
//
//   @override
//   State<SelectVehiclePage> createState() => _SelectVehiclePageState();
// }
//
// class _SelectVehiclePageState extends State<SelectVehiclePage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );
//
//     _scaleAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutBack,
//     );
//
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   Widget choosetransporttype({
//     required Color bgcolor,
//     required String type,
//     required String imagepath,
//     required String heroTag,
//     required Animation<double> animation,
//   }) {
//     return Center(
//       child: Hero(
//         tag: heroTag,
//         child: ScaleTransition(
//           scale: animation,
//           child: Container(
//             width: 250,
//             height: 300,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: bgcolor,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(child: Image.asset(imagepath)),
//                   const SizedBox(height: 8),
//                   Text(
//                     type,
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: "Poppins",
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Select Vehicle Type"),
//         surfaceTintColor: Colors.transparent,
//         backgroundColor: Colors.white,
//       ),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context, getCustomRoute(child: TwoWheelerPage()));
//               },
//               child: choosetransporttype(
//                 bgcolor: const Color(0xffFFE6AD),
//                 type: "Local Bike And Tempo",
//                 imagepath: Assets.imagesTwoWheeler,
//                 heroTag: "two_wheeler",
//                 animation: _scaleAnimation,
//               ),
//             ),
//             SizedBox(height: 40),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context, getCustomRoute(child: TwoWheelerPage()));
//               },
//               child: choosetransporttype(
//                 bgcolor: const Color(0xffB9D9FF),
//                 type: "Local Bike And Tempo",
//                 imagepath: Assets.imagesTempoimg,
//                 heroTag: "tempo_img",
//                 animation: _scaleAnimation,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
