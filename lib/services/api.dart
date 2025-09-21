import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>?> lookupProduct(String query) async {
    try {
      final resp = await http.post(
        Uri.parse('$baseUrl/calculate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'product': query}),
      );
      if (resp.statusCode == 200) {
        return jsonDecode(resp.body) as Map<String, dynamic>;
      }
    } catch (e) {
      print('API error: $e');
    }
    return null;
  }
}
