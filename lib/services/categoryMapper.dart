import 'categoryImpact.dart';

class CategoryMapper {
  /// Mappa categorie OFF → categorie OWID
  static const Map<String, String> _mapping = {
    // Carne
    "beef": "Beef",
    "veal": "Beef",
    "lamb": "Lamb",
    "mutton": "Lamb",
    "pork": "Pork",
    "pig": "Pork",
    "chicken": "Poultry",
    "turkey": "Poultry",
    "duck": "Poultry",
    "meat": "Pork", // fallback generico
    // Pesce
    "fish": "Fish",
    "seafood": "Fish",
    // Latticini
    "milk": "Milk",
    "cheese": "Cheese",
    "yogurt": "Milk",
    "butter": "Cheese",
    "dairy": "Milk",
    // Uova
    "egg": "Eggs",
    "eggs": "Eggs",
    // Cereali / Pasta / Riso
    "rice": "Rice",
    "pasta": "Rice",
    "wheat": "Rice",
    "cereal": "Rice",
    "bread": "Rice",
    // Verdura / Frutta
    "vegetable": "Vegetables",
    "vegetables": "Vegetables",
    "fruit": "Fruits",
    "fruits": "Fruits",
    "apple": "Fruits",
    "banana": "Fruits",
    // Legumi / Noci
    "legume": "Legumes",
    "peas": "Peas",
    "beans": "Legumes",
    "lentils": "Legumes",
    "nuts": "Nuts",
    "almonds": "Nuts",
    "hazelnuts": "Nuts",
    // Tuberi
    "potato": "Potatoes",
    "potatoes": "Potatoes",
  };

  /// Restituisce il nome della categoria OWID data una lista di tags OFF
  static Future<String> mapToOwIdCategory(List<String> offTags) async {
    for (final raw in offTags) {
      // Normalizza: rimuove prefisso lingua ("en:", "it:", ecc.)
      final key = raw.replaceAll(RegExp(r'^[a-z]{2}:'), '').toLowerCase();
      if (_mapping.containsKey(key)) {
        return _mapping[key]!;
      }
    }
    return "Vegetables"; // fallback se non trovato
  }

  /// Restituisce il valore CO₂ in base ai tags
  static Future<double> getImpactFromTags(List<String> offTags) async {
    final category = await mapToOwIdCategory(offTags);
    return await CategoryImpactService.getImpact(category);
  }
}
