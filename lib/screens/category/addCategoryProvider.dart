import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/add_category_model.dart';
import '../product/addProduct/add_product_provider.dart';


final categoryNameProvider = StateProvider<String>((ref) => '');

final isAddingCategoryProvider = StateProvider<bool>((ref) => false);


/// --- Controllers Providers ---
final categoryNameControllerProvider =
Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});


final addCategoryProvider =
FutureProvider.family<bool, AddCategoryModel>((ref, category) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.addCategory(category);
});
