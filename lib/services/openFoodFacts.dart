import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenFoodFactsService {
  static const String baseUrl = "https://world.openfoodfacts.org/api/v0/product/";

  /// Cerca un prodotto per barcode (EAN)
  static Future<Map<String, dynamic>?> fetchProduct(String barcode) async {
    final url = Uri.parse("$baseUrl$barcode.json");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["status"] == 1) {
        return data["product"];
      } else {
        return null; // prodotto non trovato
      }
    } else {
      throw Exception("Errore nella connessione con OpenFoodFacts");
    }
  }
}
