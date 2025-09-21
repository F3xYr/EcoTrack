import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'screens/home.dart';
import 'theme/colors.dart';
import 'models/product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDir.path);

  // Registrazione adapter se Hive per Product
  Hive.registerAdapter(ProductAdapter());

  await Hive.openBox('userStats');
  await Hive.openBox<Product>('history');

  runApp(const EcoTrackApp());
}

class EcoTrackApp extends StatelessWidget {
  const EcoTrackApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoTrack',
      theme: ThemeData(
        scaffoldBackgroundColor: EcoColors.background,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: EcoColors.primary,
          onPrimary: Colors.white,
          secondary: EcoColors.secondary,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: EcoColors.background,
          onBackground: EcoColors.dark,
          surface: Colors.white,
          onSurface: EcoColors.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: EcoColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: EcoColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: EcoColors.dark),
          bodyLarge: TextStyle(color: EcoColors.dark),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
