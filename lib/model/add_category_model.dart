class AddCategoryModel {
  final String id;
  final String categoryName;
  final String action;

  AddCategoryModel({
    required this.id,
    required this.categoryName,
    required this.action,
  });

  Map<String, String> toJson() {
    return {
      'Id': id,
      'CategoryName': categoryName,
      'action': action,
    };
  }
}
