import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shopkeeper_admin/gen/assets.gen.dart';

class BillDetailScreen extends StatelessWidget {
  final String billNo;
  final String customerName;
  final String mobileNumber;
  final String address;
  final String productName;
  final String price;
  final String qty;
  final String totalAmount ;

  const BillDetailScreen({
    super.key,
    required this.billNo,
    required this.customerName,
    required this.mobileNumber,
    required this.address,
    required this.productName,
    required this.price,
    required this.qty,
    required this.totalAmount,
  });

  Future<Uint8List> _generateBillPdf() async {
    final pdf = pw.Document();

    // Load custom font
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    // Load shop logo
    final logoData = await rootBundle.load(Assets.images.appLogo.path);
    final logo = pw.MemoryImage(logoData.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header with Logo and Shop Name
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(
                      width: 120,
                      height: 120,
                      child: pw.Image(logo),
                    ),
                    pw.SizedBox(width: 15),
                    pw.Text("Dev",
                        style: pw.TextStyle(
                            font: ttf,
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text("Customer: $customerName", style: pw.TextStyle(font: ttf)),
                pw.Text("Mobile: $mobileNumber", style: pw.TextStyle(font: ttf)),
                pw.Text("Address: $address", style: pw.TextStyle(font: ttf)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: ["Item Name", "Category", "Price", "Qty", "Total"],
                  data: [
                    [productName, productName, "₹$price", qty, "₹$totalAmount"],
                  ],
                  cellAlignments: {
                    0: pw.Alignment.center, // Item Name
                    1: pw.Alignment.center, // Category
                    2: pw.Alignment.center, // Price
                    3: pw.Alignment.center, // Qty
                    4: pw.Alignment.center, // Total
                  },
                )
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bill Preview")),
      body: PdfPreview(
        build: (format) => _generateBillPdf(),
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        allowPrinting: true,  // ✅ enable print
        allowSharing: true,   // ✅ enable share/download
      ),
    );
  }
}
