import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopkeeper_admin/model/product_model.dart';

import '../../../api/apiServices.dart';


final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Create the FutureProvider for categories
final productListProvider = FutureProvider<List<ProductModel>>((ref) async {
  final apiService = ref.watch(apiServiceProvider); // get ApiService instance
  return apiService.fetchProduct(); // call method from service
});


// Search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Categories
final categoryListProvider = StateProvider<List<String>>((ref) => [
  'Toys',
  'Clothes',
  'Food',
  'Accessories',
]);

