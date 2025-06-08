import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistics/controllers/two_wheeler_booking_controller.dart';
import 'package:logistics/main.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/views/screens/DashBoard/Booking_Screen/TwoWheelerList/TwoWheeler_BookingDetails/InTransit_Order_Page/intransit_order_page.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../data/repositories/auth_repo.dart';
import '../data/repositories/user_repo.dart';
import '../views/screens/DashBoard/Booking_Screen/TwoWheelerList/TwoWheeler_BookingDetails/Pending_Order_Page/Components/nodriverdialogue.dart';

class PusherController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  final UserRepo userRepo;

  PusherController({required this.authRepo, required this.userRepo});

  Future<void> initializepusher(int bookingid) async {
    PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

    try {
      await pusher.init(
        apiKey: "1cdf1e7644ae7f3d2a26",
        cluster: "ap2",
        onConnectionStateChange: (dynamic currentState, dynamic previousState) {
          log("Connection: $previousState -> $currentState", name: "Pusher");
        },
        onError: (String message, int? code, dynamic e) {
          log("onError: $message code: $code exception: $e",
              name: "Pusher Error");
        },
        onSubscriptionSucceeded: (channelName, data) {
          log("onSubscriptionSucceeded: $channelName data: $data",
              name: "Pusher onSubscriptionSucceeded");
        },
        onEvent: (event) {
          log(event.toString(), name: "Pusher Event");
          log("onEvent received: ${event.eventName}",
              name: "Pusher event name");
          log("Event from channel: ${event.channelName}",
              name: "Pusher Channel");

          if (event.eventName == 'my-event' && event.data != null) {
            try {
              final pusherdecoded = jsonDecode(event.data!);
              // log("Decoded my-event: $decoded", name: "Pusher Decoded");

              if (event.channelName ==
                  'two_wheeler_driver_location_${bookingid}') {
                if (pusherdecoded['latitude'] != null &&
                    pusherdecoded['longitude'] != null) {
                  final lat = double.parse(pusherdecoded['latitude']);
                  final lng = double.parse(pusherdecoded['longitude']);
                  Get.find<TwoWheelerBookingController>()
                      .updateDriverLocation(lat, lng);
                  log("Driver location updated: $lat, $lng",
                      name: "Pusher Lat Lng");
                }
              } else if (event.channelName ==
                  "two_wheeler_no_booking_accepted_${bookingid}") {
                log("No driver accepted the booking. Booking ID: ${pusherdecoded['bookingId']}",
                    name: "Pusher Info");
                // showNoDriverDialog();
              } else if (event.channelName ==
                  "two_wheeler_booking_accepted_${bookingid}") {
                log("Booking accepted: ${pusherdecoded['bookingTwoWheeler']['id']}",
                    name: "Pusher Info");
                pusher.disconnect();
                Navigator.push(navigatorKey.currentState!.context,
                    getCustomRoute(child: IntransitOrderPage(id: bookingid)));
              }
            } catch (e) {
              log("Error decoding my-event JSON: $e",
                  name: "Pusher JSON Error");
            }
          }
        },
        onSubscriptionError: (message, error) {
          log("onSubscriptionError: $message Exception: $error",
              name: "Pusher onSubscriptionError");
        },
      );
      await pusher.subscribe(
          channelName: 'two_wheeler_driver_location_${bookingid}');

      await pusher.subscribe(
          channelName: 'two_wheeler_driver_not_found_${bookingid}');

      await pusher.subscribe(
          channelName: 'two_wheeler_booking_accepted_${bookingid}');
      await pusher.subscribe(
          channelName: 'two_wheeler_no_booking_accepted_${bookingid}');

      await pusher.connect();
    } catch (e) {
      log("Pusher init error: $e", name: "Pusher Init Error");
    }
  }
}


