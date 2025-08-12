import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../api/ApiServices.dart';
import '../../widgets/product_master_dropdown.dart';
import 'add_product_provider.dart';

class AddProductPage extends ConsumerWidget {
  static const route = "/AddProductPage";

  const AddProductPage({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productId = ref.watch(productIdProvider);
    final productName = ref.watch(productNameProvider);
    final category = ref.watch(productCategoryProvider);
    final price = ref.watch(purchasePriceProvider);
    final qty = ref.watch(quantityProvider);

    final formKey = GlobalKey<FormState>();

    void submit() {
      if (formKey.currentState!.validate()) {
        debugPrint('Product ID: $productId');
        debugPrint('Name: $productName');
        debugPrint('Category: $category');
        debugPrint('Price: $price');
        debugPrint('Qty: $qty');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Product added successfully!')),
        );

        // Reset fields
        ref.read(productIdProvider.notifier).state =
        'P${100000 + Random().nextInt(899999)}';
        ref.read(productNameProvider.notifier).state = '';
        ref.read(productCategoryProvider.notifier).state = null;
        ref.read(purchasePriceProvider.notifier).state = '';
        ref.read(quantityProvider.notifier).state = '';
      }
    }

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Add Product',
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            )),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _readonlyField('Product ID', productId),
                      const SizedBox(height: 16),
                      _textField(
                        context: context,
                        icon: Icons.text_fields,
                        label: 'Product Name',
                        initialValue: productName,
                        onChanged: (val) => ref
                            .read(productNameProvider.notifier)
                            .state = val,
                      ),
                      const SizedBox(height: 16),
                      ProductMasterDropdown(),
                      const SizedBox(height: 16),
                      _textField(
                        context: context,
                        icon: Icons.attach_money,
                        label: 'Purchase Price',
                        initialValue: price,
                        keyboardType: TextInputType.number,
                        onChanged: (val) => ref
                            .read(purchasePriceProvider.notifier)
                            .state = val,
                      ),
                      const SizedBox(height: 16),
                      _textField(
                        context: context,
                        icon: Icons.confirmation_number,
                        label: 'Quantity',
                        initialValue: qty,
                        keyboardType: TextInputType.number,
                        onChanged: (val) => ref
                            .read(quantityProvider.notifier)
                            .state = val,
                      ),
                      const SizedBox(height: 24),
                    ElevatedButton.icon(
                    onPressed: getFeedbackFromSheet,
                    icon: const Icon(Icons.add, color: Color(0xFF7B4B3A)), // warm brown
                    label: Text(
                      'Add Product',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7B4B3A), // warm brown
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDEECF), // pastel beige
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // more rounded, playful look
                        side: const BorderSide(
                          color: Color(0xFF7B4B3A), // matching outline
                          width: 1.5,
                        ),
                      ),
                      elevation: 3,
                      shadowColor: const Color(0xFF7B4B3A).withOpacity(0.3),
                    ),
                  ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendData() async {
    const url = 'https://script.google.com/macros/s/AKfycbzbTEO2B2lxO_kEmH7juC9RLkZByycz_QViG7LOeaJ4FYB38gs/exec';
    final body = {
      'product': 'Test',
      'category': 'Food',
      'purchaseprice': '50',
      'qty': '10',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');
    } catch (e) {
      print('Error: $e');
    }
  }


  Future<void> getFeedbackFromSheet() async {

    const String url = "https://script.google.com/macros/s/AKfycbzgqAweTIPrtsqEwY9HOBNYFBd7SpXAt6wVi65tDyrIdQyAXq6MwPgMxFV4TxuH6r75/exec";

    var raw = await http.get(Uri.parse(url));

    var jsonFeedback = convert.jsonDecode(raw.body);
    print('this is json Feedback $jsonFeedback');

    // feedbacks = jsonFeedback.map((json) => FeedbackModel.fromJson(json));

    jsonFeedback.forEach((element) {
      print('$element THIS IS NEXT>>>>>>>');

    });

    //print('${feedbacks[0]}');
  }

  Widget _readonlyField(String label, String value) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.code),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      style: GoogleFonts.poppins(),
    );
  }


  void addProduct() async {
    ApiServices productService = ApiServices();

    final result = await productService.addProduct(
      product: "Laptop",
      category: "Electronics",
      purchasePrice: "45000",
      qty: "10",
    );

    if (result["success"]) {
      print("✅ Product added! ID: ${result["id"]}");
    } else {
      print("❌ Error: ${result["error"]}");
    }
  }
  Widget _textField({
    required BuildContext context,
    required String label,
    required IconData icon,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    required void Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: (val) => val == null || val.isEmpty ? 'Enter $label' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      style: GoogleFonts.poppins(),
    );
  }

  Widget _dropdown(BuildContext context, String? value,
      void Function(String?) onChanged) {
    final categories = ['Clothes', 'Toys', 'Food', 'Accessories', 'Shoes'];
    return DropdownButtonFormField<String>(
      value: value,
      items: categories
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Category',
        prefixIcon: const Icon(Icons.category),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (val) => val == null ? 'Select a category' : null,
      style: GoogleFonts.poppins(),
    );
  }
}
