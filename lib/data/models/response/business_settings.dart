
import 'dart:convert';

List<BusinessSettings> businessSettingsFromJson(String str) => List<BusinessSettings>.from(json.decode(str).map((x) => BusinessSettings.fromJson(x)));

String businessSettingsToJson(List<BusinessSettings> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusinessSettings {
  int? id;
  String? key;
  String? value;
  DateTime? createdAt;
  DateTime? updatedAt;

  BusinessSettings({
    this.id,
    this.key,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessSettings.fromJson(Map<String, dynamic> json) => BusinessSettings(
    id: json["id"],
    key: json["key"],
    value: json["value"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "key": key,
    "value": value,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
