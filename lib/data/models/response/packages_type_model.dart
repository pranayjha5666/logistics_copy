import 'dart:convert';

List<PackagesTypeModel> packagesTypeModelFromJson(String str) =>
    List<PackagesTypeModel>.from(
        json.decode(str).map((x) => PackagesTypeModel.fromJson(x)));

String packagesTypeModelToJson(List<PackagesTypeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PackagesTypeModel {
  int? id;
  String? title;

  PackagesTypeModel({
    this.id,
    this.title,
  });

  factory PackagesTypeModel.fromJson(Map<String, dynamic> json) =>
      PackagesTypeModel(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
