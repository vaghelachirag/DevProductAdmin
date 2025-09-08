class ProductModel {
  final String id;
  final String productName;
  final String category;
  final int purchasePrice;
  final int sellingPrice;
  final int quantity;

  ProductModel({
    required this.id,
    required this.productName,
    required this.category,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.quantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['Id'] ?? '',
      productName: json['ProductName'] ?? '',
      category: json['Category'] ?? '',
      purchasePrice: json['PurchasePrice'] ?? 0,
      sellingPrice: json['SellingPrice'] ?? 0,
      quantity: json['Qty'] ?? 0,
    );
  }
}
