import 'dart:convert';

List<FaqsModel> faqsModelFromJson(String str) =>
    List<FaqsModel>.from(json.decode(str).map((x) => FaqsModel.fromJson(x)));

String faqsModelToJson(List<FaqsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FaqsModel {
  int? id;
  String? question;
  String? answer;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  FaqsModel({
    this.id,
    this.question,
    this.answer,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory FaqsModel.fromJson(Map<String, dynamic> json) => FaqsModel(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
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
        "question": question,
        "answer": answer,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
