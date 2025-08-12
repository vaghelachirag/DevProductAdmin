import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiServices {
  // Get from .env
  final String scriptUrl = dotenv.env['APPS_SCRIPT_URL'] ?? '';
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  Future<Map<String, dynamic>> addProduct({
    required String product,
    required String category,
    required String purchasePrice,
    required String qty,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(scriptUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "apiKey": apiKey, // send API key if needed
          "product": product,
          "category": category,
          "purchaseprice": purchasePrice,
          "qty": qty,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": data["success"] ?? false,
          "id": data["id"],
        };
      } else {
        return {
          "success": false,
          "error": "Failed with status: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }
}
