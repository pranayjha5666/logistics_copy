
List<ApplianceCategory> parseApplianceData(Map<String, dynamic> data) {
  return data.entries.map((entry) {
    return ApplianceCategory.fromJson(entry.key, entry.value);
  }).toList();
}


class ApplianceCategory {
  final String category;
  final List<ApplianceItem> items;

  ApplianceCategory({required this.category, required this.items});

  factory ApplianceCategory.fromJson(String category, List<dynamic> jsonList) {
    return ApplianceCategory(
      category: category,
      items: jsonList.map((item) => ApplianceItem.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      category: items.map((item) => item.toJson()).toList(),
    };
  }
}


class ApplianceItem {
  final String name;
  int count;

  ApplianceItem({required this.name, this.count = 0});

  factory ApplianceItem.fromJson(Map<String, dynamic> json) {
    return ApplianceItem(
      name: json['name'],
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'count': count,
    };
  }
}
