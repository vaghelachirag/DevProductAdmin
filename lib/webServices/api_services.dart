import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleSheetService {
  final String scriptUrl = "YOUR_DEPLOYED_SCRIPT_URL";

  Future<Map<String, dynamic>> addProduct({
    required String productName,
    required String category,
    required double purchasePrice,
    required int qty,
  }) async {
    final body = {
      "type": "product",
      "product": productName,
      "category": category,
      "purchaseprice": purchasePrice,
      "qty": qty,
    };

    final res = await http.post(
      Uri.parse(scriptUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    return jsonDecode(res.body);
  }
}
