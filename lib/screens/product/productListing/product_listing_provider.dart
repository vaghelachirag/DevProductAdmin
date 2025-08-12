import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shopkeeper_admin/model/product_model.dart';

final productListProvider = FutureProvider<List<ProductModel>>((ref) async {
  const String url =
      "https://script.google.com/macros/s/AKfycbxUUpDoWsmZ301Cxko2kOioaTIunN38v-xdYmEYJcYr_y0pnAtDnOVQIvpCWdFA9Tfn/exec?sheet=ProductEntries";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((item) => ProductModel.fromJson(item)).toList();
  } else {
    throw Exception("Failed to load products");
  }
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
