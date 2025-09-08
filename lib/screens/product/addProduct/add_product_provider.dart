import 'dart:math';


import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopkeeper_admin/model/add_product_model.dart';
import '../../../api/apiServices.dart';

// Generate random Product ID
final productIdProvider = StateProvider<String>((ref) {
  final random = Random();
  return 'P${100000 + random.nextInt(899999)}';
});

final productNameProvider = StateProvider<String>((ref) => '');
final productCategoryProvider = StateProvider<String?>((ref) => null);
final purchasePriceProvider = StateProvider<String>((ref) => '');
final sellingPriceProvider = StateProvider<String>((ref) => '');
final quantityProvider = StateProvider<String>((ref) => '');

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final addProductProvider = FutureProvider.family<bool, AddProductModel>((ref, product) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.addProduct(product);
});

final isAddingProductProvider = StateProvider<bool>((ref) => false);


/// --- Controllers Providers ---
final productNameControllerProvider =
Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

final purchasePriceControllerProvider =
Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

final sellingPriceControllerProvider =
Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});


final quantityControllerProvider =
Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});