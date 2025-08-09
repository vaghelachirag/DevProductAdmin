import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PDFInvoiceWebService {
  static Future<Uint8List> generateInvoice({
    required String customerName,
    required String address,
    required String mobile,
    required List<Map<String, dynamic>> products,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Invoice', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Text('Customer Name: $customerName'),
            pw.Text('Address: $address'),
            pw.Text('Mobile: $mobile'),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: ['ID', 'Product', 'Qty', 'Price', 'Total'],
              data: products.map((prod) {
                final total = prod['qty'] * prod['price'];
                return [
                  prod['id'],
                  prod['name'],
                  prod['qty'].toString(),
                  '₹${prod['price']}',
                  '₹$total',
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 16),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Grand Total: ₹200',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );

    return pdf.save(); // Returns Uint8List
  }
}
