import 'dart:developer';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logistics/controllers/booking_controller.dart';
import 'package:logistics/controllers/goods_controller.dart';
import 'package:logistics/controllers/two_wheeler_booking_controller.dart';

class DeliveredMap extends StatefulWidget {
  const DeliveredMap({super.key});

  @override
  State<DeliveredMap> createState() => _DeliveredMapState();
}

class _DeliveredMapState extends State<DeliveredMap> {
  var location = Get.find<BookingController>().bookingdetailsModel!.locations!;

  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  BitmapDescriptor? _pickupIcon;
  BitmapDescriptor? _dropIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  Future<void> _loadCustomMarker() async {
    _pickupIcon = await _getMarkerIcon(Colors.green);
    _dropIcon = await _getMarkerIcon(Colors.red);
    _prepareMarkersAndPolyline();
    setState(() {});
  }

  Future<BitmapDescriptor> _getMarkerIcon(Color color) async {
    final icon = Icons.location_on;
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    const size = Size(40, 40);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: 30.0,
        fontFamily: icon.fontFamily,
        color: color,
        package: icon.fontPackage,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(5, 5));

    final picture = pictureRecorder.endRecording();
    final image =
        await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    return BitmapDescriptor.bytes(buffer);
  }

  void _prepareMarkersAndPolyline() {
    _markers.clear();

    for (var loc in location) {
      double lat = double.parse(loc.latitude!);
      double lng = double.parse(loc.longitude!);

      final latLng = LatLng(lat, lng);
      log(loc.type!, name: "Location Type");

      if (loc.type == "pickup") {
        _markers.add(Marker(
          markerId: MarkerId(loc.mapLocation!),
          position: latLng,
          infoWindow: InfoWindow(title: loc.mapLocation!),
          icon: _pickupIcon!,
        ));
      } else if (loc.type == "drop") {
        _markers.add(Marker(
          markerId: MarkerId(loc.mapLocation!),
          position: latLng,
          infoWindow: InfoWindow(title: loc.mapLocation!),
          icon: _dropIcon!,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pickupIcon == null || _dropIcon == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final pickupLocation = location.firstWhere(
      (loc) => loc.type == 'pickup',
      orElse: () => location.first,
    );

    return Container(
      height: 300,
      width: double.infinity,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(double.parse(pickupLocation.latitude!),
              double.parse(pickupLocation.longitude!)),
          zoom: 14,
        ),
        onCameraMove: (CameraPosition position) {},
        onMapCreated: (controller) {
          mapController = controller;
        },
        // myLocationEnabled: true,
        markers: _markers,
      ),
    );
  }
}
