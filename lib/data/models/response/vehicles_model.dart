
import 'dart:convert';


List<VehiclesModel> vehiclesModelFromJson(String str) =>
    List<VehiclesModel>.from(json.decode(str).map((x) => VehiclesModel.fromJson(x)));

String vehiclesModelToJson(List<VehiclesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));



class VehiclesModel {

  int id;
  String name;
  String type;
  String weight;

  VehiclesModel({
    required this.id,
    required this.name,
    required this.type,
    required this.weight,
  });

  factory VehiclesModel.fromJson(Map<String, dynamic> json) {
    return VehiclesModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'weight': weight,
    };
  }
}
