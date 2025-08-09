import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../widgets/pdf_invoice.dart';

class BillDetailScreen extends StatelessWidget {
  const BillDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customerName = "Web Customer";
    final address = "456 Dart Lane, Flutter Web";
    final mobile = "9998887776";

    final products = [
      {"id": "W001", "name": "Web Widget", "qty": 3, "price": 150},
      {"id": "W002", "name": "Cloud Gadget", "qty": 2, "price": 300},
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Web Invoice Generator")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final pdfBytes = await PDFInvoiceWebService.generateInvoice(
              customerName: customerName,
              address: address,
              mobile: mobile,
              products: products,
            );

            // Download or view in browser
            await Printing.sharePdf(bytes: pdfBytes, filename: 'invoice.pdf');
            // OR
            // await Printing.layoutPdf(onLayout: (format) async => pdfBytes); // opens print preview
          },
          child: Text("Generate & Download PDF"),
        ),
      ),
    );
  }
}
