import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logistics/data/models/response/two_wheeler_booking_details_model.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../../../../generated/assets.dart';
import '../../../../../../../../controllers/two_wheeler_booking_controller.dart';
import '../../Delivered_Page/Shimmer/shimmer_two_wheeler_map.dart';
import '../Shimmer/intransit_map_shimmer.dart';

class IntransitMap extends StatefulWidget {
  const IntransitMap({super.key});

  @override
  State<IntransitMap> createState() => _IntransitMapPageState();
}

class _IntransitMapPageState extends State<IntransitMap> {
  late List<Location> rawLocations;
  late List<Map<String, dynamic>> dummylocation;

  @override
  void initState() {
    super.initState();

    final controller = Get.find<TwoWheelerBookingController>();
    final bookingModel = controller.twowheelerbookingdetailsModel!;

    rawLocations = bookingModel.locations!;
    dummylocation = convertLocationsToMap(rawLocations);

    if (bookingModel.driver != null) {
      final driverData = {
        "type": "driver",
        "location": "Driver",
        "latitude": double.tryParse(bookingModel.driver!.latitude!),
        "longitude": double.tryParse(bookingModel.driver!.longitude!),
        "isCompleted": false,
      };
      dummylocation.add(driverData);
    }

    _loadIcons();
    loadCustomMarker();
  }

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  BitmapDescriptor? _pickupIcon;
  BitmapDescriptor? _dropIcon;
  BitmapDescriptor? _driverIcon;

  Future<void> loadCustomMarker() async {
    _driverIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(
            platform: TargetPlatform.android, size: Size(30, 30)),
        Assets.imagesDeliveryMap1);
  }

  // Future<void> loadCustomMarkerFromIcon() async {
  //   _driverIcon = await BitmapDescriptor.asset(
  //       const ImageConfiguration(
  //           platform: TargetPlatform.android, size: Size(30, 30)),
  //       Assets.imagesDeliveryMap1);
  // }

  List<Map<String, dynamic>> convertLocationsToMap(List<Location> locations) {
    return locations.map((location) {
      return {
        "type": location.type,
        "location": location.mapLocation ?? '',
        "latitude": double.tryParse(location.latitude ?? '') ?? 0.0,
        "longitude": double.tryParse(location.longitude ?? '') ?? 0.0,
        "isCompleted": location.status == "done",
      };
    }).toList();
  }

  Future<void> _loadIcons() async {
    _pickupIcon = await _getMarkerIcon(Colors.green);
    _dropIcon = await _getMarkerIcon(Colors.red);
    _prepareMarkersAndPolyline();
    if (mounted) {
      setState(() {});
    }
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
    _polylines.clear();

    LatLng? firstIncomplete;
    LatLng? driverPosition;

    for (var loc in dummylocation) {
      final latLng = LatLng(loc["latitude"], loc["longitude"]);

      if (loc["type"] == "pickup") {
        _markers.add(Marker(
          markerId: MarkerId(loc["location"]),
          position: latLng,
          infoWindow: InfoWindow(title: loc["location"]),
          icon: _pickupIcon!,
        ));
      } else if (loc["type"] == "drop") {
        _markers.add(Marker(
          markerId: MarkerId(loc["location"]),
          position: latLng,
          infoWindow: InfoWindow(title: loc["location"]),
          icon: _dropIcon!,
        ));
      } else if (loc["type"] == "driver") {
        driverPosition = latLng;
        _markers.add(Marker(
          markerId: MarkerId(loc["location"]),
          position: latLng,
          infoWindow: InfoWindow(title: "Driver: ${loc["location"]}"),
          icon: _driverIcon!,
        ));
      }

      if (firstIncomplete == null &&
          loc["isCompleted"] == false &&
          loc["type"] != "driver") {
        firstIncomplete = latLng;
      }
    }

    if (firstIncomplete != null && driverPosition != null) {
      _polylines.add(Polyline(
        polylineId: const PolylineId("route"),
        visible: true,
        points: [firstIncomplete, driverPosition],
        color: Colors.green,
        width: 5,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstIncomplete = dummylocation.firstWhere(
      (loc) => loc["isCompleted"] == false && loc["type"] != "driver",
      orElse: () => dummylocation.first,
    );
    final initialLatLng =
        LatLng(firstIncomplete["latitude"], firstIncomplete["longitude"]);

    return _pickupIcon == null || _dropIcon == null || _driverIcon == null
        ? IntransitMapShimmer()
        : GoogleMap(
            initialCameraPosition:
                CameraPosition(target: initialLatLng, zoom: 14),
            markers: _markers,
            polylines: _polylines,

            // onMapCreated: (controller) => _mapController = controller,
            // myLocationButtonEnabled: false,
          );
  }
}
