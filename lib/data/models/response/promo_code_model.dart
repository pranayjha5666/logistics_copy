import 'dart:convert';

PromoCodeModel promoCodeModelFromJson(String str) => PromoCodeModel.fromJson(json.decode(str));

String promoCodeModelToJson(PromoCodeModel data) => json.encode(data.toJson());

class PromoCodeModel {
  int? id;
  String? title;
  String? type;
  int? value;
  dynamic startDate;
  dynamic endDate;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  PromoCodeModel({
    this.id,
    this.title,
    this.type,
    this.value,
    this.startDate,
    this.endDate,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) => PromoCodeModel(
    id: json["id"],
    title: json["title"],
    type: json["type"],
    value: json["value"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "type": type,
    "value": value,
    "start_date": startDate,
    "end_date": endDate,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
