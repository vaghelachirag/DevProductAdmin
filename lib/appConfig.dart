import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AppConfig {
  static Map<String, dynamic>? _config;

  static Future<void> load() async {
    final jsonString = await rootBundle.loadString('assets/config/env.json');
    _config = json.decode(jsonString) as Map<String, dynamic>;
  }

  static String? get(String key) {
    return _config?[key];
  }
}
