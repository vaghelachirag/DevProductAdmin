import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../webServices/api_services.dart';


final googleSheetServiceProvider = Provider((ref) => GoogleSheetService());

class AddProductState {
  final bool isLoading;
  final String? message;

  AddProductState({this.isLoading = false, this.message});

  AddProductState copyWith({bool? isLoading, String? message}) {
    return AddProductState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
    );
  }
}

class AddProductNotifier extends StateNotifier<AddProductState> {
  final GoogleSheetService service;

  AddProductNotifier(this.service) : super(AddProductState());

  Future<void> addProduct({
    required String productName,
    required String category,
    required double purchasePrice,
    required int qty,
  }) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      final res = await service.addProduct(
        productName: productName,
        category: category,
        purchasePrice: purchasePrice,
        qty: qty,
      );

      state = state.copyWith(
        isLoading: false,
        message: res["message"] ?? "Product added successfully",
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        message: "Error: ${e.toString()}",
      );
    }
  }
}

final addProductProvider =
StateNotifierProvider<AddProductNotifier, AddProductState>((ref) {
  return AddProductNotifier(ref.read(googleSheetServiceProvider));
});
