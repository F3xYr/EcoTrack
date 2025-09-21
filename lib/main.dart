import 'package:flutter/material.dart';
import 'screens/home.dart'; // assicurati di avere la tua HomeScreen qui
import 'theme/colors.dart'; // nuovo file con i colori

void main() {
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: EcoColors.dark),
          bodyLarge: TextStyle(color: EcoColors.dark),
        ),
      ),
      home: HomeScreen(), // tua schermata principale
    );
  }
}
