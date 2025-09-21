import 'package:hive/hive.dart';
part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double co2; // kg CO2

  @HiveField(2)
  String alternative;

  @HiveField(3)
  DateTime date;

  Product({
    required this.name,
    required this.co2,
    required this.alternative,
    DateTime? date,
  }) : this.date = date ?? DateTime.now();
}
