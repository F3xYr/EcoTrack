import 'dart:io';
import 'package:ecotrack/screens/home.dart';
import 'package:ecotrack/services/streak.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
//import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../models/product.dart';
import '../services/storage.dart';
import '../services/scanner.dart';
import '../services/openFoodFacts.dart';
import '../services/categoryMapper.dart';
import '../screens/productDetail.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  StorageService? storage;
  StreakService? streakService;

  final picker = ImagePicker();
  String _status = "Seleziona un'opzione per iniziare";
  bool isProcessing = false;
  bool showCamera = false;
  bool isReady = false; // indica se Hive è pronto

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    try{
      // Attende che Hive sia pronto
      storage = StorageService();
      streakService = StreakService();
      setState(() {
        isReady = true;
      });
    } catch (e){
      setState(() {
        isReady = false;
      });
    }
  }

  /// OCR: foto scontrino
  /*Future<void> _scanReceipt() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedFile == null) return;

    setState(() => _status = "Analisi OCR in corso...");

    final File imageFile = File(pickedFile.path);
    final lines = await scannerService.processOcrImage(imageFile);

    int added = 0;
    for (String line in lines) {
      final product = await scannerService.lookupProduct(line);
      if (product != null) {
        await storage.addProduct(product);
        added++;
      }
    }

    setState(() {
      _status = added > 0
          ? "OCR completato: $added prodotti aggiunti ✅"
          : "Nessun prodotto riconosciuto ❌";
    });
  }*/

  /// Barcode scanner
  /*void _onDetect(BarcodeCapture capture) async {
    if (isProcessing) return;
    isProcessing = true;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final rawValue = barcodes.first.rawValue ?? "Codice sconosciuto";
      setState(() => _status = "Trovato: $rawValue");

      final product = await scannerService.lookupProduct(rawValue);
      if (product != null) {
        await storage.addProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Aggiunto: ${product.name}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Prodotto non trovato nel dataset")),
        );
      }
    }

    isProcessing = false;
  }*/

void _onDetect(BarcodeCapture capture) async {
  if (!isReady || isProcessing) return;
  isProcessing = true;

  final List<Barcode> barcodes = capture.barcodes;
  if (barcodes.isNotEmpty) {
    final rawValue = barcodes.first.rawValue ?? "Codice sconosciuto";
    setState(() => _status = "Trovato: $rawValue");

    final productData = await OpenFoodFactsService.fetchProduct(rawValue);
    streakService!.updateStreak();

    if (productData != null) {
      String name = productData["product_name"] ?? "Prodotto sconosciuto";
      List<String> tags = List<String>.from(productData["categories_tags"] ?? []);
      double co2 = await CategoryMapper.getImpactFromTags(tags);

      final product = Product(name: name, co2: co2, alternative: "N/A");
      await storage?.addProduct(product);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(name: name, co2: co2),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ProductDetailScreen(name: "Prodotto non trovato", co2: 0),
        ),
      );
    }
  }

  isProcessing = false;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scanner")),
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!showCamera) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => setState(() => showCamera = true),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Scansiona Barcode"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed:  null/*_scanReceipt*/,
              icon: const Icon(Icons.receipt_long),
              label: const Text("Scansiona Scontrino (OCR)"),
            ),
          ] else ...[
            Expanded(
              child: MobileScanner(
                fit: BoxFit.cover,
                onDetect: _onDetect,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => setState(() => showCamera = false),
              icon: const Icon(Icons.close),
              label: const Text("Chiudi Scanner"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            _status,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
        ],
      ),
      ),
    );
  }
}


