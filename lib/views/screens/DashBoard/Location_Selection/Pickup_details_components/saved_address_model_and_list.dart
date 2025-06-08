class SavedAddress {
  final String addresstype;
  final String mapAddress;
  final String addressLineOne;
  final String addressLineTwo;
  final String pincode;
  final String city;
  final String name;
  final String phone;

  final String type;
  final String? stateName;
  final String? latitude;
  final String? longitude;
  final int? stateId;

  SavedAddress({
    required this.addresstype,
    required this.mapAddress,
    required this.addressLineOne,
    required this.addressLineTwo,
    required this.pincode,
    required this.city,
    required this.name,
    required this.phone,
    required this.type,
    this.stateName,
    this.latitude,
    this.longitude,
    this.stateId,
  });

  // Optional: Convert to/from JSON
  factory SavedAddress.fromJson(Map<String, dynamic> json) {
    return SavedAddress(
      addresstype: json['addresstype'],
      mapAddress: json['mapAddress'],
      addressLineOne: json['addressLineOne'],
      addressLineTwo: json['addressLineTwo'],
      pincode: json['pincode'],
      city: json['city'],
      name: json['name'],
      phone: json['phone'],
      type: json['type'],
      stateName: json['stateName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      stateId: json['stateId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addresstype': addresstype,
      'mapAddress': mapAddress,
      'addressLineOne': addressLineOne,
      'addressLineTwo': addressLineTwo,
      'pincode': pincode,
      'city': city,
      'name': name,
      'phone': phone,
      'type': type,
      'stateName': stateName,
      'latitude': latitude,
      'longitude': longitude,
      'stateId': stateId,
    };
  }
}
