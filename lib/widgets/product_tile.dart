import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product p;
  const ProductTile({required this.p});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(p.name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('Alternative: ${p.alternative}'),
      trailing: Text('${p.co2.toStringAsFixed(1)} kg CO₂'),
    );
  }
}
