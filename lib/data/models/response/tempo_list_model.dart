// To parse this JSON data, do
//
//     final tempoListModel = tempoListModelFromJson(jsonString);

import 'dart:convert';

List<TempoListModel> tempoListModelFromJson(String str) => List<TempoListModel>.from(json.decode(str).map((x) => TempoListModel.fromJson(x)));

String tempoListModelToJson(List<TempoListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TempoListModel {
  int? id;
  String? title;
  String? weight;

  TempoListModel({
    this.id,
    this.title,
    this.weight,
  });

  factory TempoListModel.fromJson(Map<String, dynamic> json) => TempoListModel(
    id: json["id"],
    title: json["title"],
    weight: json["weight"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "weight": weight,
  };
}
