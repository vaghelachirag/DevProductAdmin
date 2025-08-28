import 'dart:math';


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopkeeper_admin/model/add_product_model.dart';
import '../../api/apiServices.dart';

// Generate random Product ID
final productIdProvider = StateProvider<String>((ref) {
  final random = Random();
  return 'P${100000 + random.nextInt(899999)}';
});

final productNameProvider = StateProvider<String>((ref) => '');
final productCategoryProvider = StateProvider<String?>((ref) => null);
final purchasePriceProvider = StateProvider<String>((ref) => '');
final quantityProvider = StateProvider<String>((ref) => '');

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final addProductProvider = FutureProvider.family<Map<String, dynamic>, AddProductModel>((ref, product) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.addProduct(product);
});