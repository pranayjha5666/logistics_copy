import 'dart:convert';

List<GoodsTypeModel> goodsModelFromJson(String str) =>
    List<GoodsTypeModel>.from(
        json.decode(str).map((x) => GoodsTypeModel.fromJson(x)));

String goodsModelToJson(List<GoodsTypeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GoodsTypeModel {
  int id;
  String title;

  GoodsTypeModel({
    required this.id,
    required this.title,
  });

  factory GoodsTypeModel.fromJson(Map<String, dynamic> json) => GoodsTypeModel(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
