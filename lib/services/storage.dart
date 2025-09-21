import 'package:hive/hive.dart';
import '../models/product.dart';

class StorageService {
  final Box<Product> box = Hive.box<Product>('history');

  Future<void> addProduct(Product p) async {
    await box.add(p);
  }

  List<Product> getAll() {
    return box.values.toList().reversed.toList();
  }

  Future<void> clearAll() async {
    await box.clear();
  }

  Future<void> deleteAt(int index) async {
    await box.deleteAt(index);
  }
}
