import 'dart:convert';

List<SliderModel> sliderModelFromJson(String str) => List<SliderModel>.from(json.decode(str).map((x) => SliderModel.fromJson(x)));

String sliderModelToJson(List<SliderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SliderModel {
  String? image;

  SliderModel({
    this.image,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
  };
}
