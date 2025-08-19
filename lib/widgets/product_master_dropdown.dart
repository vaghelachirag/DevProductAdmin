import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// --- Provider to fetch categories ---
final categoryListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  const String url = "https://script.google.com/macros/s/AKfycbxUUpDoWsmZ301Cxko2kOioaTIunN38v-xdYmEYJcYr_y0pnAtDnOVQIvpCWdFA9Tfn/exec/exec?sheet=ProductMaster";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData
        .map((e) => {"id": e["id"], "categoryname": e["categoryname"]})
        .toList();
  } else {
    throw Exception("Failed to load categories");
  }
});

// --- State provider for selected category ---
final selectedCategoryProvider = StateProvider<String?>((ref) => null);


// --- ConsumerWidget for dropdown ---
class ProductMasterDropdown extends ConsumerWidget {
  const ProductMasterDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return categoriesAsync.when(
      data: (categoryList) {
        return DropdownButtonFormField<String>(
          value: selectedCategory,
          hint: const Text("Select Category"),
          items: categoryList.map((category) {
            return DropdownMenuItem<String>(
              value: category["categoryname"],
              child: Text(category["categoryname"]),
            );
          }).toList(),
          onChanged: (value) {
            ref.read(selectedCategoryProvider.notifier).state = value;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, _) => Text("Error: $err"),
    );
  }
}
