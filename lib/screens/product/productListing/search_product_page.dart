import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shopkeeper_admin/screens/product/productListing/product_listing_provider.dart';


class SearchProductPage extends ConsumerWidget {
  const SearchProductPage({super.key});
  static const route = "/SearchProductPage";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productListProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    final filteredProducts = products
        .where((product) =>
    product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        product.category.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text('Search Products', style: GoogleFonts.poppins()),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            tooltip: 'Add Category',
            onPressed: () {
              _showAddCategoryDialog(context, ref);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchBar(ref),
            const SizedBox(height: 12),
            Expanded(
              child: filteredProducts.isEmpty
                  ? const Center(child: Text("No products found"))
                  : Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 6,
                color: Colors.white,
                child: ListView.separated(
                  itemCount: filteredProducts.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ListTile(
                      title: Text(product.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        'Category: ${product.category} | Qty: ${product.quantity} | ₹${product.sellingPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // TODO: Navigate to Edit Page
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteProductDialog(context, ref, product.id);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.qr_code, color: Colors.blue),
                            onPressed: () {
                              showQrCodeDialog(context, "test");
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(WidgetRef ref) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search by name or category...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
    );
  }

  void _showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter category name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final category = controller.text.trim();
              if (category.isNotEmpty) {
                ref.read(categoryListProvider.notifier).update((state) {
                  if (!state.contains(category)) {
                    return [...state, category];
                  }
                  return state;
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _deleteProductDialog(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        elevation: 6,
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            const SizedBox(width: 8),
            Text(
              'Delete Product',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete this product?',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(productListProvider.notifier).update((state) =>
                  state.where((product) => product.id != id).toList());
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.delete_forever),
            label: Text(
              'Delete',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void showQrCodeDialog(BuildContext context, String data) {
    final screenshotController = ScreenshotController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 340),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Scan QR Code",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),

                  /// QR Code inside Screenshot
                  Screenshot(
                    controller: screenshotController,
                    child: QrImageView(
                      data: data,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),

                  SizedBox(height: 16),
                  Text(
                    data,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  /// Row of Action Buttons: Share - Download - Print
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      /// Share Button
                      ElevatedButton.icon(
                        onPressed: () => Share.share(data),
                        icon: Icon(Icons.share),
                        label: Text("Share"),
                        style: _buttonStyle(Colors.blue),
                      ),

                      /// Download Button
                      ElevatedButton.icon(
                        onPressed: () async {
                          final image = await screenshotController.capture();
                          if (image != null) {
                            final directory = await getApplicationDocumentsDirectory();
                            final path = '${directory.path}/qr_code.png';
                            final file = File(path);
                            await file.writeAsBytes(image);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("QR saved to $path")),
                            );
                          }
                        },
                        icon: Icon(Icons.download),
                        label: Text("Download"),
                        style: _buttonStyle(Colors.green),
                      ),

                      /// Print Button
                      ElevatedButton.icon(
                        onPressed: () async {
                          final image = await screenshotController.capture();
                          if (image != null) {
                            await Printing.layoutPdf(
                              onLayout: (PdfPageFormat format) async => image,
                            );
                          }
                        },
                        icon: Icon(Icons.print),
                        label: Text("Print"),
                        style: _buttonStyle(Colors.orange),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  /// Close Button
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                    label: Text("Close"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Helper method to style buttons
  ButtonStyle _buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
