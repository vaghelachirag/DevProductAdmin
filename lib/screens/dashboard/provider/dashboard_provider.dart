import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../api/apiServices.dart';

const String _baseUrl = "YOUR_SCRIPT_URL_HERE"; // Replace with your Apps Script URL

/// Dashboard model
class DashboardStats {
  final String date;
  final int billCount;
  final double totalRevenue;
  final double monthlyRevenue;
  final int lowStockCount;

  DashboardStats({
    required this.date,
    required this.billCount,
    required this.totalRevenue,
    required this.monthlyRevenue,
    required this.lowStockCount,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      date: json["date"] ?? "",
      billCount: json["billCount"] ?? 0,
      totalRevenue: (json["totalRevenue"] ?? 0).toDouble(),
      monthlyRevenue: (json["monthlyRevenue"] ?? 0).toDouble(),
      lowStockCount: json["lowStockCount"] ?? 0,
    );
  }
}


/// Provider for fetching Dashboard stats
final dashboardStatsProvider =
FutureProvider<Map<String, dynamic>>((ref) async {
  try {
    final response = await ApiService().fetchDashboardData();

    if (response.isNotEmpty) {
      return response;
    } else {
      throw Exception("No data found");
    }
  } catch (e, st) {
    // Report error to Riverpod (debugging, error UI)
    throw Exception("Failed to load dashboard stats: $e");
  }
});


