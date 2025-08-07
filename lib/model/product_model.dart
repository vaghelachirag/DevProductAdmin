// models/product.dart
class ProductModel {
  final String id;
  final String name;
  final String category;
  final double sellingPrice;
  final int quantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.sellingPrice,
    required this.quantity,
  });
}
