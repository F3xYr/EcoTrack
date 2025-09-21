import 'package:flutter/material.dart';
import '../services/storage.dart';
import '../models/product.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final storage = StorageService();
  late List<Product> items;

  @override
  void initState() {
    super.initState();
    items = storage.getAll();
  }

  void refresh() {
    setState(() {
      items = storage.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Storico'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever, color: Color(0xFF2E7D32)),
            onPressed: () async {
              await storage.clearAll();
              refresh();
            },
          )
        ],
      ),
      body: items.isEmpty
          ? Center(child: Text('Nessun acquisto registrato', style: TextStyle(color: Color(0xFF586776))))
          : ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, index) {
                final p = items[index];
                return ListTile(
                  title: Text(p.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text('Alternativa: ${p.alternative}'),
                  trailing: Text('${p.co2.toStringAsFixed(1)} kg CO₂', style: TextStyle(fontWeight: FontWeight.bold)),
                );
              },
            ),
    );
  }
}
