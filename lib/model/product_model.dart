class ProductModel {
  final int id;
  final String productName;
  final String category;
  final int purchasePrice;
  final int quantity;

  ProductModel({
    required this.id,
    required this.productName,
    required this.category,
    required this.purchasePrice,
    required this.quantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      productName: json['productname'] ?? '',
      category: json['category'] ?? '',
      purchasePrice: json['purchaseprice'] ?? 0,
      quantity: json['quantity'] ?? 0,
    );
  }
}
