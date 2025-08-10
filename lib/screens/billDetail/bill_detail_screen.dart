import 'dart:typed_data';
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
  final List<Map<String, dynamic>> items;

  const BillDetailScreen({
    super.key,
    required this.billNo,
    required this.customerName,
    required this.mobileNumber,
    required this.address,
    required this.items,
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
                pw.Text("Customer: Rahul Shah", style: pw.TextStyle(font: ttf)),
                pw.Text("Mobile: 9876543210", style: pw.TextStyle(font: ttf)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: ["Item ID", "Price", "Qty", "Total"],
                  data: [
                    ["P001", "₹120", "2", "₹240"],
                    ["P002", "₹75", "3", "₹225"],
                  ],
                  headerStyle: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
                  cellStyle: pw.TextStyle(font: ttf),
                ),
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
