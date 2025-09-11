import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/add_category_model.dart';
import 'addCategoryProvider.dart';

class AddCategoryPage extends ConsumerWidget {
  static const route = "/AddCategoryPage";

  const AddCategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryName = ref.watch(categoryNameProvider);
    final isAdding = ref.watch(isAddingCategoryProvider);

    final formKey = GlobalKey<FormState>();

    // Use controller synced with provider
    final controller = TextEditingController(text: categoryName);

    // Controllers
    final categoryNameController = ref.watch(categoryNameControllerProvider);

    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    void submit() {
      if (formKey.currentState!.validate()) {
        ref.read(isAddingCategoryProvider.notifier).state = true;

        final category = AddCategoryModel(
          id: "C${100000 + Random().nextInt(899999)}", // random category ID
          categoryName: categoryNameController.text,
          action: 'addCategory',
        );

        ref.read(addCategoryProvider(category).future).then((result) {
          if (result == true) {
            categoryNameController.clear();
            ref.read(categoryNameProvider.notifier).state = '';
            controller.clear(); // clear textfield
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Category Added Successfully!")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Category Not Added!")),
            );
          }
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        }).whenComplete(() {
          ref.read(isAddingCategoryProvider.notifier).state = false;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Category',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
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
                      _textField(
                        context: context,
                        icon: Icons.text_fields,
                        label: 'Category Name',
                        controller: categoryNameController,
                        onChanged: (val) => {},
                      ),
                      const SizedBox(height: 24),
                      isAdding
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton.icon(
                              onPressed: submit,
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: Text(
                                'Add Category',
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
