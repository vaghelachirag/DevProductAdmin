
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopkeeper_admin/model/add_product_model.dart';

import '../../../widgets/product_master_dropdown.dart';
import 'add_product_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class AddProductPage extends ConsumerWidget {
  static const route = "/AddProductPage";

  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productId = ref.watch(productIdProvider);

    final selectedCategory = ref.watch(selectedCategoryProvider);
    final isAdding = ref.watch(isAddingProductProvider);
    final formKey = GlobalKey<FormState>();

    // Controllers
    final productNameController = ref.watch(productNameControllerProvider);
    final priceController = ref.watch(purchasePriceControllerProvider);
    final sellingPriceController = ref.watch(sellingPriceControllerProvider);
    final qtyController = ref.watch(quantityControllerProvider);

    void submit() {
      if (formKey.currentState!.validate()) {
        ref.read(isAddingProductProvider.notifier).state = true;

        final product = AddProductModel(
          id: productId,
          category: selectedCategory.toString(),
          productName: productNameController.text.trim(),
          purchasePrice: priceController.text.trim(),
          sellingPrice: sellingPriceController.text.trim(),
          quantity: qtyController.text.trim(),
          action: 'addProduct',
        );

        ref.read(addProductProvider(product).future).then((result) {
          if (result == true) {
            productNameController.clear();
            priceController.clear();
            qtyController.clear();

            ref.read(productIdProvider.notifier).state =
                'P${100000 + Random().nextInt(899999)}';
            ref.read(productNameProvider.notifier).state = '';
            ref.read(productCategoryProvider.notifier).state = null;
            ref.read(purchasePriceProvider.notifier).state = '';
            ref.read(sellingPriceProvider.notifier).state = '';
            ref.read(quantityProvider.notifier).state = '';

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Product Added Successfully!")));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Product Not Added Successfully!")));
          }
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        }).whenComplete(() {
          ref.read(isAddingProductProvider.notifier).state = false; // ✅ stop loading
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('addProduct'.tr(),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            )),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _readonlyField('productId'.tr(), productId),
                      const SizedBox(height: 16),
                      ProductMasterDropdown(),
                      const SizedBox(height: 16),
                      _textField(
                        context: context,
                        icon: Icons.text_fields,
                        label: 'productName'.tr(),
                        controller: productNameController,
                        onChanged: (val) =>
                            ref.read(productNameProvider.notifier).state = val,
                      ),
                      const SizedBox(height: 16),
                      _textField(
                        context: context,
                        icon: Icons.attach_money,
                        label: 'purchasePrice'.tr(),
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        onChanged: (val) => ref
                            .read(purchasePriceProvider.notifier)
                            .state = val,
                      ),
                      const SizedBox(height: 16),
                      _textField(
                        context: context,
                        icon: Icons.attach_money,
                        label: 'sellingPrice'.tr(),
                        controller: sellingPriceController,
                        keyboardType: TextInputType.number,
                        onChanged: (val) => ref
                            .read(sellingPriceProvider.notifier)
                            .state = val,
                      ),
                      const SizedBox(height: 16),
                      _textField(
                        context: context,
                        icon: Icons.confirmation_number,
                        label: 'quantity'.tr(),
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        onChanged: (val) =>
                            ref.read(quantityProvider.notifier).state = val,
                      ),
                      const SizedBox(height: 24),
                      if (isAdding)
                        const Center(
                          child: CircularProgressIndicator(),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: submit,
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: Text(
                            'addProduct'.tr(),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
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

  Widget _readonlyField(String label, String value) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.code),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      style: GoogleFonts.poppins(),
    );
  }

  Widget _textField({
    required BuildContext context,
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    required void Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: (val) => val == null || val.isEmpty ? 'Enter $label' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      style: GoogleFonts.poppins(),
    );
  }
}
