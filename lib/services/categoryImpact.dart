import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CategoryImpactService {
  static Map<String, double>? _cache;

  static Future<Map<String, double>> loadImpacts() async {
    if (_cache != null) return _cache!;
    final String data = await rootBundle.loadString('assets/data/co2_per_category.json');
    final Map<String, dynamic> json = jsonDecode(data);
    _cache = json.map((key, value) => MapEntry(key, (value as num).toDouble()));
    return _cache!;
  }

  static Future<double> getImpact(String category) async {
    final impacts = await loadImpacts();
    return impacts[category] ?? 2.0; // fallback generico
  }
}
