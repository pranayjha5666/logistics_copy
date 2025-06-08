class LocationModel {
  String mapLocation;
  String addressLineOne;
  String? addressLineTwo;
  String latitude;
  String longitude;
  int stateId;
  String city;
  String pincode;
  String type;
  String name;
  String phone;

  LocationModel(
      {required this.mapLocation,
      required this.addressLineOne,
      this.addressLineTwo,
      required this.latitude,
      required this.longitude,
      required this.stateId,
      required this.city,
      required this.pincode,
      required this.type,
      required this.name,
      required this.phone});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
        mapLocation: json['map_location'],
        addressLineOne: json['address_line_one'],
        addressLineTwo: json['address_line_two'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        stateId: json['state_id'],
        city: json['city'],
        pincode: json['pincode'],
        type: json['type'],
        name: json['name'],
        phone: json['phone']);
  }

  Map<String, dynamic> toJson() {
    return {
      'map_location': mapLocation,
      'address_line_one': addressLineOne,
      'address_line_two': addressLineTwo,
      'latitude': latitude,
      'longitude': longitude,
      'state_id': stateId,
      'city': city,
      'pincode': pincode,
      'type': type,
      'name': name,
      'phone': phone
    };
  }
}
