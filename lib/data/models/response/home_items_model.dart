
import 'dart:convert';

List<HomeItemsModel> homeItemsModelFromJson(String str) => List<HomeItemsModel>.from(json.decode(str).map((x) => HomeItemsModel.fromJson(x)));

String homeItemsModelToJson(List<HomeItemsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HomeItemsModel {
  int? id;
  String? title;
  int? homeItemCategoryId;
  HomeItemCategory? homeItemCategory;
  int quantity;


  HomeItemsModel({
    this.id,
    this.title,
    this.homeItemCategoryId,
    this.homeItemCategory,
    this.quantity = 0,

  });

  factory HomeItemsModel.fromJson(Map<String, dynamic> json) => HomeItemsModel(
    id: json["id"],
    title: json["title"],
    homeItemCategoryId: json["home_item_category_id"],
    homeItemCategory: json["home_item_category"] == null ? null : HomeItemCategory.fromJson(json["home_item_category"]),
    quantity: 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "home_item_category_id": homeItemCategoryId,
    "home_item_category": homeItemCategory?.toJson(),

  };
}

class HomeItemCategory {
  int? id;
  String? title;

  HomeItemCategory({
    this.id,
    this.title,
  });

  factory HomeItemCategory.fromJson(Map<String, dynamic> json) => HomeItemCategory(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}


class CategoryGroup {
  final String categoryName;
  final List<HomeItemsModel> items;

  CategoryGroup({required this.categoryName, required this.items});
}

