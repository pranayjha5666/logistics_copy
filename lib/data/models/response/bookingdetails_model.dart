// To parse this JSON data, do
//
//     final bookingdetailsModel = bookingdetailsModelFromJson(jsonString);

import 'dart:convert';

BookingdetailsModel bookingdetailsModelFromJson(String str) =>
    BookingdetailsModel.fromJson(json.decode(str));

String bookingdetailsModelToJson(BookingdetailsModel data) =>
    json.encode(data.toJson());

class BookingdetailsModel {
  int? id;
  String? bookingId;
  int? userId;
  int? driverId;
  int? amountForDriver;
  int? amountForUser;
  String? status;
  String? pickupUserName;
  String? pickupUserPhone;
  DateTime? pickupDate;
  DateTime? estimatedDeliveryDate;
  String? deliveryStatus;
  String? dropUserName;
  String? dropUserPhone;
  String? goodTypeId;
  String? truckType;
  int? vehicleId;
  String? vehicleNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? placed;
  DateTime? confirmed;
  DateTime? intransit;
  DateTime? delivered;
  DateTime? cancelled;
  dynamic cancelReason;
  int? tripStartOtp;
  String? tripStartOtpVerified;
  List<BookingsLocation>? locations;
  // List<PayoutBookingGood>? payoutBookingGoodDrivers;
  List<PayoutBookingGood>? payoutBookingGoodUsers;
  Vehicle? vehicle;
  Driver? driver;
  List<BookingGoodHomeItem>? bookingGoodHomeItems;

  BookingdetailsModel({
    this.id,
    this.bookingId,
    this.userId,
    this.driverId,
    this.amountForDriver,
    this.amountForUser,
    this.status,
    this.pickupUserName,
    this.pickupUserPhone,
    this.pickupDate,
    this.estimatedDeliveryDate,
    this.deliveryStatus,
    this.dropUserName,
    this.dropUserPhone,
    this.goodTypeId,
    this.truckType,
    this.vehicleId,
    this.vehicleNumber,
    this.createdAt,
    this.updatedAt,
    this.placed,
    this.confirmed,
    this.intransit,
    this.delivered,
    this.cancelled,
    this.cancelReason,
    this.tripStartOtp,
    this.tripStartOtpVerified,
    this.locations,
    // this.payoutBookingGoodDrivers,
    this.payoutBookingGoodUsers,
    this.vehicle,
    this.driver,
    this.bookingGoodHomeItems,
  });

  factory BookingdetailsModel.fromJson(Map<String, dynamic> json) =>
      BookingdetailsModel(
        id: json["id"],
        bookingId: json["booking_id"],
        userId: json["user_id"],
        driverId: json["driver_id"],
        amountForDriver: json["amount_for_driver"],
        amountForUser: json["amount_for_user"],
        status: json["status"],
        pickupUserName: json["pickup_user_name"],
        pickupUserPhone: json["pickup_user_phone"],
        pickupDate: json["pickup_date"] == null
            ? null
            : DateTime.parse(json["pickup_date"]),
        estimatedDeliveryDate: json["estimated_delivery_date"] == null
            ? null
            : DateTime.parse(json["estimated_delivery_date"]),
        deliveryStatus: json["delivery_status"],
        dropUserName: json["drop_user_name"],
        dropUserPhone: json["drop_user_phone"],
        goodTypeId: json["good_type_id"],
        truckType: json["truck_type"],
        vehicleId: json["vehicle_id"],
        vehicleNumber: json["vehicle_number"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        placed: json["placed"] == null ? null : DateTime.parse(json["placed"]),
        confirmed: json["confirmed"] == null
            ? null
            : DateTime.parse(json["confirmed"]),
        intransit: json["intransit"] == null
            ? null
            : DateTime.parse(json["intransit"]),
        delivered: json["delivered"] == null
            ? null
            : DateTime.parse(json["delivered"]),
        cancelled: json["cancelled"] == null
            ? null
            : DateTime.parse(json["cancelled"]),
        cancelReason: json["cancel_reason"],
        tripStartOtp: json["trip_start_otp"],
        tripStartOtpVerified: json["trip_start_otp_verified"],
        locations: json["locations"] == null
            ? []
            : List<BookingsLocation>.from(
                json["locations"]!.map((x) => BookingsLocation.fromJson(x))),
        // payoutBookingGoodDrivers: json["payout_booking_good_drivers"] == null
        //     ? []
        //     : List<PayoutBookingGood>.from(
        //         json["payout_booking_good_drivers"]!.map((x) => x)),
        payoutBookingGoodUsers: json["payout_booking_good_users"] == null
            ? []
            : List<PayoutBookingGood>.from(json["payout_booking_good_users"]!
                .map((x) => PayoutBookingGood.fromJson(x))),
        vehicle:
            json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
        driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
        bookingGoodHomeItems: json["booking_good_home_items"] == null
            ? []
            : List<BookingGoodHomeItem>.from(json["booking_good_home_items"]!
                .map((x) => BookingGoodHomeItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_id": bookingId,
        "user_id": userId,
        "driver_id": driverId,
        "amount_for_driver": amountForDriver,
        "amount_for_user": amountForUser,
        "status": status,
        "pickup_user_name": pickupUserName,
        "pickup_user_phone": pickupUserPhone,
        "pickup_date": pickupDate?.toIso8601String(),
        "estimated_delivery_date": estimatedDeliveryDate?.toIso8601String(),
        "delivery_status": deliveryStatus,
        "drop_user_name": dropUserName,
        "drop_user_phone": dropUserPhone,
        "good_type_id": goodTypeId,
        "truck_type": truckType,
        "vehicle_id": vehicleId,
        "vehicle_number": vehicleNumber,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "placed": placed?.toIso8601String(),
        "confirmed": confirmed?.toIso8601String(),
        "intransit": intransit?.toIso8601String(),
        "delivered": delivered?.toIso8601String(),
        "cancelled": cancelled?.toIso8601String(),
        "cancel_reason": cancelReason,
        "trip_start_otp": tripStartOtp,
        "trip_start_otp_verified": tripStartOtpVerified,
        "locations": locations == null
            ? []
            : List<dynamic>.from(locations!.map((x) => x.toJson())),
        // "payout_booking_good_drivers": payoutBookingGoodDrivers == null
        //     ? []
        //     : List<dynamic>.from(payoutBookingGoodDrivers!.map((x) => x)),
        "payout_booking_good_users": payoutBookingGoodUsers == null
            ? []
            : List<dynamic>.from(
                payoutBookingGoodUsers!.map((x) => x.toJson())),
        "vehicle": vehicle?.toJson(),
        "driver": driver?.toJson(),
      };
}

class BookingGoodHomeItem {
  int? id;
  int? bookingGoodId;
  int? homeItemId;
  HomeItemData? homeItemData;
  int? quantity;

  BookingGoodHomeItem({
    this.id,
    this.bookingGoodId,
    this.homeItemId,
    this.homeItemData,
    this.quantity,
  });

  factory BookingGoodHomeItem.fromJson(Map<String, dynamic> json) =>
      BookingGoodHomeItem(
        id: json["id"],
        bookingGoodId: json["booking_good_id"],
        homeItemId: json["home_item_id"],
        homeItemData: json["home_item_data"] == null
            ? null
            : HomeItemData.fromJson(json["home_item_data"]),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_good_id": bookingGoodId,
        "home_item_id": homeItemId,
        "home_item_data": homeItemData?.toJson(),
        "quantity": quantity,
      };
}

class HomeItemData {
  int? id;
  String? title;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  HomeItemCategory? homeItemCategory;
  int? homeItemCategoryId;

  HomeItemData({
    this.id,
    this.title,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.homeItemCategory,
    this.homeItemCategoryId,
  });

  factory HomeItemData.fromJson(Map<String, dynamic> json) => HomeItemData(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        homeItemCategory: json["home_item_category"] == null
            ? null
            : HomeItemCategory.fromJson(json["home_item_category"]),
        homeItemCategoryId: json["home_item_category_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "home_item_category": homeItemCategory?.toJson(),
        "home_item_category_id": homeItemCategoryId,
      };
}

class HomeItemCategory {
  int? id;
  String? title;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  HomeItemCategory({
    this.id,
    this.title,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory HomeItemCategory.fromJson(Map<String, dynamic> json) =>
      HomeItemCategory(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Driver {
  int? id;
  String? vehicleNumber;
  String? latitude;
  String? longitude;

  Driver({
    this.id,
    this.vehicleNumber,
    this.latitude,
    this.longitude,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        vehicleNumber: json["vehicle_number"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicle_number": vehicleNumber,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class BookingsLocation {
  int? id;
  int? bookingGoodId;
  String? type;
  String? addressLineOne;
  dynamic addressLineTwo;
  int? stateId;
  String? city;
  String? pincode;
  dynamic loadingUnloadingStartTime;
  dynamic loadingUnloadingEndTime;
  dynamic intransitStartTime;
  dynamic intransitEndTime;
  String? mapLocation;
  String? latitude;
  String? longitude;
  String? status;
  DateTime? doneAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? sequence;

  BookingsLocation({
    this.id,
    this.bookingGoodId,
    this.type,
    this.addressLineOne,
    this.addressLineTwo,
    this.stateId,
    this.city,
    this.pincode,
    this.loadingUnloadingStartTime,
    this.loadingUnloadingEndTime,
    this.intransitStartTime,
    this.intransitEndTime,
    this.mapLocation,
    this.latitude,
    this.longitude,
    this.status,
    this.doneAt,
    this.createdAt,
    this.updatedAt,
    this.sequence,
  });

  factory BookingsLocation.fromJson(Map<String, dynamic> json) =>
      BookingsLocation(
        id: json["id"],
        bookingGoodId: json["booking_good_id"],
        type: json["type"],
        addressLineOne: json["address_line_one"],
        addressLineTwo: json["address_line_two"],
        stateId: json["state_id"],
        city: json["city"],
        pincode: json["pincode"],
        loadingUnloadingStartTime: json["loading_unloading_start_time"],
        loadingUnloadingEndTime: json["loading_unloading_end_time"],
        intransitStartTime: json["intransit_start_time"],
        intransitEndTime: json["intransit_end_time"],
        mapLocation: json["map_location"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        status: json["status"],
        doneAt:
            json["done_at"] == null ? null : DateTime.parse(json["done_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        sequence: json["sequence"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_good_id": bookingGoodId,
        "type": type,
        "address_line_one": addressLineOne,
        "address_line_two": addressLineTwo,
        "state_id": stateId,
        "city": city,
        "pincode": pincode,
        "loading_unloading_start_time": loadingUnloadingStartTime,
        "loading_unloading_end_time": loadingUnloadingEndTime,
        "intransit_start_time": intransitStartTime,
        "intransit_end_time": intransitEndTime,
        "map_location": mapLocation,
        "latitude": latitude,
        "longitude": longitude,
        "status": status,
        "done_at": doneAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "sequence": sequence,
      };
}

class PayoutBookingGood {
  int? id;
  int? bookingGoodId;
  int? userId;
  int? amount;
  dynamic remark;
  dynamic file;
  DateTime? createdAt;
  DateTime? updatedAt;

  PayoutBookingGood({
    this.id,
    this.bookingGoodId,
    this.userId,
    this.amount,
    this.remark,
    this.file,
    this.createdAt,
    this.updatedAt,
  });

  factory PayoutBookingGood.fromJson(Map<String, dynamic> json) =>
      PayoutBookingGood(
        id: json["id"],
        bookingGoodId: json["booking_good_id"],
        userId: json["user_id"],
        amount: json["amount"],
        remark: json["remark"],
        file: json["file"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_good_id": bookingGoodId,
        "user_id": userId,
        "amount": amount,
        "remark": remark,
        "file": file,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Vehicle {
  int? id;
  String? name;
  String? type;
  String? weight;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Vehicle({
    this.id,
    this.name,
    this.type,
    this.weight,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        weight: json["weight"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "weight": weight,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
