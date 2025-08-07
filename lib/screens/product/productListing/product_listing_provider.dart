import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopkeeper_admin/model/product_model.dart';

// List of products
final productListProvider = StateProvider<List<ProductModel>>((ref) => [
  ProductModel(id: '1', name: 'Toy Car', category: 'Toys', sellingPrice: 120.0, quantity: 10),
  ProductModel(id: '2', name: 'Shirt', category: 'Clothes', sellingPrice: 499.0, quantity: 5),
]);

// Search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Categories
final categoryListProvider = StateProvider<List<String>>((ref) => [
  'Toys',
  'Clothes',
  'Food',
  'Accessories',
]);
