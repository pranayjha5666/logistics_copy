

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? companyName;
  String? gstNumber;
  String? gstCertificate;
  String? msmeCertificate;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.companyName,
    this.gstNumber,
    this.gstCertificate,
    this.msmeCertificate,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    companyName: json["company_name"],
    gstNumber: json["gst_number"],
    gstCertificate: json["gst_certificate"],
    msmeCertificate: json["msme_certificate"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "company_name": companyName,
    "gst_number": gstNumber,
    "gst_certificate": gstCertificate,
    "msme_certificate": msmeCertificate,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, '
        'companyName: $companyName, gstNumber: $gstNumber, '
        'gstCertificate: $gstCertificate, msmeCertificate: $msmeCertificate, '
        'status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

}



