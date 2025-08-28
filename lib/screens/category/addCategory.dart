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

    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    void submit() {
      if (formKey.currentState!.validate()) {
        ref.read(isAddingCategoryProvider.notifier).state = true;

        final category = AddCategoryModel(
          id: "C${100000 + Random().nextInt(899999)}", // random category ID
          categoryName: controller.text,
          action: 'addCategory',
        );

        ref.read(addCategoryProvider(category).future).then((result) {
          if (result == true) {
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
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Add Category',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
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
                        controller: controller,
                        label: 'Category Name',
                        icon: Icons.category,
                        onChanged: (val) => ref.read(categoryNameProvider.notifier).state = val,
                      ),
                      const SizedBox(height: 24),
                      isAdding
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton.icon(
                        onPressed: submit,
                        icon: const Icon(Icons.add, color: Color(0xFF1E3A8A)),
                        label: Text(
                          'Add Category',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1E3A8A),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDCEAFE),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(
                              color: Color(0xFF1E3A8A),
                              width: 1.5,
                            ),
                          ),
                          elevation: 3,
                          shadowColor:
                          const Color(0xFF1E3A8A).withOpacity(0.3),
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
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required void Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controller,
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
}
