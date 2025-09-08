class LowStockModel {
  final String name;
  final String category;
  final int qty;

  LowStockModel({
    required this.name,
    required this.category,
    required this.qty,
  });

  /// Factory constructor to create from JSON
  factory LowStockModel.fromJson(Map<String, dynamic> json) {
    return LowStockModel(
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      qty: (json['qty'] is int)
          ? json['qty']
          : int.tryParse(json['qty'].toString()) ?? 0,
    );
  }

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'qty': qty,
    };
  }
}
