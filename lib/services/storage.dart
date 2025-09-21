import 'package:hive/hive.dart';
import '../models/product.dart';

class StorageService {
  late final Box<Product> _box;

  StorageService() {
    _box = Hive.box<Product>('history'); // già aperto in main.dart
  }

  Future<void> addProduct(Product p) async => await _box.add(p);

  List<Product> getAll() => _box.values.toList().reversed.toList();

  Future<void> clearAll() async => await _box.clear();

  Future<void> deleteAt(int index) async => await _box.deleteAt(index);
}
