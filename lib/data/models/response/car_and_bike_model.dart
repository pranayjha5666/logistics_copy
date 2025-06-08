import 'dart:convert';

List<CarAndBikeModel> carAndBikeModelFromJson(String str) =>
    List<CarAndBikeModel>.from(
        json.decode(str).map((x) => CarAndBikeModel.fromJson(x)));

String carAndBikeModelToJson(List<CarAndBikeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CarAndBikeModel {
  int? id;
  int? userId;
  String? vehicleData;
  DateTime? estimatedMovingDate;
  String? whereToMove;
  String? pickupUserName;
  String? pickupUserPhone;
  String? pickupMapLocation;
  String? pickupAddressLineOne;
  String? pickupAddressLineTwo;
  int? pickupStateId;
  String? pickupCity;
  String? pickupPincode;
  String? pickupLatitude;
  String? pickupLongitude;
  String? dropUserName;
  String? dropUserPhone;
  String? dropMapLocation;
  String? dropAddressLineOne;
  String? dropAddressLineTwo;
  int? dropStateId;
  String? dropCity;
  String? dropPincode;
  String? dropLatitude;
  String? dropLongitude;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  CarAndBikeModel({
    this.id,
    this.userId,
    this.vehicleData,
    this.estimatedMovingDate,
    this.whereToMove,
    this.pickupUserName,
    this.pickupUserPhone,
    this.pickupMapLocation,
    this.pickupAddressLineOne,
    this.pickupAddressLineTwo,
    this.pickupStateId,
    this.pickupCity,
    this.pickupPincode,
    this.pickupLatitude,
    this.pickupLongitude,
    this.dropUserName,
    this.dropUserPhone,
    this.dropMapLocation,
    this.dropAddressLineOne,
    this.dropAddressLineTwo,
    this.dropStateId,
    this.dropCity,
    this.dropPincode,
    this.dropLatitude,
    this.dropLongitude,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CarAndBikeModel.fromJson(Map<String, dynamic> json) =>
      CarAndBikeModel(
        id: json["id"],
        userId: json["user_id"],
        vehicleData: json["vehicle_data"],
        estimatedMovingDate: json["estimated_moving_date"] == null
            ? null
            : DateTime.parse(json["estimated_moving_date"]),
        whereToMove: json["where_to_move"],
        pickupUserName: json["pickup_user_name"],
        pickupUserPhone: json["pickup_user_phone"],
        pickupMapLocation: json["pickup_map_location"],
        pickupAddressLineOne: json["pickup_address_line_one"],
        pickupAddressLineTwo: json["pickup_address_line_two"],
        pickupStateId: json["pickup_state_id"],
        pickupCity: json["pickup_city"],
        pickupPincode: json["pickup_pincode"],
        pickupLatitude: json["pickup_latitude"],
        pickupLongitude: json["pickup_longitude"],
        dropUserName: json["drop_user_name"],
        dropUserPhone: json["drop_user_phone"],
        dropMapLocation: json["drop_map_location"],
        dropAddressLineOne: json["drop_address_line_one"],
        dropAddressLineTwo: json["drop_address_line_two"],
        dropStateId: json["drop_state_id"],
        dropCity: json["drop_city"],
        dropPincode: json["drop_pincode"],
        dropLatitude: json["drop_latitude"],
        dropLongitude: json["drop_longitude"],
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
        "user_id": userId,
        "vehicle_data": vehicleData,
        "estimated_moving_date": estimatedMovingDate?.toIso8601String(),
        "where_to_move": whereToMove,
        "pickup_user_name": pickupUserName,
        "pickup_user_phone": pickupUserPhone,
        "pickup_map_location": pickupMapLocation,
        "pickup_address_line_one": pickupAddressLineOne,
        "pickup_address_line_two": pickupAddressLineTwo,
        "pickup_state_id": pickupStateId,
        "pickup_city": pickupCity,
        "pickup_pincode": pickupPincode,
        "pickup_latitude": pickupLatitude,
        "pickup_longitude": pickupLongitude,
        "drop_user_name": dropUserName,
        "drop_user_phone": dropUserPhone,
        "drop_map_location": dropMapLocation,
        "drop_address_line_one": dropAddressLineOne,
        "drop_address_line_two": dropAddressLineTwo,
        "drop_state_id": dropStateId,
        "drop_city": dropCity,
        "drop_pincode": dropPincode,
        "drop_latitude": dropLatitude,
        "drop_longitude": dropLongitude,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
