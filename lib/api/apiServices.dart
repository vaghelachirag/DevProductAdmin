import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shopkeeper_admin/model/billing_list_model.dart';

import '../model/product_model.dart';

class ApiService {
  final String _baseUrl = dotenv.env['APPS_SCRIPT_URL'] ?? '';

   Future<List<Map<String, dynamic>>> fetchCategories() async {
    final Uri url = Uri.parse("$_baseUrl?action=getProduct");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((e) => {
        "id": e["id"],
        "categoryname": e["categoryname"],
      })
          .toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }


  Future<Map<String, dynamic>> fetchDashboardData() async {
    final Uri url = Uri.parse("$_baseUrl?action=getDashboardStats");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (jsonData["success"] == true) {
        return {
          "date": jsonData["date"],
          "billCount": jsonData["billCount"],
          "totalRevenue": jsonData["totalRevenue"],
          "monthlyRevenue": jsonData["monthlyRevenue"],
          "lowStockCount": jsonData["lowStockCount"],
        };
      } else {
        throw Exception("API returned success=false");
      }
    } else {
      throw Exception("Failed to load dashboard data");
    }
  }


  Future<bool> addCategory(String categoryName) async {
    final Uri url = Uri.parse("$_baseUrl?action=addCategory");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"categoryname": categoryName}),
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      return res["success"] == true;
    } else {
      throw Exception("Failed to add category");
    }
  }

  // lib/services/api_service.dart
  Future<List<Map<String, dynamic>>> fetchProductsByCategory(String category) async {

    final Uri url = Uri.parse("$_baseUrl?sheet=ProductEntries&category=$category");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => {
        "id": e["id"],
        "productname": e["productname"],
        "category": e["category"],
        "price": e["price"],
        "qty": e["qty"],
      }).toList();
    } else {
      throw Exception("Failed to load products for $category");
    }
  }


  Future<List<ProductModel>> fetchProduct() async {
    final Uri url = Uri.parse("$_baseUrl?action=getProduct");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json is Map<String, dynamic> && json['data'] is List) {
        final List<dynamic> list = json['data'];
        return list.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        throw Exception("Invalid response format");
      }
    } else {
      throw Exception("Failed to fetch bills");
    }
  }

  Future<List<BillingListModel>> getBillsByDate(String date) async {
    final url = Uri.parse("$_baseUrl?action=getBill&date=$date");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json is Map<String, dynamic> && json['data'] is List) {
        final List<dynamic> list = json['data'];
        return list.map((e) => BillingListModel.fromJson(e)).toList();
      } else {
        throw Exception("Invalid response format");
      }
    } else {
      throw Exception("Failed to fetch bills");
    }
  }
}
