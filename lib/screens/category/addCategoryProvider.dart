import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/add_category_model.dart';
import '../product/addProduct/add_product_provider.dart';


final categoryNameProvider = StateProvider<String>((ref) => '');

final isAddingCategoryProvider = StateProvider<bool>((ref) => false);

final addCategoryProvider =
FutureProvider.family<bool, AddCategoryModel>((ref, category) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.addCategory(category);
});
