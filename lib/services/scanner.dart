import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
//import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../models/product.dart';

class ScannerService {
  /// Cerca un prodotto nel dataset locale JSON
  Future<Product?> lookupProduct(String query) async {
    final String data =
        await rootBundle.loadString('assets/data/products_mock.json');
    final List<dynamic> products = jsonDecode(data);

    for (var p in products) {
      if (p['name'].toString().toLowerCase().contains(query.toLowerCase())) {
        return Product(
          name: p['name'],
          co2: (p['co2'] as num).toDouble(),
          alternative: p['alternative'],
        );
      }
    }
    return null;
  }

  /// OCR: estrae linee di testo da un’immagine
  /*Future<List<String>> processOcrImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    return recognizedText.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }
  */
}
